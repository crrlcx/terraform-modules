# Providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
  }
  required_version = ">= 0.13"
}
provider "aws" {
  profile                 = var.aws_service_account
  region                  = var.aws_region
  shared_credentials_file = var.aws_creds_file
}

# Create local variables
locals {
  aws_route53_zone_healthchecks = fileexists("resources/aws_route53.${var.aws_route53_zone}healthchecks.csv") ? csvdecode(file("resources/aws_route53.${var.aws_route53_zone}healthchecks.csv")) : []
  aws_route53_zone_records      = fileexists("resources/aws_route53.${var.aws_route53_zone}records.csv") ? csvdecode(file("resources/aws_route53.${var.aws_route53_zone}records.csv")) : []
}

# Create DNS zones in AWS Route53
resource "aws_route53_zone" "dns_zone" {
  name          = var.aws_route53_zone
  comment       = var.aws_route53_zone_comment
  force_destroy = false
}

# Create default DNS records in AWS Route53
resource "aws_route53_record" "NS_record" {
  name            = aws_route53_zone.dns_zone.name
  zone_id         = aws_route53_zone.dns_zone.zone_id
  allow_overwrite = true
  ttl             = 172800
  type            = "NS"
  records = [
    "${aws_route53_zone.dns_zone.name_servers[0]}.",
    "${aws_route53_zone.dns_zone.name_servers[1]}.",
    "${aws_route53_zone.dns_zone.name_servers[2]}.",
    "${aws_route53_zone.dns_zone.name_servers[3]}.",
  ]
}
resource "aws_route53_record" "SOA_record" {
  name            = aws_route53_zone.dns_zone.name
  zone_id         = aws_route53_zone.dns_zone.zone_id
  allow_overwrite = true
  ttl             = 86400
  type            = "SOA"
  records = [
    "${aws_route53_zone.dns_zone.name_servers[0]}. awsdns-hostmaster.amazon.com. ${var.aws_route53_zone_soa_serial} 7200 900 1209600 86400"
  ]
  depends_on = [
    aws_route53_record.NS_record
  ]
}
resource "aws_route53_record" "CAA_record" {
  name            = aws_route53_zone.dns_zone.name
  zone_id         = aws_route53_zone.dns_zone.zone_id
  allow_overwrite = true
  ttl             = 86400
  type            = "CAA"
  records         = var.aws_route53_zone_caa_records
}

# Create healthchecks for records
resource "aws_route53_health_check" "dns_healthchecks" {
  for_each = { for dns_healthcheck in local.aws_route53_zone_healthchecks :
    join("_", [dns_healthcheck.type, dns_healthcheck.port, dns_healthcheck.record_name, aws_route53_zone.dns_zone.name]) => dns_healthcheck
  }

  failure_threshold = each.value.failure_threshold
  port              = each.value.port
  request_interval  = each.value.request_interval
  type              = upper(each.value.type)

  ip_address = upper(each.value.type) == "TCP" ? each.value.address : null

  fqdn            = upper(each.value.type) == "HTTPS" ? each.value.address : null
  measure_latency = upper(each.value.type) == "HTTPS" ? bool(each.value.measure_latency) : false
  enable_sni      = upper(each.value.type) == "HTTPS" ? bool(each.value.enable_sni) : false
  resource_path   = upper(each.value.type) == "HTTPS" ? each.value.resource_path : null

  regions = [
    "us-west-1",
    "eu-west-1",
    "us-east-1",
  ]

  tags = {
    Name = join("_", [each.value.type, each.value.port, replace(each.value.record_name, "*", "_"), aws_route53_zone.dns_zone.name]),
    Tag  = "terraform",
  }

  lifecycle {
    create_before_destroy = false
  }
}

# Create DNS records in AWS Route53 from the resource file
resource "aws_route53_record" "dns_records" {
  for_each = { for dns_record in local.aws_route53_zone_records :
    join("_", [aws_route53_zone.dns_zone.name, dns_record.record_name, dns_record.type, dns_record.set_identifier]) => dns_record
  }

  name    = each.value.record_name != "" ? join(".", [each.value.record_name, aws_route53_zone.dns_zone.name]) : aws_route53_zone.dns_zone.name
  zone_id = aws_route53_zone.dns_zone.zone_id

  allow_overwrite = true
  records         = sort(split(", ", each.value.records))
  ttl             = each.value.ttl
  type            = each.value.type

  health_check_id = each.value.failover_routing_policy != "" ? aws_route53_health_check.dns_healthchecks["${join("_", ["tcp", "443", each.value.record_name, aws_route53_zone.dns_zone.name])}"].id : null
  set_identifier  = each.value.set_identifier != "" ? each.value.set_identifier : null

  dynamic "geolocation_routing_policy" {
    for_each = slice(
      [{
        country = each.value.geolocation_routing_policy != "" ? each.value.geolocation_routing_policy : 0
    }, ], 0, each.value.geolocation_routing_policy != "" ? 1 : 0)
    content {
      country = geolocation_routing_policy.value.country
    }
  }
  dynamic "failover_routing_policy" {
    for_each = slice(
      [{
        type = each.value.failover_routing_policy != "" ? upper(each.value.failover_routing_policy) : 0
    }, ], 0, each.value.failover_routing_policy != "" ? 1 : 0)
    content {
      type = failover_routing_policy.value.type
    }
  }
  dynamic "weighted_routing_policy" {
    for_each = slice(
      [{
        weight = each.value.weighted_routing_policy != "" ? each.value.weighted_routing_policy : 0
    }, ], 0, each.value.weighted_routing_policy != "" ? 1 : 0)
    content {
      weight = weighted_routing_policy.value.weight
    }
  }

  lifecycle {
    create_before_destroy = false
  }
}

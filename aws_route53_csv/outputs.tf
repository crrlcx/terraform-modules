# Outputs
output "dns_zone_id" {
  description = "Print zone id"
  value       = aws_route53_zone.dns_zone.zone_id
}

output "dns_zone_nameservers" {
  description = "Print zone nameservers"
  value       = aws_route53_zone.dns_zone.name_servers
}

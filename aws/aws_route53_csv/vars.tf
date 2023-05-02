# Zone variables
variable "aws_route53_zone" {
  default = "example.com"
}
variable "aws_route53_zone_comment" {
  default = "Managed by Terraform"
}
variable "aws_route53_zone_soa_serial" {
  default = "2020010001"
}
variable "aws_route53_zone_caa_records" {
  type = list(string)
  default = [
    "128 issuewild \"letsencrypt.org\"",
    "128 issue \"letsencrypt.org\"",
  ]
}

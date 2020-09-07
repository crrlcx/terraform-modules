## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| aws | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_creds\_file | n/a | `any` | `null` | no |
| aws\_region | n/a | `string` | `"us-west-1"` | no |
| aws\_route53\_zone | Project variables | `string` | `"example.com."` | no |
| aws\_route53\_zone\_caa\_records | n/a | `list(string)` | <pre>[<br>  "128 issuewild \"letsencrypt.org\"",<br>  "128 issue \"letsencrypt.org\""<br>]</pre> | no |
| aws\_route53\_zone\_comment | n/a | `string` | `"Managed by Terraform"` | no |
| aws\_route53\_zone\_soa\_serial | n/a | `string` | `"2020010001"` | no |
| aws\_service\_account | Provider variables | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| dns\_zone\_id | Print zone id |
| dns\_zone\_nameservers | Print zone nameservers |


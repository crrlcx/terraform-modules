## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| libvirt | >= 0.6.0 |

## Providers

| Name | Version |
|------|---------|
| libvirt | >= 0.6.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| base\_pool | Base pool and volumes | `any` | `null` | no |
| base\_volume\_boot | n/a | `any` | `null` | no |
| base\_volume\_system | n/a | `any` | `null` | no |
| ip\_base | Project | `any` | `null` | no |
| ips | n/a | `any` | `null` | no |
| network\_id | n/a | `any` | `null` | no |
| pool | n/a | `any` | `null` | no |
| project | n/a | `any` | `null` | no |
| vm\_autostart | Default vm variables | `bool` | `false` | no |
| vm\_count | n/a | `number` | `0` | no |
| vm\_data\_size | n/a | `number` | `0` | no |
| vm\_ip\_base | n/a | `number` | `0` | no |
| vm\_memory | n/a | `number` | `512` | no |
| vm\_prefix | n/a | `string` | `"vm-"` | no |
| vm\_running | n/a | `bool` | `false` | no |
| vm\_vcpu | n/a | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| hostname | Print vm output |
| ip | n/a |


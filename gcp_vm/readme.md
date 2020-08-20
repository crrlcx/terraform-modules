## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| google | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| google | >= 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| gcp\_creds | Provider variables | `any` | `null` | no |
| gcp\_project\_id | Project variables | `any` | `null` | no |
| gcp\_project\_ip\_base | n/a | `any` | `null` | no |
| gcp\_project\_network | n/a | `any` | `null` | no |
| gcp\_project\_region | n/a | `string` | `"us-west1"` | no |
| gcp\_project\_service\_account | n/a | `any` | `null` | no |
| gcp\_project\_subnetwork | n/a | `any` | `null` | no |
| gcp\_vm\_allow\_stopping\_for\_update | Default vm variables | `bool` | `false` | no |
| gcp\_vm\_attached\_size | Default vm disk variables | `number` | `0` | no |
| gcp\_vm\_attached\_suffix | n/a | `string` | `"-data"` | no |
| gcp\_vm\_attached\_type | n/a | `string` | `"pd-ssd"` | no |
| gcp\_vm\_boot\_image | n/a | `string` | `""` | no |
| gcp\_vm\_boot\_image\_family | n/a | `string` | `""` | no |
| gcp\_vm\_boot\_image\_project | n/a | `string` | `"ubuntu-os-cloud"` | no |
| gcp\_vm\_boot\_size | n/a | `number` | `10` | no |
| gcp\_vm\_boot\_suffix | n/a | `string` | `"-system"` | no |
| gcp\_vm\_boot\_type | n/a | `string` | `"pd-standard"` | no |
| gcp\_vm\_can\_ip\_forward | n/a | `bool` | `false` | no |
| gcp\_vm\_count | n/a | `number` | `0` | no |
| gcp\_vm\_deletion\_protection | n/a | `bool` | `false` | no |
| gcp\_vm\_enable\_display | n/a | `bool` | `false` | no |
| gcp\_vm\_ip\_base | n/a | `number` | `0` | no |
| gcp\_vm\_machine\_type | n/a | `string` | `"e2-small"` | no |
| gcp\_vm\_need\_external\_ip | n/a | `bool` | `false` | no |
| gcp\_vm\_network\_tags | n/a | `list` | `[]` | no |
| gcp\_vm\_prefix | n/a | `string` | `"vm-"` | no |
| gcp\_vm\_zones | n/a | `list` | <pre>[<br>  "us-west1-a",<br>  "us-west1-b",<br>  "us-west1-c"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| gcp\_vm\_\_self\_link | Print instance link |
| gcp\_vm\_attached\_\_self\_link | Print instance additional disk link |
| gcp\_vm\_boot\_\_self\_link | Print instance system disk link |
| gcp\_vm\_external\_ip | Print instance global ip address |
| gcp\_vm\_internal\_ip | Print instance local ip address |
| gcp\_vm\_name | Print instance hostname |
| gcp\_vm\_zone | Print instance aviability zone |


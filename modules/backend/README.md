# BackendConfig CRD

This module manages the `BackendConfig` CRD.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_kubernetes-alpha"></a> [kubernetes-alpha](#requirement\_kubernetes-alpha) | >= 0.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes-alpha"></a> [kubernetes-alpha](#provider\_kubernetes-alpha) | >= 0.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes-alpha_kubernetes_manifest.backend_config](https://registry.terraform.io/providers/hashicorp/kubernetes-alpha/latest/docs/resources/kubernetes_manifest) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backend_config"></a> [backend\_config](#input\_backend\_config) | Name for the BackendConfig CRD | `string` | `"ambassador"` | no |
| <a name="input_cdn"></a> [cdn](#input\_cdn) | Enable Cloud CDN | <pre>object({<br>    enabled = bool<br>    # See https://cloud.google.com/kubernetes-engine/docs/how-to/ingress-features#configuring_ingress_features_through_backendconfig_parameters<br>    policy = optional(object({<br>      include_host           = optional(bool)<br>      include_protocol       = optional(bool)<br>      include_query_string   = optional(bool)<br>      query_string_blacklist = optional(list(string))<br>      query_string_whitelist = optional(list(string))<br>    }))<br>  })</pre> | <pre>{<br>  "enabled": false<br>}</pre> | no |
| <a name="input_cloud_armor_policy"></a> [cloud\_armor\_policy](#input\_cloud\_armor\_policy) | Name of the Cloud Armor Policy to use | `string` | `""` | no |
| <a name="input_connection_draining_timeout_sec"></a> [connection\_draining\_timeout\_sec](#input\_connection\_draining\_timeout\_sec) | connection draining timeout is the time, in seconds, to wait for connections to drain | `number` | `0` | no |
| <a name="input_custom_request_headers"></a> [custom\_request\_headers](#input\_custom\_request\_headers) | Map of Custom Request Headers | `map(string)` | `{}` | no |
| <a name="input_health_check"></a> [health\_check](#input\_health\_check) | Health Check Configuration | <pre>object({<br>    interval            = optional(number)<br>    timeout             = optional(number)<br>    health_threshold    = optional(number)<br>    unhealthy_threshold = optional(number)<br>    protocol            = optional(string)<br>    path                = optional(string)<br>    port                = optional(number)<br>  })</pre> | <pre>{<br>  "interval": 10,<br>  "path": "/ambassador/v0/check_alive",<br>  "port": 8877,<br>  "protocol": "HTTP",<br>  "timeout": 10<br>}</pre> | no |
| <a name="input_iap"></a> [iap](#input\_iap) | Enable Identity-Aware Proxy by setting the secret name with the OAuth Client Credentials | `string` | `""` | no |
| <a name="input_kubernetes_labels"></a> [kubernetes\_labels](#input\_kubernetes\_labels) | Labels for the Kubernetes Resources | `map(string)` | <pre>{<br>  "app.kubernetes.io/instance": "ambassador",<br>  "app.kubernetes.io/managed-by": "Terraform",<br>  "app.kubernetes.io/name": "ambassador",<br>  "app.kubernetes.io/part-of": "ambassador"<br>}</pre> | no |
| <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace) | Namespace for the Kubernetes Resources | `string` | `"ambassador"` | no |
| <a name="input_logging"></a> [logging](#input\_logging) | Logging configuration for the endpoint | <pre>object({<br>    enable      = bool<br>    sample_rate = number<br>  })</pre> | <pre>{<br>  "enable": false,<br>  "sample_rate": 0.5<br>}</pre> | no |
| <a name="input_session_affinity"></a> [session\_affinity](#input\_session\_affinity) | Session affinity. Set type to empty to disable | <pre>object({<br>    type           = string<br>    cookie_ttl_sec = optional(number)<br>  })</pre> | <pre>{<br>  "type": ""<br>}</pre> | no |
| <a name="input_timeout_sec"></a> [timeout\_sec](#input\_timeout\_sec) | Configures the backend service timeout. See https://cloud.google.com/load-balancing/docs/backend-service#timeout-setting | `number` | `30` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend_config"></a> [backend\_config](#output\_backend\_config) | Name of the BackendConfig created |

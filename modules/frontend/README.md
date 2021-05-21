# Frontend Module

This module creates the ingress and (optionally) manages the `FrontendConfig` CRD for the ignress.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 3.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.1 |
| <a name="requirement_kubernetes-alpha"></a> [kubernetes-alpha](#requirement\_kubernetes-alpha) | >= 0.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 3.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.1 |
| <a name="provider_kubernetes-alpha"></a> [kubernetes-alpha](#provider\_kubernetes-alpha) | >= 0.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_address.internal](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) | resource |
| [google_compute_global_address.external](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) | resource |
| [google_compute_ssl_policy.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_ssl_policy) | resource |
| [kubernetes-alpha_kubernetes_manifest.frontend_config](https://registry.terraform.io/providers/hashicorp/kubernetes-alpha/latest/docs/resources/kubernetes_manifest) | resource |
| [kubernetes-alpha_kubernetes_manifest.managed_certificates](https://registry.terraform.io/providers/hashicorp/kubernetes-alpha/latest/docs/resources/kubernetes_manifest) | resource |
| [kubernetes_ingress.ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress) | resource |
| [google_compute_address.internal](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_address) | data source |
| [google_compute_global_address.external](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_global_address) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_http"></a> [allow\_http](#input\_allow\_http) | Allow plaintext HTTP traffic. Needs to be enabled for redirection. | `bool` | `true` | no |
| <a name="input_external"></a> [external](#input\_external) | Whether the ingress is external or internal. | `bool` | `true` | no |
| <a name="input_frontend_config"></a> [frontend\_config](#input\_frontend\_config) | Frontend Config CRD. Set to `null` to not use this at all | <pre>object({<br>    name   = string<br>    create = bool<br>  })</pre> | <pre>{<br>  "create": true,<br>  "name": "ambassador"<br>}</pre> | no |
| <a name="input_ingress_annotations"></a> [ingress\_annotations](#input\_ingress\_annotations) | Additional annotations for the ingress | `map(string)` | `{}` | no |
| <a name="input_ingress_name"></a> [ingress\_name](#input\_ingress\_name) | Name of the Kubernetes Ingress | `string` | `"ambassador"` | no |
| <a name="input_kubernetes_labels"></a> [kubernetes\_labels](#input\_kubernetes\_labels) | Labels for the Kubernetes Resources | `map(string)` | <pre>{<br>  "app.kubernetes.io/instance": "ambassador",<br>  "app.kubernetes.io/managed-by": "Terraform",<br>  "app.kubernetes.io/name": "ambassador",<br>  "app.kubernetes.io/part-of": "ambassador"<br>}</pre> | no |
| <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace) | Namespace for the Kubernetes Resources | `string` | `"ambassador"` | no |
| <a name="input_managed_certificates"></a> [managed\_certificates](#input\_managed\_certificates) | List of managed certificates to use or create. Key is the name | <pre>map(object({<br>    create  = optional(bool) # False by default<br>    domains = optional(list(string))<br>  }))</pre> | `{}` | no |
| <a name="input_pre_shared_certificates"></a> [pre\_shared\_certificates](#input\_pre\_shared\_certificates) | List of pre-shared certificates to use. See https://cloud.google.com/load-balancing/docs/ssl-certificates/self-managed-certs | `list(string)` | `[]` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project ID for resources. Defaults to provider configured project | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | Region for resources. Defaults to provider configured region | `string` | `null` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Name of Ambassador Service | `string` | `"ambassador"` | no |
| <a name="input_service_port"></a> [service\_port](#input\_service\_port) | Port of Ambaassador Service | `any` | `443` | no |
| <a name="input_ssl_policy"></a> [ssl\_policy](#input\_ssl\_policy) | SSL Policy. Set to `null` to not use any. | <pre>object({<br>    name   = string<br>    create = bool<br>  })</pre> | <pre>{<br>  "create": true,<br>  "name": "ambassador"<br>}</pre> | no |
| <a name="input_ssl_policy_settings"></a> [ssl\_policy\_settings](#input\_ssl\_policy\_settings) | Settings for SSL policy to create | <pre>object({<br>    description     = optional(string)<br>    profile         = optional(string)<br>    min_tls_version = optional(string)<br>    custom_features = optional(list(string))<br>  })</pre> | <pre>{<br>  "min_tls_version": "TLS_1_2",<br>  "profile": "MODERN"<br>}</pre> | no |
| <a name="input_ssl_redirect"></a> [ssl\_redirect](#input\_ssl\_redirect) | Redirect HTTP to HTTPS | <pre>object({<br>    enabled            = bool<br>    response_code_name = optional(string) # One of `MOVED_PERMANENTLY_DEFAULT` `FOUND`, `SEE_OTHER`, `TEMPORARY_REDIRECT`, `PERMANENT_REDIRECT`<br>  })</pre> | <pre>{<br>  "enabled": true,<br>  "response_code_name": "MOVED_PERMANENTLY_DEFAULT"<br>}</pre> | no |
| <a name="input_static_ip"></a> [static\_ip](#input\_static\_ip) | Static IP configuration | <pre>object({<br>    name   = string # Name to create or use<br>    create = bool<br><br>    description = optional(string)<br><br>    # Internal address only<br>    subnetwork   = optional(string) # Required for internal<br>    network_tier = optional(string)<br>    address      = optional(string) # IPv4 Address for an internal IP<br>  })</pre> | <pre>{<br>  "create": true,<br>  "name": "ambassadaor"<br>}</pre> | no |
| <a name="input_tls_secrets"></a> [tls\_secrets](#input\_tls\_secrets) | List of secrets to include in the ingress | <pre>list(object({<br>    hosts       = optional(list(string))<br>    secret_name = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_wait_for_load_balancer"></a> [wait\_for\_load\_balancer](#input\_wait\_for\_load\_balancer) | Wait for Load Balancer to be created successfully before returning | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ip_address"></a> [ip\_address](#output\_ip\_address) | IP Address for the endpoint |

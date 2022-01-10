# Terraform Ambassador on GCP

An opinionated module to deploy [Ambassador](https://www.getambassador.io/) on GCP, specifically
GKE. This might work on self-managed Kubernetes clusters, but it's not tested.

This module makes a set of assumptions:

- Ambassador is deployed behind either an Ingress or `LoadBalancer`
- TLS is enabled

If the assumptions do not hold, you can look at the source code of the root module and make use of
the individual modules.

## Pre-requisites

- GKE Cluster
- [Container-native load balancing](https://cloud.google.com/kubernetes-engine/docs/concepts/container-native-load-balancing)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 3.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_backend_config"></a> [backend\_config](#module\_backend\_config) | ./modules/backend | n/a |
| <a name="module_frontend"></a> [frontend](#module\_frontend) | ./modules/frontend | n/a |
| <a name="module_helm"></a> [helm](#module\_helm) | basisai/ambassador/helm | 1.0.0-alpha1 |

## Resources

| Name | Type |
|------|------|
| [google_compute_address.l4](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) | resource |
| [google_compute_address.l4](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_address) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_service_annotations"></a> [admin\_service\_annotations](#input\_admin\_service\_annotations) | Annotations for the admin service | `map(string)` | <pre>{<br>  "prometheus.io/scrape": "true"<br>}</pre> | no |
| <a name="input_affinity"></a> [affinity](#input\_affinity) | Pod Affinity | `any` | `{}` | no |
| <a name="input_allow_http"></a> [allow\_http](#input\_allow\_http) | Allow plaintext HTTP traffic. Needs to be enabled for redirection. | `bool` | `true` | no |
| <a name="input_ambassador_configurations"></a> [ambassador\_configurations](#input\_ambassador\_configurations) | Configuration options for Ambassador. See https://www.getambassador.io/docs/edge-stack/latest/topics/running/ambassador/ | `any` | <pre>{<br>  "diagnostics": {<br>    "enabled": false<br>  }<br>}</pre> | no |
| <a name="input_ambassador_id"></a> [ambassador\_id](#input\_ambassador\_id) | Ambassador ID | `string` | `"default"` | no |
| <a name="input_backend_config"></a> [backend\_config](#input\_backend\_config) | Name for the BackendConfig CRD. Defaults to chart release name | `string` | `""` | no |
| <a name="input_cdn"></a> [cdn](#input\_cdn) | Enable Cloud CDN | <pre>object({<br>    enabled = bool<br>    # See https://cloud.google.com/kubernetes-engine/docs/how-to/ingress-features#configuring_ingress_features_through_backendconfig_parameters<br>    policy = optional(object({<br>      include_host           = optional(bool)<br>      include_protocol       = optional(bool)<br>      include_query_string   = optional(bool)<br>      query_string_blacklist = optional(list(string))<br>      query_string_whitelist = optional(list(string))<br>    }))<br>  })</pre> | <pre>{<br>  "enabled": false<br>}</pre> | no |
| <a name="input_chart_namespace"></a> [chart\_namespace](#input\_chart\_namespace) | Namespace to run the chart in | `string` | `"ambassador"` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Version of Chart to install. Set to empty to install the latest version | `string` | `"7.2.0"` | no |
| <a name="input_cloud_armor_policy"></a> [cloud\_armor\_policy](#input\_cloud\_armor\_policy) | Name of the Cloud Armor Policy to use | `string` | `""` | no |
| <a name="input_connection_draining_timeout_sec"></a> [connection\_draining\_timeout\_sec](#input\_connection\_draining\_timeout\_sec) | connection draining timeout is the time, in seconds, to wait for connections to drain | `number` | `0` | no |
| <a name="input_container_security_context"></a> [container\_security\_context](#input\_container\_security\_context) | Container securityContext | `any` | `{}` | no |
| <a name="input_crd_manifest"></a> [crd\_manifest](#input\_crd\_manifest) | Provide a custom CRD Manifest to be created. Otherwise, the version corresponding to var.image\_tag will be used | `string` | `null` | no |
| <a name="input_create_default_listeners"></a> [create\_default\_listeners](#input\_create\_default\_listeners) | Whether Emissary should be created with default listeners: HTTP on port 8080, HTTPS on port 8443. See https://www.getambassador.io/docs/emissary/latest/howtos/configure-communications/ | `bool` | `false` | no |
| <a name="input_custom_request_headers"></a> [custom\_request\_headers](#input\_custom\_request\_headers) | Map of Custom Request Headers | `map(string)` | `{}` | no |
| <a name="input_enable_l7_load_balancing"></a> [enable\_l7\_load\_balancing](#input\_enable\_l7\_load\_balancing) | Use L7 for load balancing. Otherwise, L4 is used | `bool` | `true` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment variables for container | `map(string)` | `{}` | no |
| <a name="input_env_raw"></a> [env\_raw](#input\_env\_raw) | Raw environment variables for container in YAML | `string` | `""` | no |
| <a name="input_external_traffic_policy"></a> [external\_traffic\_policy](#input\_external\_traffic\_policy) | External traffic policy for L4 Load balancing | `string` | `"Local"` | no |
| <a name="input_frontend_config"></a> [frontend\_config](#input\_frontend\_config) | Frontend Config CRD name | `string` | `""` | no |
| <a name="input_health_check"></a> [health\_check](#input\_health\_check) | Health Check Configuration | <pre>object({<br>    interval            = optional(number)<br>    timeout             = optional(number)<br>    health_threshold    = optional(number)<br>    unhealthy_threshold = optional(number)<br>    protocol            = optional(string)<br>    path
   = optional(string)<br>    port                = optional(number)<br>  })</pre> | <pre>{<br>  "interval": 10,<br>  "path": "/ambassador/v0/check_alive",<br>  "port": 8877,<br>  "protocol": "HTTP",<br>  "timeout": 10<br>}</pre> | no |
| <a name="input_hpa_enabled"></a> [hpa\_enabled](#input\_hpa\_enabled) | Enable HPA | `bool` | `true` | no |
| <a name="input_hpa_max_replica"></a> [hpa\_max\_replica](#input\_hpa\_max\_replica) | Max Number of replica | `number` | `3` | no |
| <a name="input_hpa_metrics"></a> [hpa\_metrics](#input\_hpa\_metrics) | Metrics for HPA Scaling | `any` | <pre>[<br>  {<br>    "resource": {<br>      "name": "cpu",<br>      "target": {<br>        "averageUtilization": 80,<br>        "type": "Utilization"<br>      }<br>    },<br>    "type": "Resource"<br>  },<br>  {<br>    "resource": {<br>      "name": "memory",<br>      "target": {<br>        "averageUtilization": 80,<br>        "type": "Utilization"<br>      }<br>    },<br>    "type": "Resource"<br>  }<br>]</pre> | no |
| <a name="input_hpa_min_replica"></a> [hpa\_min\_replica](#input\_hpa\_min\_replica) | Minimum Number of replica | `number` | `2` | no |
| <a name="input_http2_enable"></a> [http2\_enable](#input\_http2\_enable) | Use HTTP/2. See https://cloud.google.com/kubernetes-engine/docs/how-to/ingress-http2 | `bool` | `true` | no |
| <a name="input_iap"></a> [iap](#input\_iap) | Enable Identity-Aware Proxy by setting the secret name with the OAuth Client Credentials | `string` | `""` | no |
| <a name="input_image_repository"></a> [image\_repository](#input\_image\_repository) | Image repository for Ambassador image | `string` | `"quay.io/datawire/ambassador"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | Image tag for Ambassador image | `string` | `"1.13.9"` | no |
| <a name="input_ingress_annotations"></a> [ingress\_annotations](#input\_ingress\_annotations) | Additional annotations for the ingress | `map(string)` | `{}` | no |
| <a name="input_ingress_name"></a> [ingress\_name](#input\_ingress\_name) | Name of the Kubernetes Ingress | `string` | `""` | no |
| <a name="input_internet_facing"></a> [internet\_facing](#input\_internet\_facing) | Whether the Load Balancer, L7 or L4 is internet facing | `bool` | `true` | no |
| <a name="input_kubernetes_annotations"></a> [kubernetes\_annotations](#input\_kubernetes\_annotations) | Annotations for Kubernetes Resources | `map(string)` | <pre>{<br>  "app.kubernetes.io/instance": "ambassador",<br>  "app.kubernetes.io/managed-by": "Terraform",<br>  "app.kubernetes.io/name": "ambassador",<br>  "app.kubernetes.io/part-of": "ambassador"<br>}</pre> | no |
| <a name="input_kubernetes_labels"></a> [kubernetes\_labels](#input\_kubernetes\_labels) | Labels for the Kubernetes Resources | `map(string)` | <pre>{<br>  "app.kubernetes.io/instance": "ambassador",<br>  "app.kubernetes.io/managed-by": "Terraform",<br>  "app.kubernetes.io/name": "ambassador",<br>  "app.kubernetes.io/part-of": "ambassador"<br>}</pre> | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels for resources | `map(string)` | <pre>{<br>  "app.kubernetes.io/managed-by": "Terraform"<br>}</pre> | no |
| <a name="input_load_balancer_source_ranges"></a> [load\_balancer\_source\_ranges](#input\_load\_balancer\_source\_ranges) | Load balancer source range for L4 Load balancing | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_logging"></a> [logging](#input\_logging) | Logging configuration for the endpoint | <pre>object({<br>    enable      = bool<br>    sample_rate = number<br>  })</pre> | <pre>{<br>  "enable": false,<br>  "sample_rate": 0.5<br>}</pre> | no |
| <a name="input_manage_crd"></a> [manage\_crd](#input\_manage\_crd) | Manage the CRD for Emissary Ingress | `bool` | `false` | no |
| <a name="input_managed_certificates"></a> [managed\_certificates](#input\_managed\_certificates) | List of managed certificates to use or create. Key is the name | <pre>map(object({<br>    create  = optional(bool) # False by default<br>    domains = optional(list(string))<br>  }))</pre> | `{}` | no |
| <a name="input_pod_disruption_budget"></a> [pod\_disruption\_budget](#input\_pod\_disruption\_budget) | PDB values | `any` | <pre>{<br>  "minAvailable": 1<br>}</pre> | no |
| <a name="input_pod_security_context"></a> [pod\_security\_context](#input\_pod\_security\_context) | Pod securityContext | `any` | `{}` | no |
| <a name="input_pre_shared_certificates"></a> [pre\_shared\_certificates](#input\_pre\_shared\_certificates) | List of pre-shared certificates to use. See https://cloud.google.com/load-balancing/docs/ssl-certificates/self-managed-certs | `list(string)` | `[]` | no |
| <a name="input_priority_class_name"></a> [priority\_class\_name](#input\_priority\_class\_name) | Priority class names | `string` | `""` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project ID for resources. Defaults to provider configured project | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | Region for resources. Defaults to provider configured region | `string` | `null` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | Chart release name | `string` | `"emissary-ingress"` | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | Number of replicas | `number` | `3` | no |
| <a name="input_resources"></a> [resources](#input\_resources) | Pod resources | `any` | <pre>{<br>  "limits": {<br>    "cpu": "1000m",<br>    "memory": "1500Mi"<br>  },<br>  "requests": {<br>    "cpu": "200m",<br>    "memory": "1500Mi"<br>  }<br>}</pre> | no |
| <a name="input_service_annotations"></a> [service\_annotations](#input\_service\_annotations) | Additional annotations for the service | `map(string)` | `{}` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Name of Ambassador Service | `string` | `"ambassador"` | no |
| <a name="input_service_port"></a> [service\_port](#input\_service\_port) | Port of Ambaassador Service | `any` | `443` | no |
| <a name="input_session_affinity"></a> [session\_affinity](#input\_session\_affinity) | Session affinity. Set type to empty to disable | <pre>object({<br>    type           = string<br>    cookie_ttl_sec = optional(number)<br>  })</pre> | <pre>{<br>  "type": ""<br>}</pre> | no |
| <a name="input_ssl_policy"></a> [ssl\_policy](#input\_ssl\_policy) | SSL Policy. Set to `null` to not use any. | <pre>object({<br>    name   = string<br>    create = bool<br>  })</pre> | <pre>{<br>  "create": true,<br>  "name": "ambassador"<br>}</pre> | no |
| <a name="input_ssl_policy_settings"></a> [ssl\_policy\_settings](#input\_ssl\_policy\_settings) | Settings for SSL policy to create | <pre>object({<br>    description     = optional(string)<br>    profile         = optional(string)<br>    min_tls_version = optional(string)<br>    custom_features = optional(list(string))<br>  })</pre> | <pre>{<br>  "min_tls_version": "TLS_1_2",<br>  "profile": "MODERN"<br>}</pre> | no |
| <a name="input_ssl_redirect"></a> [ssl\_redirect](#input\_ssl\_redirect) | Redirect HTTP to HTTPS | <pre>object({<br>    enabled            = bool<br>    response_code_name = optional(string) # One of `MOVED_PERMANENTLY_DEFAULT` `FOUND`, `SEE_OTHER`, `TEMPORARY_REDIRECT`, `PERMANENT_REDIRECT`<br>  })</pre> | <pre>{<br>  "enabled": true,<br>  "response_code_name": "MOVED_PERMANENTLY_DEFAULT"<br>}</pre> | no |
| <a name="input_static_ip"></a> [static\_ip](#input\_static\_ip) | Static IP configuration | <pre>object({<br>    name   = string # Name to create or use<br>    create = bool<br><br>    description = optional(string)<br><br>    # Internal address only<br>    subnetwork   = optional(string) # Required for internal<br>    network_tier = optional(string)<br>    address      = optional(string) # IPv4 Address for an internal IP<br>  })</pre> | <pre>{<br>  "create": true,<br>  "name": "ambassadaor"<br>}</pre> | no |
| <a name="input_timeout_sec"></a> [timeout\_sec](#input\_timeout\_sec) | Configures the backend service timeout. See https://cloud.google.com/load-balancing/docs/backend-service#timeout-setting | `number` | `30` | no |
| <a name="input_tls_secrets"></a> [tls\_secrets](#input\_tls\_secrets) | List of secrets to include in the ingress | <pre>list(object({<br>    hosts       = optional(list(string))<br>    secret_name = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_tolerations"></a> [tolerations](#input\_tolerations) | Pod Tolerations | `list(any)` | `[]` | no |
| <a name="input_volume_mounts"></a> [volume\_mounts](#input\_volume\_mounts) | Volumes mounts for container | `list(any)` | `[]` | no |
| <a name="input_volumes"></a> [volumes](#input\_volumes) | Volumes for containers | `list(any)` | `[]` | no |
| <a name="input_wait_for_load_balancer"></a> [wait\_for\_load\_balancer](#input\_wait\_for\_load\_balancer) | Wait for Load Balancer to be created successfully before returning | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ip_address"></a> [ip\_address](#output\_ip\_address) | IP Address of the deployed endpoint |

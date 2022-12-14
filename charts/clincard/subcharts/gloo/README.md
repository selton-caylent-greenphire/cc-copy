# gloo-edge

![Version: 0.1.20](https://img.shields.io/badge/Version-0.1.20-informational?style=flat-square) ![AppVersion: 1.0](https://img.shields.io/badge/AppVersion-1.0-informational?style=flat-square)

Helm chart to deploy GlooEdge

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| name | string | `"gloo-edge"` |  |
| nameOverride | string | `"gloo-edge"` |  |
| fullnameOverride | string | `"gloo-edge"` |  |
| gloo_namespace | string | `"gloo-system"` |  |
| ingress.enabled | bool | `false` |  |
| ingress.gateway | string | `"gateway-proxy"` |  |
| ingress.port | int | `80` |  |
| ingress.path | string | `"/"` |  |
| hosts.apigateway | string | `""` |  |
| virtualservice.enabled | bool | `true` |  |
| virtualservice.swaggerui.enabled | bool | `false` |  |
| dependencies.studysvc.name | string | `"study-svc"` |  |
| dependencies.studysvc.port | int | `8080` |  |
| dependencies.subjectsvc.name | string | `"subject-svc"` |  |
| dependencies.subjectsvc.port | int | `8080` |  |
| dependencies.eprosvc.name | string | `"epro-svc"` |  |
| dependencies.eprosvc.port | int | `8080` |  |
| dependencies.swaggerui.name | string | `"swagger-ui"` |  |
| dependencies.swaggerui.port | int | `8080` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)

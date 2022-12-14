# tenninetynine

![Version: 0.2.0](https://img.shields.io/badge/Version-0.2.0-informational?style=flat-square) ![AppVersion: 1.0](https://img.shields.io/badge/AppVersion-1.0-informational?style=flat-square)

A Helm chart deploying ClinCard tenninetynine service

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| name | string | `"tenninetynine"` |  |
| nameOverride | string | `"tenninetynine"` |  |
| fullnameOverride | string | `"tenninetynine"` |  |
| tier | string | `"reports"` |  |
| image | string | `"160116585046.dkr.ecr.us-east-1.amazonaws.com/clincard/tenninetynine-service:2.0.0"` |  |
| resources.service.replicas | int | `2` |  |
| resources.service.limits.cpu | string | `"500m"` |  |
| resources.service.limits.memory | string | `"256Mi"` |  |
| resources.service.requests.cpu | string | `"10m"` |  |
| resources.service.requests.memory | string | `"64Mi"` |  |
| ingress.enabled | bool | `false` |  |
| ingress.port | int | `8080` |  |
| ingress.path | string | `"/ten99"` |  |
| couchdb.user | string | `"admin"` |  |
| couchdb.service | string | `"couchdb-ha-svc-couchdb"` |  |
| couchdb.db_pis | string | `"paymentindex"` |  |
| hosts.apiinternal | string | `"api-internal.clincard.com"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)

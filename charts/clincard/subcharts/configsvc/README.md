# configsvc

![Version: 0.2.7](https://img.shields.io/badge/Version-0.2.7-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0](https://img.shields.io/badge/AppVersion-1.0-informational?style=flat-square)

Helm chart with the configsvc definition

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Helene McElroy | <helene.mcelroy@greenphire.com> |  |
| Jeisson Osorio | <jeisson.osorio@greenphire.com> |  |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nameOverride | string | `"configsvc"` |  |
| fullnameOverride | string | `"configsvc"` |  |
| tier | string | `"api"` |  |
| image | string | `"160116585046.dkr.ecr.us-east-1.amazonaws.com/clincard/config-service:3.1.2"` |  |
| dependencies.couchdbsecret | string | `"couchdb-secret"` | Secrets dependency [couchdb-secret] (https://github.com/Greenphire/clincard-config/tree/uat/ccuat01/uat/secrets) |
| dependencies.messagesvc.name | string | `"message-service"` |  |
| dependencies.messagesvc.port | int | `8080` |  |
| couchdb.user | string | `"admin"` |  |
| couchdb.service | string | `"couchdb-ha-svc-couchdb"` |  |
| couchdb.db_configs | string | `"configs"` |  |
| couchdb.db_payment | string | `"payments"` |  |
| couchdb.db_taxmanagement | string | `"taxmgt"` |  |
| couchdb.db_flexpayopts | string | `"flexible_payment_options"` |  |
| couchdb.initdb | bool | `false` |  |
| couchdb.init_bucket | string | `"cc-couchinit-lower"` |  |
| volumes.configName | string | `"config"` |  |
| volumes.configMountPath | string | `"/config"` |  |
| volumes.configDefaultMode | int | `420` |  |
| configMapJson[0].dataKey | string | `"config.json"` |  |
| configMapJson[0].dataKeyTemplateSrc | string | `"/_configmap.json.tpl"` |  |
| configMapJson[0].loggerServiceName | string | `"configsvc"` |  |
| configMapJson[0].gunicornBlock | bool | `true` |  |
| service.enabled | bool | `true` |  |
| service.type | string | `"ClusterIP"` |  |
| service.sessionAffinity | string | `"ClientIP"` |  |
| service.sessionAffinityConfig.clientIP.timeoutSeconds | int | `10800` |  |
| replicaCount | int | `3` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.minReplicas | int | `5` |  |
| autoscaling.maxReplicas | int | `15` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| readinessProbe.failureThreshold | int | `3` |  |
| readinessProbe.httpGet.path | string | `"/swagger.json"` |  |
| readinessProbe.httpGet.port | int | `8080` |  |
| readinessProbe.httpGet.scheme | string | `"HTTP"` |  |
| readinessProbe.initialDelaySeconds | int | `10` |  |
| readinessProbe.periodSeconds | int | `10` |  |
| readinessProbe.successThreshold | int | `1` |  |
| readinessProbe.timeoutSeconds | int | `5` |  |
| livenessProbe.failureThreshold | int | `3` |  |
| livenessProbe.httpGet.path | string | `"/swagger.json"` |  |
| livenessProbe.httpGet.port | int | `8080` |  |
| livenessProbe.httpGet.scheme | string | `"HTTP"` |  |
| livenessProbe.initialDelaySeconds | int | `30` |  |
| livenessProbe.periodSeconds | int | `30` |  |
| livenessProbe.successThreshold | int | `1` |  |
| livenessProbe.timeoutSeconds | int | `5` |  |
| serviceAccount.create | bool | `false` |  |
| serviceAccount.name | string | `""` |  |
| dnsPolicy | string | `"ClusterFirst"` |  |
| restartPolicy | string | `"Always"` |  |
| schedulerName | string | `"default-scheduler"` |  |
| terminationGracePeriodSeconds | int | `30` |  |
| rollingUpdateDeploymentStrategy.enabled | bool | `true` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)

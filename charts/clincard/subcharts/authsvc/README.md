# authsvc

![Version: 0.6.0](https://img.shields.io/badge/Version-0.6.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0](https://img.shields.io/badge/AppVersion-1.0-informational?style=flat-square)

Helm chart with the authsvc definition

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Helene McElroy | <helene.mcelroy@greenphire.com> |  |
| Jeisson Osorio | <jeisson.osorio@greenphire.com> |  |
| Thuy Hoang | <thuy.hoang@greenphire.com> |  |
| Tran Quang | <quang.tran@greenphire.com> |  |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nameOverride | string | `"authsvc"` |  |
| fullnameOverride | string | `"authsvc"` |  |
| secretpath | string | `"lower"` |  |
| tier | string | `"api"` |  |
| image | string | `"160116585046.dkr.ecr.us-east-1.amazonaws.com/clincard/auth-svc:2.6.3"` |  |
| dependencies.messageservice | string | `"message-service"` | Service dependency [messageservice](https://github.com/Greenphire/clincard-config/tree/uat/charts/clincard/subcharts/message-service) |
| dependencies.postgresadmin | string | `"postgres-admin"` |  |
| dependencies.clincardsecrets | string | `"clincard-secret"` | Secrets dependency [clincard](https://github.com/Greenphire/clincard-config/tree/uat/charts/clincard) |
| postgres.image | string | `"bitnami/postgresql:11.6.0-debian-9-r0"` |  |
| db.service | string | `"microservicedb-postgres"` |  |
| db.database | string | `"authsvc"` |  |
| db.username | string | `"authsvc"` |  |
| db.db_admin | string | `"clincard"` |  |
| volumes[0].name | string | `"config"` |  |
| volumes[0].configMap.defaultMode | int | `420` |  |
| volumes[0].configMap.items[0].key | string | `"config.json"` |  |
| volumes[0].configMap.items[0].path | string | `"config.json"` |  |
| volumes[0].configMap.name | string | `"authsvc"` |  |
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
| configMapJson[0].dataKey | string | `"config.json"` |  |
| configMapJson[0].dataKeyTemplateSrc | string | `"/_configmap.json.tpl"` |  |
| configMapJson[0].loggerServiceName | string | `"authsvc"` |  |
| service.enabled | bool | `true` |  |
| service.type | string | `"ClusterIP"` |  |
| service.port | int | `8080` |  |
| service.sessionAffinityConfig.clientIP.timeoutSeconds | int | `10800` |  |
| replicaCount | int | `2` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.minReplicas | int | `2` |  |
| autoscaling.maxReplicas | int | `5` |  |
| autoscaling.cpuTargetValue | int | `80` |  |
| autoscaling.memoryTargetValue | int | `80` |  |
| serviceAccount.create | bool | `false` |  |
| serviceAccount.name | string | `""` |  |
| dnsPolicy | string | `"ClusterFirst"` |  |
| restartPolicy | string | `"Always"` |  |
| schedulerName | string | `"default-scheduler"` |  |
| terminationGracePeriodSeconds | int | `30` |  |
| rollingUpdateDeploymentStrategy.enabled | bool | `true` |  |
| rollingUpdateDeploymentStrategy.maxSurge | string | `nil` |  |
| rollingUpdateDeploymentStrategy.maxUnavailable | string | `nil` |  |
| authsvc.jwtExpire | string | `"7776000"` |  |
| authsvc.jwtRedisTTL | string | `"604800"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)

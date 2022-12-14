# study-svc

![Version: 0.4.6](https://img.shields.io/badge/Version-0.4.6-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0](https://img.shields.io/badge/AppVersion-1.0-informational?style=flat-square)

Helm chart with the study-svc definition

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Helene McElroy | <helene.mcelroy@greenphire.com> |  |
| Jeisson Osorio | <jeisson.osorio@greenphire.com> |  |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nameOverride | string | `"study-svc"` |  |
| fullnameOverride | string | `"study-svc"` |  |
| secretpath | string | `"lower"` |  |
| tier | string | `"api"` |  |
| image | string | `"160116585046.dkr.ecr.us-east-1.amazonaws.com/clincard/study-service:1.2.7"` |  |
| postgres.image | string | `"bitnami/postgresql:11.6.0-debian-9-r0"` |  |
| portaldb.service | string | `"portaldb-postgres"` |  |
| portaldb.database | string | `"ccportaldatabase"` |  |
| portaldb.username | string | `"studysvc"` |  |
| portaldb.db_admin | string | `"clincard"` |  |
| dependencies.authsvc | string | `"authsvc"` |  |
| dnsPolicy | string | `"ClusterFirst"` |  |
| restartPolicy | string | `"Always"` |  |
| schedulerName | string | `"default-scheduler"` |  |
| securityContext | object | `{}` |  |
| terminationGracePeriodSeconds | int | `30` |  |
| volumes[0].name | string | `"config"` |  |
| volumes[0].configMap.defaultMode | int | `420` |  |
| volumes[0].configMap.name | string | `"study-svc"` |  |
| volumes[0].configMap.items[0].key | string | `"config.json"` |  |
| volumes[0].configMap.items[0].path | string | `"config.json"` |  |
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
| configMapJson[0].loggerServiceName | string | `"study-svc"` |  |
| service.enabled | bool | `true` |  |
| service.port | int | `8080` |  |
| service.protocol | string | `"TCP"` |  |
| service.targetPort | int | `8080` |  |
| replicaCount | int | `2` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.minReplicas | int | `2` |  |
| autoscaling.maxReplicas | int | `10` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| serviceAccount.create | bool | `false` |  |
| serviceAccount.name | string | `""` |  |
| rollingUpdateDeploymentStrategy.enabled | bool | `true` |  |
| rollingUpdateDeploymentStrategy.maxSurge | string | `nil` |  |
| rollingUpdateDeploymentStrategy.maxUnavailable | string | `nil` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)

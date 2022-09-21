# paymentevents

![Version: 0.3.4](https://img.shields.io/badge/Version-0.3.4-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0](https://img.shields.io/badge/AppVersion-1.0-informational?style=flat-square)

Helm chart with the paymentevents definition

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Helene McElroy | <helene.mcelroy@greenphire.com> |  |
| Jeisson Osorio | <jeisson.osorio@greenphire.com> |  |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nameOverride | string | `"paymentevents"` |  |
| fullnameOverride | string | `"paymentevents"` |  |
| secretpath | string | `"lower"` |  |
| tier | string | `"api"` |  |
| image | string | `"160116585046.dkr.ecr.us-east-1.amazonaws.com/clincard/paymentevents-service:1.7.0"` |  |
| dependencies.rabbitmqSecrets | string | `"rabbitmq-secrets"` | Secrets service dependency **Rabbit-mq** |
| dependencies.postgresadmin | string | `"postgres-admin"` |  |
| dependencies.clincardsecrets | string | `"clincard-secret"` | Secrets dependency [clincard](https://github.com/Greenphire/clincard-config/tree/uat/charts/clincard) |
| paymentdb.service | string | `"paymentdb-postgres"` |  |
| paymentdb.database | string | `"paymentevents"` |  |
| paymentdb.username | string | `"paymentevents"` |  |
| paymentdb.db_admin | string | `"clincard"` |  |
| rabbit.username | string | `"payments"` |  |
| rabbit.service | string | `"rabbit-rabbitmq-ha"` |  |
| volumes[0].name | string | `"config"` |  |
| volumes[0].configMap.defaultMode | int | `420` |  |
| volumes[0].configMap.items[0].key | string | `"config.json"` |  |
| volumes[0].configMap.items[0].path | string | `"config.json"` |  |
| volumes[0].configMap.name | string | `"paymentevents"` |  |
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
| configMapJson[0].loggerServiceName | string | `"paymentevents"` |  |
| service.enabled | bool | `true` |  |
| service.type | string | `"ClusterIP"` |  |
| service.port | int | `8080` |  |
| replicaCount | int | `6` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.maxReplicas | int | `10` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| serviceAccount.create | bool | `false` |  |
| serviceAccount.name | string | `""` |  |
| dnsPolicy | string | `"ClusterFirst"` |  |
| restartPolicy | string | `"Always"` |  |
| schedulerName | string | `"default-scheduler"` |  |
| terminationGracePeriodSeconds | int | `30` |  |
| rollingUpdateDeploymentStrategy.enabled | bool | `true` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
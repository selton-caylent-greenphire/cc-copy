# rideshare

![Version: 0.1.7](https://img.shields.io/badge/Version-0.1.7-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.2.1](https://img.shields.io/badge/AppVersion-0.2.1-informational?style=flat-square)

Helm chart with the rideshare definition

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Helene McElroy | <helene.mcelroy@greenphire.com> |  |
| Jeisson Osorio | <jeisson.osorio@greenphire.com> |  |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nameOverride | string | `"rideshare"` |  |
| fullnameOverride | string | `"rideshare"` |  |
| secretpath | string | `"lower"` |  |
| tier | string | `"travel"` |  |
| rideshareCelery.tier | string | `"backend"` |  |
| rideshareCelery.image | string | `"160116585046.dkr.ecr.us-east-1.amazonaws.com/clincard/rideshare-celery:2.7.0"` |  |
| rideshareCelery.replicaCount | int | `2` |  |
| rideshareCelery.autoscaling.enabled | bool | `false` |  |
| rideshareCelery.resources.limits.cpu | string | `"500m"` |  |
| rideshareCelery.resources.limits.memory | string | `"2Gi"` |  |
| rideshareCelery.resources.requests.cpu | string | `"50m"` |  |
| rideshareCelery.resources.requests.memory | string | `"256Mi"` |  |
| rideshareCelery.configMapJson[0].dataKey | string | `"config.json"` |  |
| rideshareCelery.configMapJson[0].dataKeyTemplateSrc | string | `"/_configmap.json.tpl"` |  |
| rideshareCelery.configMapJson[0].loggerServiceName | string | `"rideshare-celery"` |  |
| rideshareCelery.configMapJson[0].gunicornBlock | bool | `false` |  |
| rideshareConsumer.tier | string | `"consumer"` |  |
| rideshareConsumer.image | string | `"160116585046.dkr.ecr.us-east-1.amazonaws.com/clincard/rideshare-consumer:2.7.0"` |  |
| rideshareConsumer.replicaCount | int | `2` |  |
| rideshareConsumer.autoscaling.enabled | bool | `false` |  |
| rideshareConsumer.resources.limits.cpu | string | `"500m"` |  |
| rideshareConsumer.resources.limits.memory | string | `"250Mi"` |  |
| rideshareConsumer.resources.requests.cpu | string | `"100m"` |  |
| rideshareConsumer.resources.requests.memory | string | `"75Mi"` |  |
| rideshareService.tier | string | `"api"` |  |
| rideshareService.image | string | `"160116585046.dkr.ecr.us-east-1.amazonaws.com/clincard/rideshare-service:2.7.0"` |  |
| rideshareService.replicaCount | int | `2` |  |
| rideshareService.autoscaling.enabled | bool | `false` |  |
| rideshareService.resources.limits.cpu | string | `"500m"` |  |
| rideshareService.resources.limits.memory | string | `"1Gi"` |  |
| rideshareService.resources.requests.cpu | string | `"100m"` |  |
| rideshareService.resources.requests.memory | string | `"250Mi"` |  |
| rideshareService.service.enabled | bool | `true` |  |
| rideshareService.service.port | int | `8080` |  |
| rideshareService.service.clusterIP | string | `"None"` |  |
| rideshareService.configMapJson[0].dataKey | string | `"config.json"` |  |
| rideshareService.configMapJson[0].dataKeyTemplateSrc | string | `"/_configmap.json.tpl"` |  |
| rideshareService.configMapJson[0].loggerServiceName | string | `"ridesharesvc"` |  |
| rideshareService.configMapJson[0].gunicornBlock | bool | `true` |  |
| rideshareService.configMapJson[0].gunicornTimeout | int | `60` |  |
| rideshareService.configMapJson[0].gunicornWorkers | int | `4` |  |
| envs.rideshareFee | string | `"6.0"` |  |
| envs.lyftTimeout | string | `"20"` |  |
| envs.lyftBaseUrl | string | `"https://api-sandbox.lyft.net"` |  |
| envs.configFilePath | string | `"/config/config.json"` |  |
| envs.rabbitmqExchange | string | `"payments"` |  |
| envs.rabbitmqQueue | string | `"rideshare_payments"` |  |
| envs.rabbitmqRoutingKey | string | `"payments.*"` |  |
| envs.rabbitmqRetries | string | `"0"` |  |
| email.enable | bool | `false` |  |
| email.host | string | `"smtp.sendgrid.net"` |  |
| email.user | string | `"shawn.milochik@greenphire.com"` |  |
| email.support | string | `"clincard@greenphire.com"` |  |
| email.report_distro | string | `"accounting@greenphire.com,mason.romano@greenphire.com,greg.ruane@greenphire.com"` |  |
| media.host | string | `"ccdevmedia01.corp.greenphire.net"` |  |
| media.upload_path | string | `"/home/media/greenphire_media/reports/"` |  |
| media.user | string | `"media"` |  |
| media.base_url | string | `"https://ccdevmedia01.corp.greenphire.net:8443/reports"` |  |
| aws.bucket | string | `"cc-sqa-default"` |  |
| aws.region | string | `"us-east-1"` |  |
| storage.class | string | `"standard"` |  |
| storage.size | string | `"8Gi"` |  |
| websockets.enable | bool | `true` |  |
| virusscan.enable | bool | `false` |  |
| hosts.ws | string | `"ws.clincard.com"` |  |
| couchdb.service | string | `"couchdb-ha-svc-couchdb"` |  |
| couchdb.username | string | `"admin"` |  |
| postgres.image | string | `"bitnami/postgresql:11.6.0-debian-9-r0"` |  |
| db.service | string | `"microservicedb-postgres"` |  |
| db.database | string | `"rideshare"` |  |
| db.username | string | `"rideshare"` |  |
| db.db_admin | string | `"clincard"` |  |
| portaldb.service | string | `"portaldb-postgres"` |  |
| portaldb.database | string | `"ccportaldatabase"` |  |
| portaldb.username | string | `"rideshare"` |  |
| portaldb.db_admin | string | `"clincard"` |  |
| rabbit.username | string | `"payments"` |  |
| rabbit.service | string | `"rabbit-rabbitmq-ha"` |  |
| celery.username | string | `"celery"` |  |
| celery.service | string | `"rabbit-rabbitmq-ha"` |  |
| dependencies.postgresadmin | string | `"postgres-admin"` |  |
| dependencies.paymentevents | string | `"paymentevents"` | Service dependency [paymentevents](https://github.com/Greenphire/clincard-config/tree/uat/charts/clincard/subcharts/paymentevents) |
| dependencies.redis | string | `"redis"` | Service dependency [redis](https://github.com/Greenphire/clincard-config/tree/uat/) |
| dependencies.virusscanning | string | `"virus-scanning"` | Service dependency [virus-scanning](https://github.com/Greenphire/clincard-config/tree/uat/) |
| dependencies.ccsshsecrets | string | `"cc-ssh-key"` | Secrets dependency [cc-ssh-key] (https://github.com/Greenphire/clincard-config/tree/uat/charts/clincard/templates) |
| dependencies.clincardsecrets | string | `"clincard-secret"` | Secrets dependency [clincard](https://github.com/Greenphire/clincard-config/tree/uat/charts/clincard) |
| dependencies.rabbitsecret | string | `"rabbit-secret"` | Secrets dependency [rabbitsecret](https://github.com/Greenphire/clincard-config/tree/uat/ccuat01/uat/secrets) |
| dnsPolicy | string | `"ClusterFirst"` |  |
| restartPolicy | string | `"Always"` |  |
| schedulerName | string | `"default-scheduler"` |  |
| securityContext | object | `{}` |  |
| terminationGracePeriodSeconds | int | `30` |  |
| volumes.ccsshName | string | `"cc-ssh"` |  |
| volumes.ccsshMountPath | string | `"/root/.ssh"` |  |
| volumes.ccsshDefaultMode | int | `384` |  |
| volumes.secretName | string | `"cc-ssh-key"` |  |
| volumes.configName | string | `"config"` |  |
| volumes.configDefaultMode | int | `420` |  |
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
| rollingUpdateDeploymentStrategy.enabled | bool | `true` |  |
| rollingUpdateDeploymentStrategy.maxSurge | string | `nil` |  |
| rollingUpdateDeploymentStrategy.maxUnavailable | string | `nil` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)

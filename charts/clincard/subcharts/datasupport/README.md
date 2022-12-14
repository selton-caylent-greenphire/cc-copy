# datasupport

![Version: 0.2.4](https://img.shields.io/badge/Version-0.2.4-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

Helm chart with the datasupport definition

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Helene McElroy | <helene.mcelroy@greenphire.com> |  |
| Jeisson Osorio | <jeisson.osorio@greenphire.com> |  |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| name | string | `"datasupport"` |  |
| nameOverride | string | `"datasupport"` |  |
| fullnameOverride | string | `"datasupport"` |  |
| secretpath | string | `"lower"` |  |
| tier | string | `"api"` |  |
| enabled | bool | `false` |  |
| image | string | `"160116585046.dkr.ecr.us-east-1.amazonaws.com/clincard/datasupport:0.5.1"` |  |
| replicas | int | `1` |  |
| resources.limits.cpu | string | `"150m"` |  |
| resources.limits.memory | string | `"500Mi"` |  |
| resources.requests.cpu | string | `"10m"` |  |
| resources.requests.memory | string | `"64M"` |  |
| readinessProbe.failureThreshold | int | `3` |  |
| readinessProbe.httpGet.path | string | `"/"` |  |
| readinessProbe.httpGet.port | int | `5000` |  |
| readinessProbe.httpGet.scheme | string | `"HTTP"` |  |
| readinessProbe.initialDelaySeconds | int | `10` |  |
| readinessProbe.periodSeconds | int | `10` |  |
| readinessProbe.successThreshold | int | `1` |  |
| readinessProbe.timeoutSeconds | int | `5` |  |
| configMapJson[0].dataKey | string | `"config.json"` |  |
| configMapJson[0].dataKeyTemplateSrc | string | `"/_configmap.json.tpl"` |  |
| configMapJson[0].loggerServiceName | string | `"datasupport"` |  |
| configMapJson[0].gunicornBlock | bool | `false` |  |
| ingressClass | string | `"nginx"` |  |
| service.enabled | bool | `true` |  |
| service.port | int | `5000` |  |
| service.clusterIP | string | `"None"` |  |
| serviceAccount.create | bool | `true` |  |
| rollingUpdateDeploymentStrategy.enabled | bool | `true` |  |
| volumes.configName | string | `"config"` |  |
| volumes.configDefaultMode | int | `420` |  |
| customEnv.CONFIG_FILE_PATH | string | `"/config/config.json"` |  |
| customEnv.FIS_DEV_PCI_HOST | string | `"10.150.17.181"` |  |
| customEnv.DEPLOY_JOBS_TO_K8S | string | `"1"` |  |
| dependencies.clincardsecrets | string | `"clincard-secret"` | Secrets dependency [clincard](https://github.com/Greenphire/clincard-config/tree/uat/charts/clincard) |
| dependencies.ridesharesvc | string | `"rideshare-svc"` | Service dependency [rideshare](https://github.com/Greenphire/clincard-config/tree/uat/charts/clincard/subcharts/rideshare) |
| dependencies.redis | string | `"redis"` | Service dependency [redis](https://github.com/Greenphire/clincard-config/tree/uat/) |
| portaldb.service | string | `"portaldb-postgres"` |  |
| portaldb.database | string | `"ccportaldatabase"` |  |
| portaldb.username | string | `"datasupport"` |  |
| portaldb.db_admin | string | `"clincard"` |  |
| postgres.image | string | `"bitnami/postgresql:11.6.0-debian-9-r0"` |  |
| hosts.datasupport | string | `"datasupport.clincard.com"` |  |
| hosts.xfr_host | string | `"10.25.23.28"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)

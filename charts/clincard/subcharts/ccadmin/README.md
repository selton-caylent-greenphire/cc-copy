# ccadmin

![Version: 0.1.22](https://img.shields.io/badge/Version-0.1.22-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0](https://img.shields.io/badge/AppVersion-1.0-informational?style=flat-square)

Helm chart with the ccadmin definition

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Helene McElroy | <helene.mcelroy@greenphire.com> |  |
| Jeisson Osorio | <jeisson.osorio@greenphire.com> |  |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nameOverride | string | `"ccadmin"` |  |
| fullnameOverride | string | `"ccadmin"` |  |
| tier | string | `"frontend"` |  |
| image | string | `"160116585046.dkr.ecr.us-east-1.amazonaws.com/clincard/ccadmin:5.3.6"` |  |
| dependencies.couchdbsecret | string | `"couchdb-secret"` | Secrets dependency [couchdb-secret] (https://github.com/Greenphire/clincard-config/tree/uat/ccuat01/uat/secrets) |
| dependencies.nginxcert | string | `"nginx-cert"` | Secrets dependency [nginx-cert] (https://github.com/Greenphire/clincard-config/tree/uat/ccuat01/uat/secrets) |
| hosts.domain | string | `"clincard.com"` |  |
| hosts.clincard | string | `"www.clincard.com"` |  |
| hosts.static | string | `"static.clincard.com"` |  |
| hosts.api | string | `"api-admin.clincard.com"` |  |
| hosts.apiinternal | string | `"api-internal.clincard.com"` |  |
| hosts.ccadmin | string | `"controlcenter.clincard.com"` |  |
| hosts.ccalt | string | `"control-center.clincard.com"` |  |
| hosts.ws | string | `"ws.clincard.com"` |  |
| volumes.configName | string | `"ccadmin-config"` |  |
| volumes.configMountPath | string | `"/etc/nginx/conf.d"` |  |
| volumes.configDefaultMode | int | `420` |  |
| volumes.envVarsName | string | `"ccadmin-env-vars"` |  |
| volumes.envVarsMountPath | string | `"/usr/share/nginx/html/assets/env-config"` |  |
| configMapJson.listen | int | `80` |  |
| configMapEnvVarsJson.production | bool | `false` |  |
| service.enabled | bool | `true` |  |
| service.port | int | `80` |  |
| service.targetPort | int | `80` |  |
| ingressCcadmin.enabled | bool | `true` |  |
| ingressCcadmin.ingressClass | string | `"nginx"` |  |
| ingress.legacy-api.strip_path | bool | `false` |  |
| ingress.legacy-api.preserve_host | bool | `true` |  |
| ingress.legacy-api.service_name | string | `"clincard"` |  |
| ingress.legacy-api.service_port | int | `8888` |  |
| ingress.legacy-api.path | string | `"/internal-api"` |  |
| ingress.legacy-api.pathType | string | `"Prefix"` |  |
| ingress.legacy-api.apiinternal | bool | `false` |  |
| ingress.configsvc.strip_path | bool | `true` |  |
| ingress.configsvc.preserve_host | bool | `false` |  |
| ingress.configsvc.service_name | string | `"configsvc"` |  |
| ingress.configsvc.service_port | int | `8080` |  |
| ingress.configsvc.path | string | `"/configsvc"` |  |
| ingress.configsvc.pathType | string | `"Prefix"` |  |
| ingress.configsvc.apiinternal | bool | `false` |  |
| ingress.authsvc.strip_path | bool | `true` |  |
| ingress.authsvc.preserve_host | bool | `false` |  |
| ingress.authsvc.service_name | string | `"authsvc"` |  |
| ingress.authsvc.service_port | int | `8080` |  |
| ingress.authsvc.path | string | `"/authsvc"` |  |
| ingress.authsvc.pathType | string | `"Prefix"` |  |
| ingress.authsvc.apiinternal | bool | `false` |  |
| ingress.rideshare.strip_path | bool | `true` |  |
| ingress.rideshare.preserve_host | bool | `false` |  |
| ingress.rideshare.service_name | string | `"rideshare-svc"` |  |
| ingress.rideshare.service_port | int | `8080` |  |
| ingress.rideshare.path | string | `"/rideshare"` |  |
| ingress.rideshare.pathType | string | `"Prefix"` |  |
| ingress.rideshare.apiinternal | bool | `false` |  |
| ingress.api-internal.strip_path | bool | `true` |  |
| ingress.api-internal.preserve_host | bool | `false` |  |
| ingress.api-internal.service_name | string | `"tenninetynine"` |  |
| ingress.api-internal.service_port | int | `8080` |  |
| ingress.api-internal.path | string | `"/ten99"` |  |
| ingress.api-internal.pathType | string | `"Prefix"` |  |
| ingress.api-internal.apiinternal | bool | `true` |  |
| replicaCount | int | `3` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.minReplicas | int | `5` |  |
| autoscaling.maxReplicas | int | `15` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| readinessProbe.failureThreshold | int | `3` |  |
| readinessProbe.httpGet.path | string | `"/"` |  |
| readinessProbe.httpGet.port | int | `80` |  |
| readinessProbe.httpGet.scheme | string | `"HTTP"` |  |
| readinessProbe.initialDelaySeconds | int | `10` |  |
| readinessProbe.periodSeconds | int | `10` |  |
| readinessProbe.successThreshold | int | `1` |  |
| readinessProbe.timeoutSeconds | int | `5` |  |
| livenessProbe.failureThreshold | int | `3` |  |
| livenessProbe.httpGet.path | string | `"/"` |  |
| livenessProbe.httpGet.port | int | `80` |  |
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

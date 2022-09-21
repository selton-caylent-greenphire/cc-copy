- name: DB_PASS
  valueFrom:
    secretKeyRef:
      key: postgres-{{ include "db_usr" . }}
      name: {{ template "paymentgateway.fullname" . }}
- name: PORTALDB_PASS
  valueFrom:
    secretKeyRef:
      key: postgres-{{ include "portaldb_pusr" . }}
      name: {{ template "paymentgateway.fullname" . }}
- name: RABBIT_PASS
  valueFrom:
    secretKeyRef:
      key: {{ .Values.dependencies.rabbitmqSecrets }}
      name: {{ template "paymentgateway.fullname" . }}
- name: REDIS_PASSWORD
  valueFrom:
    secretKeyRef:
      key: redis-password
      name: {{ template "paymentgateway.fullname" . }}
- name: DB_URI
  value: {{ printf "postgresql://%s:$(DB_PASS)@%s.%s/%s" (include "db_usr" .) (include "db_svc" .) .Release.Namespace (include "db_db" .) }}
- name: CLINCARD_DB
  value: {{ printf "postgresql://%s:$(PORTALDB_PASS)@%s.%s/%s" (include "portaldb_pusr" .) (include "portaldb_psvc" .) .Release.Namespace (include "portaldb_pdb" .) }}
- name: RABBITMQ_URI
  value: {{ printf "amqp://%s:$(RABBIT_PASS)@%s.%s:5672/" (include "rmq_usr" .) (include "rmq_svc" .) .Release.Namespace }}
- name: RABBITMQ_EXCHANGE
  value: payments
- name: RABBITMQ_QUEUE
  value: gateway
- name: RABBITMQ_RETRIES
  value: "10"
- name: RABBITMQ_TOPICS
  value: paymentrequested,paymentapproved
- name: RABBITMQ_DLX
  value: payments-dlx
- name: REDIS_HOST
  value: redis
- name: CONFIG_FILE_PATH
  value: /config/config.json
- name: CONFIGSVC_URL
  value: http://{{ .Values.dependencies.configsvc }}.{{ .Release.Namespace}}:8080/swagger.json
- name: PAYMENTDOMAIN_URL
  value: http://{{ .Values.dependencies.paymentdomain }}.{{ .Release.Namespace}}:8080/swagger.json
- name: PAYMENTSVC_URL
  value: http://{{ .Values.dependencies.paymentevents}}.{{ .Release.Namespace}}:8080/swagger.json
{{ include "opentelemetry_envs" .}}
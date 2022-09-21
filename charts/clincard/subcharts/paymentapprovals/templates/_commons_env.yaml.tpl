- name: DB_PASS
  valueFrom:
    secretKeyRef:
      key: postgres-{{ include "db_usr" . }}
      name: {{ .Values.dependencies.clincardsecrets }}
- name: PORTALDB_PASS
  valueFrom:
    secretKeyRef:
      key: postgres-{{ include "portaldb_pusr" . }}
      name: {{ .Values.dependencies.clincardsecrets }}
- name: RABBIT_PASS
  valueFrom:
    secretKeyRef:
      key: {{ .Values.dependencies.rabbitmqSecrets }}
      name: {{ template "paymentapprovals.fullname" . }}
- name: DB_URI
  value: {{ printf "postgresql://%s:$(DB_PASS)@%s.%s/%s" (include "db_usr" .) (include "db_svc" .) .Release.Namespace (include "db_db" .) }}
- name: CLINCARD_DB
  value: {{ printf "postgresql://%s:$(PORTALDB_PASS)@%s.%s/%s" (include "portaldb_pusr" .) (include "portaldb_psvc" .) .Release.Namespace (include "portaldb_pdb" .) }}
- name: RABBITMQ_URI
  value: {{ printf "amqp://%s:$(RABBIT_PASS)@%s.%s:5672/" (include "rmq_usr" .) (include "rmq_svc" .) .Release.Namespace }}
- name: MB_PREFETCH_COUNT
  value: "1"
- name: RABBITMQ_EXCHANGE
  value: payments
- name: RABBITMQ_QUEUE
  value: approvals
- name: RABBITMQ_ROUTING_KEY
  value: payments.*
- name: CONFIG_FILE_PATH
  value: /config/config.json
- name: RABBITMQ_RETRIES
  value: "3"
- name: RABBITMQ_DLX
  value: payments-dlx
- name: PAYMENTSVC_URL
  value: http://{{ .Values.dependencies.paymentevents}}.{{ .Release.Namespace}}:8080/swagger.json
{{ include "opentelemetry_envs" .}}
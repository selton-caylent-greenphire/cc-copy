- name: DB_PASS
  valueFrom:
    secretKeyRef:
        key: postgres-{{ include "usr" . }}
        name: {{ .Values.dependencies.clincardsecrets }}
- name: DB_URI
  value: {{ printf "postgresql://%s:$(DB_PASS)@%s.%s/%s" (include "usr" .) (include "svc" .) .Release.Namespace (include "database" .) }}
- name: RABBIT_PASS
  valueFrom:
    secretKeyRef:
        key: payments
        name: rabbit-secret
- name: RABBITMQ_URI
  value: {{ printf "amqp://%s:$(RABBIT_PASS)@%s.%s:5672/" (include "rmq_usr" .) (include "rmq_svc" .) .Release.Namespace }}
- name: RABBITMQ_EXCHANGE
  value: managed-dlx
- name: RABBITMQ_QUEUE
  value: grave_digger
- name: RABBITMQ_ROUTING_KEY
  value: managed-dlx.payments.*
- name: CONFIG_FILE_PATH
  value: /config/config.json
- name: CLINCARD_EXCHANGE
  value: clincard_core
- name: CLINCARD_ROUTING_KEY
  value: clincard_core.*
{{ include "opentelemetry_envs" .}}

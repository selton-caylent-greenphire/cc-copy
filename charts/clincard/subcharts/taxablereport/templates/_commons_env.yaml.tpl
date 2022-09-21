- name: DB_PASS
  valueFrom:
    secretKeyRef:
      key: postgres-{{ include "db_usr" . }}
      name: {{ .Values.dependencies.clincardsecrets }}
- name: DB_URI
  value: {{ printf "postgresql://%s:$(DB_PASS)@%s.%s/%s" (include "db_usr" .) (include "db_svc" .) .Release.Namespace (include "db_db" .) }}
- name: RABBIT_PASS
  valueFrom:
    secretKeyRef:
      key: payments
      name: {{ .Values.dependencies.rabbitsecrets }}
- name: RABBITMQ_URI
  value: {{ printf "amqp://%s:$(RABBIT_PASS)@%s.%s:5672/" (include "rmq_usr" .) (include "rmq_svc" .) .Release.Namespace }}
- name: RABBITMQ_EXCHANGE
  value: {{ default "payments" (.Values.env).RABBITMQ_EXCHANGE }}
- name: CONFIG_FILE_PATH
  value: {{ default "/config/config.json" (.Values.env).CONFIG_FILE_PATH }}
- name: RABBITMQ_QUEUE
  value: {{ default "taxablereports" (.Values.env).RABBITMQ_QUEUE }}
- name: RABBITMQ_ROUTING_KEY
  value: {{ default "payments.*" (.Values.env).RABBITMQ_ROUTING_KEY }}
- name: RABBITMQ_RETRIES
  value: {{ default "3" (.Values.env).RABBITMQ_RETRIES | quote }}
- name: RABBITMQ_DLX
  value: {{ default "payments-dlx" (.Values.env).RABBITMQ_DLX }}
- name: CONFIGSVC_URL
  value: http://{{ .Values.dependencies.configsvc}}.{{ .Release.Namespace}}:8080/swagger.json
- name: PAYMENTDOMAIN_URL
  value: http://{{ .Values.dependencies.paymentdomain}}.{{ .Release.Namespace}}:8080/swagger.json
{{ include "opentelemetry_envs" .}}
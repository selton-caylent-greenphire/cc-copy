- name: CONFIG_FILE_PATH
  value: /config/config.json
- name: RABBIT_PASS
  valueFrom:
    secretKeyRef:
        key: rabbit_userpass
        name: {{ .Values.dependencies.clincardsecrets }}
- name: CELERY_BROKER
  value: {{ printf "amqp://%s:$(RABBIT_PASS)@%s.%s:5672/celery" (include "cel_usr" .) (include "cel_svc" .) .Release.Namespace }}
- name: MAX_RETRIES
  value: {{ default "5" .Values.max_retries | quote }}
- name: RETRY_COUNTDOWN
  value: {{ default "60" .Values.retry_countdown | quote }}
- name: DS_DATAWAREHOUSE_API_URL
  value: {{ .Values.ds_datawarehouse_api_url }}
{{ include "opentelemetry_envs" .}}
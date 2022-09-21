- name: AWS_ACCESS_KEY
  valueFrom:
    secretKeyRef:
      key: aws-access-key
      name: {{ template "rideshare.secrets" . }}
- name: AWS_BUCKET
  value: {{ .Values.aws.bucket }}
- name: AWS_SECRET_KEY
  valueFrom:
    secretKeyRef:
      key: aws-secret-key
      name: {{ template "rideshare.secrets" . }}
- name: AWS_REGION_NAME
  value: {{ .Values.aws.region }}
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
- name: DB_URI
  value: {{ printf "postgresql://%s:$(DB_PASS)@%s.%s/%s" (include "db_usr" .) (include "db_svc" .) .Release.Namespace (include "db_db" .) }}
- name: CLINCARD_DB_URI
  value: {{ printf "postgresql://%s:$(PORTALDB_PASS)@%s.%s/%s" (include "portaldb_pusr" .) (include "portaldb_psvc" .) .Release.Namespace (include "portaldb_pdb" .) }}
- name: CONFIG_FILE_PATH
  value: {{.Values.envs.configFilePath }}
- name: LYFT_CLIENT_ID
  valueFrom:
    secretKeyRef:
      key: lyft-client-id
      name: {{ template "rideshare.secrets" . }}
- name: LYFT_CLIENT_SECRET
  valueFrom:
    secretKeyRef:
      key: lyft-client-secret
      name: {{ template "rideshare.secrets" . }}
- name: LYFT_REFRESH_TOKEN
  valueFrom:
    secretKeyRef:
      key: lyft-refresh-token
      name: {{ template "rideshare.secrets" . }}
- name: LYFT_TIMEOUT
  value: {{.Values.envs.lyftTimeout | quote }}
- name: LYFT_BASE_URL
  value: {{.Values.envs.lyftBaseUrl }}
- name: PAYMENTSVC_URL
  value: http://{{ .Values.dependencies.paymentevents }}.{{ .Release.Namespace }}:8080/swagger.json
- name: REDIS_HOST
  value: {{.Values.dependencies.redis }}
- name: REDIS_PASSWORD
  valueFrom:
    secretKeyRef:
      key: redis-password
      name: {{ .Values.dependencies.clincardsecrets }}
- name: WEBSOCKETS_ENABLED
  value: {{ .Values.websockets.enable | ternary "1" "0" | quote}}
- name: WEBSOCKET_SECRET
  valueFrom:
    secretKeyRef:
      key: websocket-secret
      name: {{ template "rideshare.secrets" . }}
- name: WEBSOCKET_URL
  value: ws://{{ include "hosts_ws" . }}:5678
- name: RIDESHARE_FEE
  value: {{.Values.envs.rideshareFee | quote }}
- name: RABBIT_PASS
  valueFrom:
    secretKeyRef:
      key: celery
      name: {{ .Values.dependencies.rabbitsecret }}
- name: CELERY_RABBITMQ_URL
  value: {{ printf "amqp://%s:$(RABBIT_PASS)@%s.%s:5672/celery" (include "cel_usr" .) (include "cel_svc" .) .Release.Namespace }}
- name: SEND_EMAILS
  value: {{ .Values.email.enable | ternary "1" "0" | quote }}
- name: INTERNAL_REPORT_DISTRO
  value: {{ .Values.email.report_distro }}
- name: SUPPORT_EMAIL
  value: {{ .Values.email.support }}
- name: EMAIL_HOST
  value: {{ .Values.email.host }}
- name: EMAIL_USER
  value: {{ .Values.email.user }}
- name: EMAIL_PASSWORD
  valueFrom:
    secretKeyRef:
      key: sendgrid-api-key
      name: {{ .Values.dependencies.clincardsecrets }}
- name: MEDIA_UPLOAD_HOST
  value: {{ .Values.media.host }}
- name: MEDIA_UPLOAD_USER
  value: {{ .Values.media.user }}
- name: MEDIA_UPLOAD_PATH
  value: {{ .Values.media.upload_path }}
- name: MEDIA_URL_BASE
  value: {{ .Values.media.base_url }}

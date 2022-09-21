- name: REDIS_PASSWORD
  valueFrom:
    secretKeyRef:
      key: redis-password
      name: {{ .Values.dependencies.clincardsecrets }}
- name: CELERY_BROKER
  value: redis://:$(REDIS_PASSWORD)@redis:6379/0
- name: CELERY_BACKEND
  value: redis://:$(REDIS_PASSWORD)@redis:6379/0
- name: EMAIL_HOST_USER
  value: {{ .Values.commonEnv.emailHostUser | quote }}
- name: EMAIL_NO_LOGIN
  value: {{ .Values.commonEnv.emailNoLogin | quote }}
- name: EMAIL_USE_TLS
  value: {{ .Values.commonEnv.emailUseTls | quote }}
- name: EMAIL_HOST
  value: {{ .Values.commonEnv.emailHost | quote }}
- name: EMAIL_PORT
  value: {{ .Values.commonEnv.emailPort | quote }}
{{- if eq .Release.Namespace "prod" }}
- name: EMAIL_HOST_PASSWORD
  valueFrom:
    secretKeyRef:
      key: sendgrid-api-key
      name: {{ .Values.dependencies.clincardsecrets }}
{{- end }}
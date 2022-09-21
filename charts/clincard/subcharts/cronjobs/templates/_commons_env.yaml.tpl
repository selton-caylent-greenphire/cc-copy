- name: DEBUG
  value: {{ include "booleanToString" .Values.enableDebug | quote }}
- name: CONFIG_SERVICE_SWAGGER
  value: 'http://{{ .Values.dependencies.configsvc }}.{{ .Release.Namespace }}:8080/swagger.json'
- name: PAYMENT_APPROVAL_SWAGGER
  value: 'http://{{ .Values.dependencies.paymentapprovals }}.{{ .Release.Namespace }}:8080/swagger.json'
- name: RIDESHARE_SWAGGER
  value: 'http://{{ .Values.dependencies.ridesharesvc }}.{{ .Release.Namespace }}:8080/swagger.json'
- name: TAXABLE_REPORT_SWAGGER
  value: 'http://{{ .Values.dependencies.taxablereport }}.{{ .Release.Namespace }}:8080/swagger.json'
- name: TEN99_SWAGGER
  value: 'http://{{ .Values.dependencies.tenninetynine }}.{{ .Release.Namespace }}:8080/swagger.json'
- name: DB_NAME
  value: {{ include "portaldb_pdb" . }}
- name: DB_HOST
  value: {{ printf "%s.%s" (include "portaldb_psvc" .) .Release.Namespace }}
- name: DB_USER
  value: {{ include "portaldb_pusr" . }}
- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      key: postgres-{{ include "portaldb_pusr" . }}
      name: {{ .Values.dependencies.clincardsecrets }}
- name: REDIS_HOST
  value: {{ .Values.dependencies.redis }}
- name: REDIS_PASSWORD
  valueFrom:
    secretKeyRef:
      key: redis-password
      name: {{ .Values.dependencies.clincardsecrets }}
{{- if eq .Release.Namespace "prod" }}
- name: EMAIL_HOST_PASSWORD
  valueFrom:
    secretKeyRef:
      key: sendgrid-api-key
      name: {{ .Values.dependencies.clincardsecrets }}
- name: EMAIL_HOST
  value: {{ .Values.commonEnv.emailHost }}
- name: EMAIL_HOST_USER
  value: {{ .Values.commonEnv.emailHostUser | quote }}
- name: EMAIL_NO_LOGIN
  value: {{ .Values.commonEnv.emailNoLogin | quote }}
- name: EMAIL_PORT
  value: {{ .Values.commonEnv.emailPort | quote }}
- name: EMAIL_USE_TLS
  value: {{ .Values.commonEnv.emailUseTls | quote }}
{{- end }}
{{- if eq .Release.Namespace "prod" }}
- name: TWILIO_SID
  valueFrom:
    secretKeyRef:
      key: twilio_sid
      name: {{ .Values.dependencies.clincardsecrets }}
- name: TWILIO_TOKEN
  valueFrom:
    secretKeyRef:
      key: twilio_auth_token
      name: {{ .Values.dependencies.clincardsecrets }}
{{- end }}
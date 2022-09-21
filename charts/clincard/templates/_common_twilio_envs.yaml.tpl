- name: TWILIO_SID
  valueFrom:
    secretKeyRef:
      key: twilio_sid
      name: {{ template "service.secret" . }}
- name: TWILIO_TOKEN
  valueFrom:
    secretKeyRef:
      key: twilio_auth_token
      name: {{ template "service.secret" . }}
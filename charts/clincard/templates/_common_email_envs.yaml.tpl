- name: EMAIL_HOST
  value: "{{ .Values.email.host }}"
- name: EMAIL_HOST_USER
  value: "{{ .Values.email.host_user }}"
- name: EMAIL_NO_LOGIN
  value: "{{ .Values.email.no_login }}"
- name: EMAIL_PORT
  value: "{{ .Values.email.port }}"
- name: EMAIL_USE_TLS
  value: "{{ .Values.email.tls }}"
- name: EMAIL_HOST_PASSWORD
  valueFrom:
    secretKeyRef:
      key: sendgrid-api-key
      name: {{ template "service.secret" . }}
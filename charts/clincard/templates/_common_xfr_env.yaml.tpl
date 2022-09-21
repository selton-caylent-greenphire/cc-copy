- name: XFR_HOST
  value: {{ .Values.global.hosts.xfr_host }}
- name: XFR_USERNAME
  valueFrom:
    secretKeyRef:
      key: xfr-user
      name: {{ include "service.secret" . }}
- name: XFR_PASSWORD
  valueFrom:
    secretKeyRef:
      key: xfr-cred
      name: {{ include "service.secret" . }}
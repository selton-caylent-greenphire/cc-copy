- name: XFR_USERNAME
  valueFrom:
    secretKeyRef:
      key: xfr-user
      name: {{ .Values.dependencies.clincardsecrets }}
- name: XFR_PASSWORD
  valueFrom:
    secretKeyRef:
      key: xfr-cred
      name: {{ .Values.dependencies.clincardsecrets }}
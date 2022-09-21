- name: PASSWORD_MANAGER_ACCOUNT_NAME
  value: {{ .Values.commonPassManagerEnv.accountName }}
- name: PASSWORD_MANAGER_CERT_DIR
  value: {{ .Values.commonPassManagerEnv.certDir }}
- name: PASSWORD_MANAGER_HOST_NAME
  value: {{ .Values.commonPassManagerEnv.hostName }}
- name: PASSWORD_MANAGER_PORT
  value: {{ .Values.commonPassManagerEnv.port | quote }}
- name: PASSWORD_MANAGER_TOKEN
  valueFrom:
    secretKeyRef:
      key: token
      name: {{ .Values.dependencies.passmanagersecrets }}
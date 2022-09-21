- name: WF_ENABLE_PAYMENTS
  value: {{ .Values.commonWfEnv.enablePayments | quote }}
- name: WF_S3BUCKET_REGION_NAME
  value: {{ .Values.commonWfEnv.s3BucketRegionName | quote }} 
- name: WF_S3BUCKET_ACCESS_KEY
  valueFrom:
    secretKeyRef:
      key: aws-access-key
      name: {{ .Values.dependencies.ridesharesecrets }}
- name: WF_S3BUCKET_SECRET_KEY
  valueFrom:
    secretKeyRef:
      key: aws-secret-key
      name: {{ .Values.dependencies.ridesharesecrets }}
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
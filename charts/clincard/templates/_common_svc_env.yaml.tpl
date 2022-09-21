- name: KONG_URL
  value: http://kong-kong-admin.kong:8001
- name: AUTHSVC_SWAGGER
  value: http://{{ .Values.dependencies.authsvc }}.{{ .Release.Namespace }}:8080/swagger.json
- name: TAXABLE_REPORT_SWAGGER
  value: http://{{ .Values.dependencies.taxablereport }}.{{ .Release.Namespace }}:8080/swagger.json
- name: PAYMENT_APPROVAL_SWAGGER
  value: http://{{ .Values.dependencies.paymentapprovals }}.{{ .Release.Namespace }}:8080/swagger.json
- name: TIN_VALIDATION_SWAGGER
  value: http://{{ .Values.dependencies.tinvalidation }}.{{ .Release.Namespace }}:8080/swagger.json
- name: GRAVEDIGGER_SWAGGER
  value: http://{{ .Values.dependencies.gravedigger }}.{{ .Release.Namespace }}:8080/swagger.json
- name: PBDR_SWAGGER
  value: http://{{ .Values.dependencies.programbalancedetail }}.{{ .Release.Namespace }}:8080/swagger.json
- name: CONFIG_SERVICE_SWAGGER
  value: http://{{ .Values.dependencies.configsvc }}.{{ .Release.Namespace }}:8080/swagger.json
- name: PAYMENT_EVENTS_SWAGGER
  value: http://{{ .Values.dependencies.paymentevents }}.{{ .Release.Namespace }}:8080/swagger.json
- name: PAYMENT_DOMAIN_SWAGGER
  value: http://{{ .Values.dependencies.paymentdomain }}.{{ .Release.Namespace }}:8080/swagger.json
- name: RIDESHARE_SWAGGER
  value: http://{{ .Values.dependencies.ridesharesvc }}.{{ .Release.Namespace }}:8080/swagger.json
- name: TEN99_SWAGGER
  value: http://{{ .Values.dependencies.tenninetynine }}.{{ .Release.Namespace }}:8080/swagger.json
- name: VIRUS_SCANNING_SWAGGER
  value: http://{{ .Values.dependencies.antivir }}.{{ .Release.Namespace }}:3320/swagger.json
- name: MESSAGE_SERVICE_SWAGGER
  value: http://{{ .Values.dependencies.messageservice }}.{{ .Release.Namespace }}:8080/swagger.json

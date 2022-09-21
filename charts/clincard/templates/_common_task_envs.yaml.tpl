- name: PAYMENTS_EXCHANGE
  value: {{ .Values.global.envs.PAYMENTS_EXCHANGE }}
- name: PAYMENTS_QUEUE
  value: {{ .Values.global.envs.PAYMENTS_QUEUE }}
- name: BACKFILL_QUEUE
  value: {{ .Values.global.envs.BACKFILL_QUEUE }}
- name: USE_DEMO_PG
  value: {{ .Values.global.envs.USE_DEMO_PG | quote }}
- name: DJANGO_SETTINGS_MODULE
  value: {{ .Values.global.envs.DJANGO_SETTINGS_MODULE }}
- name: RIDESHARE_FEE
  value: {{ .Values.global.envs.RIDESHARE_FEE | quote }}
- name: VIRUS_SCAN_ENABLED
  value: {{ ternary "1" "0" .Values.antivir.enabled | quote }}  
- name: WEBSOCKET_URL
  value: wss://{{ include "hosts_ws" . }}
- name: APILAYER_ACCESS_KEY
  valueFrom:
    secretKeyRef:
      key: apilayer_access_key
      name: {{ template "service.secret" . }}
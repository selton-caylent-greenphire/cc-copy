- name: JIRA_API_TOKEN
  valueFrom:
    secretKeyRef:
      key: jira_api_token
      name: {{ template "service.secret" . }}
- name: JIRA_GREENPHIRE_SYSTEM_USER
  value: {{ .Values.jira.greenphire_system_user }}
- name: JIRA_USER_EMAIL
  value: {{ .Values.jira.user }}
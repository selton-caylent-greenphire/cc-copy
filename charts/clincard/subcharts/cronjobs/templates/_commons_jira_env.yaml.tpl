{{- if eq (include "jira_enabled" . ) "true" }}
- name: JIRA_API_TOKEN
  valueFrom:
    secretKeyRef:
      key: jira_api_token
      name: {{ .Values.dependencies.clincardsecrets }}
- name: JIRA_USER_EMAIL
  value: {{ include "jira_user" . }}
- name: JIRA_GREENPHIRE_SYSTEM_USER
  value: {{ include "jira_greenphire_system_user" . }}
{{- end }}
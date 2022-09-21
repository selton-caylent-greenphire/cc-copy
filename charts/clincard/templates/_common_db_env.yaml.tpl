- name: DEBUG
  value: {{ ternary "True" "False" .Values.global.enableDebug | quote }} 
- name: DB_NAME
  value: {{ include "pdb" . }}
- name: DB_HOST
  value: {{ printf "%s.%s" (include "psvc" .) .Release.Namespace }}
- name: DB_USER
  value: {{ include "pusr" . }}
- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      key: postgres-{{ include "pusr" . }}
      name: {{ include "service.secret" . }}
- name: REDIS_HOST
  value: {{ printf "%s.%s" .Values.dependencies.redis .Release.Namespace }}
- name: REDIS_PASSWORD
  valueFrom:
    secretKeyRef:
      key: redis-password
      name: {{ .Values.dependencies.redis }}
- name: MEMCACHED_SERVER
  value: {{ .Values.dependencies.memcached }}
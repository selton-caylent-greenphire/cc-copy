- name: APILAYER_ACCESS_KEY
  valueFrom:
    secretKeyRef:
        key: apilayer_access_key
        name: {{ .Values.dependencies.clincardsecrets }}
- name: CONFIG_FILE_PATH
  value: /config/config.json
- name: DB_PASS
  valueFrom:
    secretKeyRef:
      key: postgres-{{ include "db_usr" . }}
      name: {{ .Values.dependencies.paymentdomain }}
- name: DOMAIN_DB_URI
  value: {{ printf "postgresql://%s:$(DB_PASS)@%s.%s/%s" (include "db_usr" .) (include "db_svc" .) .Release.Namespace (include "db_db" .) }}
- name: DS_DB_USERNAME
  valueFrom:
    secretKeyRef:
      key: user
      name: {{ (include "ds-replicator-secret" .) }}
- name: DS_DB_PASSWORD
  valueFrom:
    secretKeyRef:
      key: password
      name: {{ (include "ds-replicator-secret" .) }}
- name: DS_DB_IP
  value: {{ .Values.dsdb_ip }}
- name: DS_DB_NAME
  value: {{ .Values.dsdb_name }}
- name: REDIS_DB
  value: {{ .Values.redis_db | quote }}
- name: REDIS_HOST
  value: {{ default "redis" .Values.redis_host }}
- name: REDIS_TTL
  value: {{ default "3600" .Values.redis_ttl | quote }}
- name: REDIS_PASSWORD
  valueFrom:
    secretKeyRef:
      key: redis-password
      name: {{ .Values.dependencies.redis }}
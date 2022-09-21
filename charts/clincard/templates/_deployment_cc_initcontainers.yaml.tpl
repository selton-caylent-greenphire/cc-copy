- name: wait
  image: {{ include "pgimage" . }}
  command: ['sh', '-c', 'until pg_isready -h {{ include "psvc" . }}.{{ .Release.Namespace }} -U {{ include "pusr" . }} ; do echo waiting for database; sleep 2; done;']
- name: create-database-and-user
  env:
  - name: PGPASSWORD
    valueFrom:
      secretKeyRef:
        key: postgres-{{ include "pdb_adm" . }}
        name: {{ template "service.secret" . }}
  - name: PGSVCPASSWORD
    valueFrom:
      secretKeyRef:
        key: postgres-{{ include "pusr" . }}
        name: {{ template "service.secret" . }}
  image: {{ include "pgimage" . }}
  command: ["sh", "-c"]
  args:
    - |
      psql -h {{ include "psvc" .}}.{{ .Release.Namespace }} -U {{ include "pdb_adm" . }} -d postgres -v "ON_ERROR_STOP=1" << EOF &&
      DO
      \$\$
      BEGIN
        IF NOT EXISTS (
          SELECT FROM pg_catalog.pg_roles
          WHERE  rolname = '{{ include "pusr" . }}') 
        THEN
          CREATE ROLE {{ include "pusr" . }} LOGIN PASSWORD '$(PGSVCPASSWORD)';
          GRANT ALL ON DATABASE {{ include "pdb" . }} TO {{ include "pusr" . }};
          GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO {{ include "pusr" . }};
          GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO {{ include "pusr" . }};
        ELSE
          ALTER ROLE {{ include "pusr" . }} LOGIN PASSWORD '$(PGSVCPASSWORD)';
        END IF;
      END
      \$\$;
      EOF
      echo "SELECT 'CREATE DATABASE {{ include "pdb" . }} WITH OWNER = {{ include "pusr" . }}' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '{{ include "pdb" .}}')\\gexec" | psql -h {{ include "psvc" . }}.{{ .Release.Namespace }} -U {{ include "pdb_adm" . }} -d postgres
- name: wait-for-paymentevents
  image: alpine:3.7
  command: ["sh", "-c", "apk add curl && until curl --fail --connect-timeout 5 http://{{ .Values.dependencies.paymentevents}}.{{ .Release.Namespace}}:8080/swagger.json; do sleep 2; done"]
{{- if eq .Values.migrations.enable true }}
- name: migrate
  env:
  - name: DJANGO_SETTINGS_MODULE
    value: greenphire.web.settings
  - name: DB_NAME
    value: {{ include "pdb" . }}
  - name: DB_HOST
    value: {{ printf "%s.%s" (include "psvc" .) .Release.Namespace }}
  - name: DB_PASSWORD
    valueFrom:
      secretKeyRef:
        key: postgres-{{ include "pusr" . }}
        name: {{ template "service.secret" . }}
  - name: DB_USER
    value: {{ include "pusr" . }}
  - name: REDIS_HOST
    value: redis
  - name: REDIS_PASSWORD
    valueFrom:
      secretKeyRef:
        key: redis-password
        name: redis
  - name: RABBIT_CELERY_PASS
    valueFrom:
      secretKeyRef:
        key: celery
        name: rabbit-secret
  - name: CELERY_RABBITMQ_URL
    value: {{ printf "amqp://%s:$(RABBIT_CELERY_PASS)@%s.%s:5672/celery" (include "cel_usr" .) (include "cel_svc" .) .Release.Namespace }}
  - name: RABBIT_PASS
    valueFrom:
      secretKeyRef:
        key: payments
        name: rabbit-secret
  - name: RABBITMQ_URL
    value: {{ printf "amqp://%s:$(RABBIT_PASS)@%s.%s:5672/" (include "rmq_usr" .) (include "rmq_svc" .) .Release.Namespace }}
  - name: EMAIL_PASSWORD
    valueFrom:
      secretKeyRef:
        key: sendgrid-api-key
        name: {{ template "service.secret" . }}
  - name: PAYMENTS_EXCHANGE
    value: payments
  - name: PAYMENTS_QUEUE
    value: payment_processing
  - name: PAYMENT_EVENTS_SWAGGER
    value: "http://{{ .Values.dependencies.paymentevents }}.{{ .Release.Namespace }}:8080/swagger.json"
  - name: CONFIG_SERVICE_SWAGGER
    value: http://{{ .Values.dependencies.configsvc }}.{{ .Release.Namespace }}:8080/swagger.json
  - name: PAYMENT_APPROVAL_SWAGGER
    value: http://{{ .Values.dependencies.paymentapprovals}}.{{ .Release.Namespace }}:8080/swagger.json
  image: {{ .Values.images.default }}
  imagePullPolicy: IfNotPresent
  command: ["sh", "-c", "/clincard/src/manage.py migrate --noinput"]
{{- end }}
- name: wait-for-paymentapprovals
  image: alpine:3.7
  command: ["sh", "-c", "apk add curl && until curl --fail --connect-timeout 5 http://{{ .Values.dependencies.paymentapprovals}}.{{ .Release.Namespace}}:8080/swagger.json; do sleep 2; done"]
  
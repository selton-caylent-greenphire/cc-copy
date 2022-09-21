- name: wait-for-postgres
  image: {{ template "pgimage" . }}
  command: ['sh', '-c', 'until pg_isready -h {{ include "db_svc" . }}.{{ .Release.Namespace }} -U {{ include "db_usr" . }} ; do echo waiting for database; sleep 2; done;'] 
- name: create-database-and-user
  env:
  - name: PGPASSWORD
    valueFrom:
      secretKeyRef:
        key: admin-microservicedb-{{ include "db_adm" . }}
        name: postgres-admin
  - name: PGSVCPASSWORD
    valueFrom:
      secretKeyRef:
        key: postgres-{{ include "db_usr" . }}
        name: {{ template "service.fullname" . }}
  image: {{ template "pgimage" . }}
  command: ["sh", "-c"]
  args:
    - |
      psql -h {{ include "db_svc" .}}.{{ .Release.Namespace }} -U {{ include "db_adm" . }} -d postgres -v "ON_ERROR_STOP=1" << EOF &&
      DO
      \$\$
      BEGIN
        IF NOT EXISTS (
          SELECT FROM pg_catalog.pg_roles
          WHERE  rolname = '{{ include "db_usr" . }}') 
        THEN
          CREATE ROLE {{ include "db_usr" . }} LOGIN PASSWORD '$(PGSVCPASSWORD)';
          GRANT ALL ON DATABASE {{ include "db_db" . }} TO {{ include "db_usr" . }};
          GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO {{ include "db_usr" . }};
          GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO {{ include "db_usr" . }};
        END IF;
      END
      \$\$;
      EOF
      echo "SELECT 'CREATE DATABASE {{ include "db_db" . }} WITH OWNER = {{ include "db_usr" . }}' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '{{ include "db_db" .}}')\\gexec" | psql -h {{ include "db_svc" . }}.{{ .Release.Namespace }} -U {{ include "db_adm" . }} -d postgres
- name: servicename-migrations
  image: {{ .Values.image }}
  imagePullPolicy: IfNotPresent
  env:
  - name: DATABASE_PASS
    valueFrom:
      secretKeyRef:
        key: postgres-{{ include "db_usr" . }}
        name: {{ template "service.fullname" . }}
  - name: DB_URI
    value: {{ printf "postgresql://%s:$(DATABASE_PASS)@%s.%s/%s" (include "db_usr" .) (include "db_svc" .) .Release.Namespace (include "db_db" .) }}
  command: [ "/bin/sh", "-c", "alembic upgrade head" ]
  workingDir: /app
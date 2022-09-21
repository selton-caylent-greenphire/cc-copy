{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "service.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "service.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "service.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "celery" }}
{{- $i := 0 -}}
{{- $length := len .Values.celery -}}
{ 
{{- range $key, $val := .Values.celery -}}
  {{- if hasKey $.Values "global" -}}
    {{- if hasKey $.Values.global "celery" -}}
      {{- if hasKey $.Values.global.celery $key -}}
        {{ $key | quote }}: {{ index $.Values.global.celery ($key) | quote }}
      {{- else -}}
      {{ $key | quote }}: {{ $val | quote }}
      {{- end -}}
    {{- else -}}
      {{ $key | quote }}: {{ $val | quote }}
    {{- end -}}
  {{- else }}
    {{ $key | quote }}: {{ $val | quote }}
  {{- end -}}
  {{- $i = (add $i 1) -}}
  {{- if gt $length $i }},
  {{- end -}}
{{- end -}}
}
{{- end -}}

{{- define "rabbit" }}
{{- $i := 0 -}}
{{- $length := len .Values.rabbit -}}
{ 
{{- range $key, $val := .Values.rabbit -}}
  {{- if hasKey $.Values "global" -}}
    {{- if hasKey $.Values.global "rabbit" -}}
      {{- if hasKey $.Values.global.rabbit $key -}}
        {{ $key | quote }}: {{ index $.Values.global.rabbit ($key) | quote }}
      {{- else -}}
      {{ $key | quote }}: {{ $val | quote }}
      {{- end -}}
    {{- else -}}
      {{ $key | quote }}: {{ $val | quote }}
    {{- end -}}
  {{- else }}
    {{ $key | quote }}: {{ $val | quote }}
  {{- end -}}
  {{- $i = (add $i 1) -}}
  {{- if gt $length $i }},
  {{- end -}}
{{- end -}}
}
{{- end -}}

{{- define "pgimage" -}}
{{- if .Values.global }}
{{- if .Values.global.postgres }}
{{- if .Values.global.postgres.image -}}
{{ .Values.global.postgres.image }}
{{- else -}}
{{ .Values.postgres.image }}
{{- end -}}
{{- else -}}
{{ .Values.postgres.image }}
{{- end -}}
{{- else -}}
{{ .Values.postgres.image }}
{{- end -}}
{{- end -}}

{{- define "portaldb" }}
{{- $i := 0 -}}
{{- $length := len .Values.portaldb -}}
{ 
{{- range $key, $val := .Values.portaldb -}}
  {{- if hasKey $.Values "global" -}}
    {{- if hasKey $.Values.global "portaldb" -}}
      {{- if hasKey $.Values.global.portaldb $key -}}
        {{ $key | quote }}: {{ index $.Values.global.portaldb ($key) | quote }}
      {{- else -}}
	    {{ $key | quote }}: {{ $val | quote }}
      {{- end -}}
    {{- else -}}
      {{ $key | quote }}: {{ $val | quote }}
    {{- end -}}
  {{- else }}
    {{ $key | quote }}: {{ $val | quote }}
  {{- end -}}
  {{- $i = (add $i 1) -}}
  {{- if gt $length $i }},
  {{- end -}}
{{- end -}}
}
{{- end -}}

{{- define "hosts" }}
{{- $i := 0 -}}
{{- $length := len .Values.hosts -}}
{ 
{{- range $key, $val := .Values.hosts -}}
  {{- if hasKey $.Values "global" -}}
    {{- if hasKey $.Values.global "hosts" -}}
      {{- if hasKey $.Values.global.hosts $key -}}
        {{ $key | quote }}: {{ index $.Values.global.hosts ($key) | quote }}
      {{- else -}}
	    {{ $key | quote }}: {{ $val | quote }}
      {{- end -}}
    {{- else -}}
      {{ $key | quote }}: {{ $val | quote }}
    {{- end -}}
  {{- else }}
    {{ $key | quote }}: {{ $val | quote }}
  {{- end -}}
  {{- $i = (add $i 1) -}}
  {{- if gt $length $i }},
  {{- end -}}
{{- end -}}
}
{{- end -}}

{{/*
Build global.jira override variables in JSON to be parsed in templates
*/}}
{{- define "jira" }}
{{- $i := 0 -}}
{{- $length := len .Values.jira -}}
{ 
{{- range $key, $val := .Values.jira -}}
  {{- if hasKey $.Values "global" -}}
    {{- if hasKey $.Values.global "jira" -}}
      {{- if hasKey $.Values.global.jira $key -}}
        {{ $key | quote }}: {{ index $.Values.global.jira ($key) | quote }}
      {{- else -}}
      {{ $key | quote }}: {{ $val | quote }}
      {{- end -}}
    {{- else -}}
      {{ $key | quote }}: {{ $val | quote }}
    {{- end -}}
  {{- else }}
    {{ $key | quote }}: {{ $val | quote }}
  {{- end -}}
  {{- $i = (add $i 1) -}}
  {{- if gt $length $i }},
  {{- end -}}
{{- end -}}
}
{{- end -}}

{{/*
Create a default fully qualified master name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "service.payments.fullname" -}}
{{ template "service.fullname" . }}-payment-processor
{{- end -}}

{{- define "service.rqworker.fullname" -}}
{{ template "service.fullname" . }}-rqworker
{{- end -}}

{{- define "service.celery.fullname" -}}
{{ template "service.fullname" . }}-celery
{{- end -}}

{{- define "service.legacy.fullname" -}}
{{ template "service.fullname" . }}-legacy
{{- end -}}

{{- define "service.myclincard.fullname" -}}
{{ template "service.fullname" . }}-myclincard
{{- end -}}

{{- define "service.static.fullname" -}}
{{ template "service.fullname" . }}-static
{{- end -}}

{{- define "service.jupyter.fullname" -}}
{{ template "service.fullname" . }}-jupyter
{{- end -}}

{{- define "service.cbp.fullname" -}}
{{ template "service.fullname" . }}-celery-batch-processor
{{- end -}}

{{- define "service.secret" -}}
{{ template "service.fullname" . }}-secret
{{- end -}}

{{- define "celery.configmap" -}}
{{ printf "%s-%s" "celery" "config" }}
{{- end -}}

{{/*
Create the name of the service account to use for the master component
*/}}
{{- define "service.serviceAccountName.master" -}}
{{- if .Values.serviceAccounts.master.create -}}
    {{ default (include "service.master.fullname" .) .Values.serviceAccounts.master.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.master.name }}
{{- end -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "service.labels" -}}
chart: {{ include "service.chart" . }}
{{ include "service.selectorLabels" . }}
{{- if .Chart.AppVersion }}
version: {{ .Chart.AppVersion | quote }}
{{- end }}
heritage: {{ .Release.Service }}
{{- end }}

{{/*
Common Selector labels
*/}}
{{- define "service.selectorLabels" -}}
app: {{ template "service.name" . }}
release: {{ .Release.Name }}
{{- end }}

{{/*
Define common variables
*/}}
{{- define "psvc" -}}
{{ get (include "portaldb" . | fromJson) "service" }}
{{- end -}}

{{- define "pdb_adm" -}}
{{  get (include "portaldb" . | fromJson) "db_admin" }}
{{- end -}}

{{- define "pusr" -}}
{{ get (include "portaldb" . | fromJson) "username" }}
{{- end -}}

{{- define "pdb" -}}
{{ get (include "portaldb" . | fromJson) "database" }}
{{- end -}}

{{- define "rmq_usr" -}}
{{ get (include "rabbit" . | fromJson) "username" }}
{{- end -}}

{{- define "rmq_svc" -}}
{{ get (include "rabbit" . | fromJson) "service" }}
{{- end -}}

{{- define "rmq_protocol" -}}
{{ get (include "rabbit" . | fromJson) "protocol" }}
{{- end -}}

{{- define "rmq_host" -}}
{{ get (include "rabbit" . | fromJson) "host" }}
{{- end -}}

{{- define "rmq_port" -}}
{{ get (include "rabbit" . | fromJson) "port" }}
{{- end -}}

{{- define "cel_enable" -}}
{{ get (include "celery" . | fromJson) "enable" }}
{{- end -}}

{{- define "cel_usr" -}}
{{ get (include "celery" . | fromJson) "username" }}
{{- end -}}

{{- define "cel_svc" -}}
{{ get (include "celery" . | fromJson) "service" }}
{{- end -}}

{{- define "cel_protocol" -}}
{{ get (include "celery" . | fromJson) "protocol" }}
{{- end -}}

{{- define "cel_backend_protocol" -}}
{{ get (include "celery" . | fromJson) "backend_protocol" }}
{{- end -}}

{{- define "cel_host" -}}
{{ get (include "celery" . | fromJson) "host" }}
{{- end -}}

{{- define "cel_port" -}}
{{ get (include "celery" . | fromJson) "port" }}
{{- end -}}

{{- define "cel_replicas" -}}
{{ get (include "celery" . | fromJson) "replicas" }}
{{- end -}}

{{- define "dataMountPath" -}}
/clincard/data
{{- end -}}
{{- define "dataMountName" -}}
data
{{- end -}}

{{- define "efsClaimDataName" -}}
clincard-efs-{{ .Release.Namespace}}-data
{{- end -}}

{{- define "jira_enabled" -}}
{{ get (include "jira" . | fromJson) "enabled" }}
{{- end -}}

{{- define "jira_user" -}}
{{ get (include "jira" . | fromJson) "user" }}
{{- end -}}

{{- define "jira_greenphire_system_user" -}}
{{ get (include "jira" . | fromJson) "greenphire_system_user" }}
{{- end -}}

{{/*
Build global.db override variables in JSON to be parsed in templates
*/}}
{{- define "db" }}
{{- $i := 0 -}}
{{- $length := len .Values.db -}}
{ 
{{- range $key, $val := .Values.db -}}
  {{- if hasKey $.Values "global" -}}
    {{- if hasKey $.Values.global "db" -}}
      {{- if hasKey $.Values.global.db $key -}}
        {{ $key | quote }}: {{ index $.Values.global.db ($key) | quote }}
      {{- else -}}
	    {{ $key | quote }}: {{ $val | quote }}
      {{- end -}}
    {{- else -}}
      {{ $key | quote }}: {{ $val | quote }}
    {{- end -}}
  {{- else }}
    {{ $key | quote }}: {{ $val | quote }}
  {{- end -}}
  {{- $i = (add $i 1) -}}
  {{- if gt $length $i }},
  {{- end -}}
{{- end -}}
}
{{- end -}}

{{- define "db_usr" -}}
{{- get (include "db" . | fromJson) "username" -}}
{{- end -}}

{{- define "db_svc" -}}
{{- get (include "db" . | fromJson) "service" -}}
{{- end -}}

{{- define "db_adm" -}}
{{- get (include "db" . | fromJson) "db_admin" -}}
{{- end -}}

{{- define "booleanToInteger" -}}
{{ ternary 1 0 . }}
{{- end -}}

{{- define "booleanToString" -}}
{{ ternary "True" "False" . }}
{{- end -}}

{{- define "booleanToInitial" -}}
{{ ternary "T" "F" . }}
{{- end -}}

{{- define "debug" -}}
{{ default false .Values.global.enableDebug }}
{{- end -}}

{{- define "hosts_ws" -}}
{{ get (include "hosts" . | fromJson) "ws" }}
{{- end -}}

{{- define "hosts_static" -}}
{{ get (include "hosts" . | fromJson) "static" }}
{{- end -}}

{{- define "hosts_ccadmin" -}}
{{ get (include "hosts" . | fromJson) "ccadmin" }}
{{- end -}}

{{- define "hosts_domain" -}}
{{ get (include "hosts" . | fromJson) "domain" }}
{{- end -}}

{{- define "hosts_cc" -}}
{{ get (include "hosts" . | fromJson) "clincard" }}
{{- end -}}

{{- define "hosts_jupyter" -}}
{{ get (include "hosts" . | fromJson) "jupyter" }}
{{- end -}}

{{- define "hosts_mycc" -}}
{{ get (include "hosts" . | fromJson) "myclincard" }}
{{- end -}}

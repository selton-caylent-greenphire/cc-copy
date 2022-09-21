{{/*
Expand the name of the chart.
*/}}
{{- define "cronjobs.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cronjobs.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cronjobs.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cronjobs.labels" -}}
chart: {{ include "cronjobs.chart" . }}
{{ include "cronjobs.selectorLabels" . }}
{{- if .Chart.AppVersion }}
version: {{ .Chart.AppVersion | quote }}
{{- end }}
heritage: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cronjobs.selectorLabels" -}}
app: {{ template "cronjobs.name" . }}
release: {{ .Release.Name }}
tier: {{ .Values.tier }}
{{- end }}

{{/*
Build global.portaldb override variables in JSON to be parsed in templates
*/}}
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

{{/*
Build global.celery override variables in JSON to be parsed in templates
*/}}
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

{{/*
Build global.rabbit override variables in JSON to be parsed in templates
*/}}
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

{{/*
 Define all variables that are required and used in templates
*/}}
{{- define "portaldb_pusr" -}}
{{ get (include "portaldb" . | fromJson) "username" }}
{{- end -}}

{{- define "portaldb_psvc" -}}
{{ get (include "portaldb" . | fromJson) "service" }}
{{- end -}}

{{- define "portaldb_pdb" -}}
{{ get (include "portaldb" . | fromJson) "database" }}
{{- end -}}

{{- define "portaldb_adm" -}}
{{ get (include "portaldb" . | fromJson) "db_admin" }}
{{- end -}}

{{- define "cel_usr" -}}
{{ get (include "celery" . | fromJson) "username" }}
{{- end -}}

{{- define "cel_svc" -}}
{{ get (include "celery" . | fromJson) "service" }}
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

{{- define "db_usr" -}}
{{- get (include "db" . | fromJson) "username" -}}
{{- end -}}

{{- define "db_svc" -}}
{{- get (include "db" . | fromJson) "service" -}}
{{- end -}}

{{- define "db_adm" -}}
{{- get (include "db" . | fromJson) "db_admin" -}}
{{- end -}}

{{- define "rmq_usr" -}}
{{ get (include "rabbit" . | fromJson) "username" }}
{{- end -}}

{{- define "rmq_svc" -}}
{{ get (include "rabbit" . | fromJson) "service" }}
{{- end -}}

{{- define "rmq_adminusr" -}}
{{ get (include "rabbit" . | fromJson) "adminuser" }}
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

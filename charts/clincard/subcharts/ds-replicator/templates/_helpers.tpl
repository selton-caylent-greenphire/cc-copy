{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "dsreplicator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "dsreplicator.fullname" -}}
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

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "dsreplicator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


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
Create the name of the service account to use for the components
*/}}
{{- define "dsreplicator.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "dsreplicator.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}


{{/*
Common labels
*/}}
{{- define "dsreplicator.labels" -}}
name: {{ include "dsreplicator.name" . }}
chart: {{ include "dsreplicator.chart" . }}
{{- if .Chart.AppVersion }}
version: {{ .Chart.AppVersion | quote }}
{{- end }}
heritage: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "dsreplicator.selectorLabels" -}}
app: {{ template "dsreplicator.name" . }}
tier: {{ .Values.tier }}
{{- end }}

{{/*
Define common variables
*/}}
{{- define "ds-replicator-secret" -}}
{{ (include "dsreplicator.fullname" .) }}-credentials-aws
{{- end -}}

{{- define "cel_usr" -}}
{{ get (include "celery" . | fromJson) "username" }}
{{- end -}}

{{- define "cel_svc" -}}
{{ get (include "celery" . | fromJson) "service" }}
{{- end -}}

{{- define "db_usr" -}}
{{ get (include "db" . | fromJson) "username" }}
{{- end -}}

{{- define "db_svc" -}}
{{ get (include "db" . | fromJson) "service" }}
{{- end -}}

{{- define "db_db" -}}
{{- get (include "db" . | fromJson) "database" -}}
{{- end -}}

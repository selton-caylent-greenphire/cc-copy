{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "taxablereport.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "taxablereport.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Templates to handle global values overrides from parent chart
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
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "taxablereport.fullname" -}}
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
Create the name of the service account to use for the components
*/}}
{{- define "taxablereport.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "taxablereport.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}


{{/*
Common labels
*/}}
{{- define "taxablereport.labels" -}}
name: {{ include "taxablereport.name" . }}
chart: {{ include "taxablereport.chart" . }}
{{- if .Chart.AppVersion }}
version: {{ .Chart.AppVersion | quote }}
{{- end }}
heritage: {{ .Release.Service }}
{{- end }}

{{/*
Create a default fully qualified master name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "taxablereport.consumer.fullname" -}}
{{ template "taxablereport.fullname" . }}-consumer
{{- end -}}

{{/*
 Define all variables that are required and used in templates
*/}}
{{- define "db_usr" -}}
{{- get (include "db" . | fromJson) "username" -}}
{{- end -}}

{{- define "db_svc" -}}
{{- get (include "db" . | fromJson) "service" -}}
{{- end -}}

{{- define "db_db" -}}
{{- get (include "db" . | fromJson) "database" -}}
{{- end -}}

{{- define "db_adm" -}}
{{- get (include "db" . | fromJson) "db_admin" -}}
{{- end -}}

{{- define "portaldb_pusr" -}}
{{- get (include "portaldb" . | fromJson) "username" -}}
{{- end -}}

{{- define "portaldb_psvc" -}}
{{- get (include "portaldb" . | fromJson) "service" -}}
{{- end -}}

{{- define "portaldb_pdb" -}}
{{- get (include "portaldb" . | fromJson) "database" -}}
{{- end -}}

{{- define "portaldb_adm" -}}
{{- get (include "portaldb" . | fromJson) "db_admin" -}}
{{- end -}}

{{- define "rmq_usr" -}}
{{- get (include "rabbit" . | fromJson) "username" -}}
{{- end -}}

{{- define "rmq_svc" -}}
{{- get (include "rabbit" . | fromJson) "service" -}}
{{- end -}}

{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "messageservice.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "messageservice.fullname" -}}
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
{{- define "messageservice.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


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
Create the name of the service account to use for the components
*/}}
{{- define "messageservice.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "messageservice.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}


{{/*
Common labels
*/}}
{{- define "messageservice.labels" -}}
name: {{ include "messageservice.name" . }}
chart: {{ include "messageservice.chart" . }}
{{- if .Chart.AppVersion }}
version: {{ .Chart.AppVersion | quote }}
{{- end }}
heritage: {{ .Release.Service }}
{{- end }}

{{/*
Define common variables
*/}}
{{- define "cel_usr" -}}
{{ get (include "celery" . | fromJson) "username" }}
{{- end -}}

{{- define "cel_svc" -}}
{{ get (include "celery" . | fromJson) "service" }}
{{- end -}}

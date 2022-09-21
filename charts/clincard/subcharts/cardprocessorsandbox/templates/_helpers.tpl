{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "cardprocessorsandbox.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cardprocessorsandbox.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "cardprocessorsandbox.fullname" -}}
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


{{- define "cardprocessorsandbox.secrets" -}}
{{ template "cardprocessorsandbox.fullname" . }}-secrets
{{- end -}}

{{/*
Create the name of the service account to use for the master component
*/}}
{{- define "cardprocessorsandbox.serviceAccountName.master" -}}
{{- if .Values.serviceAccounts.master.create -}}
    {{ default (include "cardprocessorsandbox.master.fullname" .) .Values.serviceAccounts.master.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.master.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for the components
*/}}
{{- define "cardprocessorsandbox.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "cardprocessorsandbox.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "cardprocessorsandbox.labels" -}}
name: {{ include "cardprocessorsandbox.name" . }}
chart: {{ include "cardprocessorsandbox.chart" . }}
{{ include "cardprocessorsandbox.selectorLabels" . }}
{{- if .Chart.AppVersion }}
version: {{ .Chart.AppVersion | quote }}
{{- end }}
heritage: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cardprocessorsandbox.selectorLabels" -}}
app: {{ template "cardprocessorsandbox.name" . }}
release: {{ .Release.Name }}
tier: {{ .Values.tier }}
{{- end }}
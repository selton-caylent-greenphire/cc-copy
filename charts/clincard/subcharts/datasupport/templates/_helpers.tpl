{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "datasupport.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "datasupport.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "datasupport.fullname" -}}
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
Create a default fully qualified master name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "datasupport.ingress.fullname" -}}
{{ template "datasupport.fullname" . }}-ingress
{{- end -}}

{{- define "datasupport.secrets" -}}
{{ template "datasupport.fullname" . }}-secrets
{{- end -}}

{{/*
Create the name of the service account to use for the components
*/}}
{{- define "datasupport.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "datasupport.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "datasupport.labels" -}}
name: {{ include "datasupport.name" . }}
chart: {{ include "datasupport.chart" . }}
{{ include "datasupport.selectorLabels" . }}
{{- if .Chart.AppVersion }}
version: {{ .Chart.AppVersion | quote }}
{{- end }}
heritage: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "datasupport.selectorLabels" -}}
app: {{ template "datasupport.name" . }}
release: {{ .Release.Name }}
tier: {{ .Values.tier }}
{{- end }}


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

{{- define "hosts_datasupport" -}}
{{ get (include "hosts" . | fromJson) "datasupport" }}
{{- end -}}

{{- define "hosts_xfr" -}}
{{ get (include "hosts" . | fromJson) "xfr_host" }}
{{- end -}}

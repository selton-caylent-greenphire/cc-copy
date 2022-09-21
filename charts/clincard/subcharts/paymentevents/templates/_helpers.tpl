{{/*
Expand the name of the chart.
*/}}
{{- define "paymentevents.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "paymentevents.fullname" -}}
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
{{- define "paymentevents.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "paymentevents.labels" -}}
name: {{ include "paymentevents.name" . }}
chart: {{ include "paymentevents.chart" . }}
{{ include "paymentevents.selectorLabels" . }}
{{- if .Chart.AppVersion }}
version: {{ .Chart.AppVersion | quote }}
{{- end }}
heritage: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "paymentevents.selectorLabels" -}}
app: {{ template "paymentevents.name" . }}
component: {{ template "paymentevents.fullname" . }}
release: {{ .Release.Name }}
tier: {{ .Values.tier }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "paymentevents.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "paymentevents.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Rolling Update Deployment Strategy
*/}}
{{- define "paymentevents.rollingUpdateDeploymentStrategy" -}}
maxSurge: {{ default "50%" .Values.rollingUpdateDeploymentStrategy.maxSurge }}
maxUnavailable: {{ default "20%" .Values.rollingUpdateDeploymentStrategy.maxUnavailable }}
{{- end }}

{{/*
Validating global.postgress.image to define the postgress image
*/}}
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

{{/*
Build global.paymentdb override variables in JSON to be parsed in templates
*/}}
{{- define "paymentdb" }}
{{- $i := 0 -}}
{{- $length := len .Values.paymentdb -}}
{ 
{{- range $key, $val := .Values.paymentdb -}}
  {{- if hasKey $.Values "global" -}}
    {{- if hasKey $.Values.global "paymentdb" -}}
      {{- if hasKey $.Values.global.paymentdb $key -}}
        {{ $key | quote }}: {{ index $.Values.global.paymentdb ($key) | quote }}
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
 Define all variables that are required and used in templates
*/}}
{{- define "paymentdb_usr" -}}
{{- get (include "paymentdb" . | fromJson) "username" -}}
{{- end -}}

{{- define "paymentdb_svc" -}}
{{- get (include "paymentdb" . | fromJson) "service" -}}
{{- end -}}

{{- define "paymentdb_db" -}}
{{- get (include "paymentdb" . | fromJson) "database" -}}
{{- end -}}

{{- define "paymentdb_adm" -}}
{{- get (include "paymentdb" . | fromJson) "db_admin" -}}
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

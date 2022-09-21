{{/*
Expand the name of the chart.
*/}}
{{- define "paymentapprovals.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "paymentapprovalsconsumer.name" -}}
{{- printf "%s-%s" (default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-") "consumer" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "paymentapprovals.fullname" -}}
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
{{- define "paymentapprovals.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "paymentapprovals.labels" -}}
name: {{ include "paymentapprovals.name" . }}
chart: {{ include "paymentapprovals.chart" . }}
{{ include "paymentapprovals.selectorLabels" . }}
{{- if .Chart.AppVersion }}
version: {{ .Chart.AppVersion | quote }}
{{- end }}
heritage: {{ .Release.Service }}
{{- end }}

{{- define "paymentapprovalsconsumer.labels" -}}
name: {{ include "paymentapprovalsconsumer.name" . }}
chart: {{ include "paymentapprovals.chart" . }}
{{ include "paymentapprovalsconsumer.selectorLabels" . }}
{{- if .Chart.AppVersion }}
version: {{ .Chart.AppVersion | quote }}
{{- end }}
heritage: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "paymentapprovals.selectorLabels" -}}
app: {{ template "paymentapprovals.name" . }}
component: {{ template "paymentapprovals.fullname" . }}
release: {{ .Release.Name }}
tier: {{ .Values.service.tier }}
{{- end }}

{{- define "paymentapprovalsconsumer.selectorLabels" -}}
app: {{ template "paymentapprovals.name" . }}
component: {{ template "paymentapprovalsconsumer.name" . }}
release: {{ .Release.Name }}
tier: {{ .Values.consumer.tier }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "paymentapprovals.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "paymentapprovals.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Rolling Update Deployment Strategy
*/}}
{{- define "paymentapprovals.rollingUpdateDeploymentStrategy" -}}
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
{{/*
Expand the name of the chart.
*/}}
{{- define "authsvc.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "authsvc.fullname" -}}
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
{{- define "authsvc.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "authsvc.labels" -}}
name: {{ include "authsvc.name" . }}
chart: {{ include "authsvc.chart" . }}
{{ include "authsvc.selectorLabels" . }}
{{- if .Chart.AppVersion }}
version: {{ .Chart.AppVersion | quote }}
{{- end }}
heritage: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "authsvc.selectorLabels" -}}
app: {{ template "authsvc.name" . }}
component: {{ template "authsvc.fullname" . }}
release: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "authsvc.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "authsvc.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Rolling Update Deployment Strategy
*/}}
{{- define "authsvc.rollingUpdateDeploymentStrategy" -}}
maxSurge: {{ default "50%" .Values.rollingUpdateDeploymentStrategy.maxSurge }}
maxUnavailable: {{ default "20%" .Values.rollingUpdateDeploymentStrategy.maxUnavailable }}
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
 Define all variables that are required and used in templates
*/}}
{{- define "db_usr" -}}
{{- get (include "db" . | fromJson) "username" }}
{{- end -}}
{{- define "db_svc" -}}
{{- get (include "db" . | fromJson) "service" }}
{{- end -}}
{{- define "db_db" -}}
{{- get (include "db" . | fromJson) "database" }}
{{- end -}}
{{- define "db_adm" -}}
{{- get (include "db" . | fromJson) "db_admin" }}
{{- end -}}

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
Define autoscaling scaleTargetRef block.
*/}}
{{- define "authsvc.autoscaling.scaleTargetRef" -}}
name: {{ include "authsvc.fullname" . }}
kind: {{ default "Deployment" .Values.autoscaling.resourceKind }}
{{- end }}

{{/*
Define autoscaling trigger.metadata block for cpu.
*/}}
{{- define "authsvc.autoscaling.cpu.triggerMetadata" -}}
value: {{ .Values.autoscaling.cpuTargetValue | quote }}
{{- end }}

{{/*
Define autoscaling trigger.metadata block for memory.
*/}}
{{- define "authsvc.autoscaling.memory.triggerMetadata" -}}
value: {{ .Values.autoscaling.memoryTargetValue | quote }}
{{- end }}
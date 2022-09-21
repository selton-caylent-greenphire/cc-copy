{{/*
Expand the name of the chart.
*/}}
{{- define "antivir.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "antivir.clamav.name" -}}
{{- printf "%s-%s" "clamav" "server" -}}
{{- end -}}

{{- define "antivir.scanner.name" -}}
{{- printf "%s-%s" "virus" "scanning" -}}
{{- end -}} 

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "antivir.fullname" -}}
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
{{- define "antivir.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "antivir.labels" -}}
chart: {{ include "antivir.chart" . }}
{{ include "antivir.selectorLabels" . }}
{{- if .Chart.AppVersion }}
version: {{ .Chart.AppVersion | quote }}
{{- end }}
heritage: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "antivir.selectorLabels" -}}
app: {{ template "antivir.name" . }}
release: {{ .Release.Name }}
tier: {{ .Values.tier }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "antivir.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "antivir.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Rolling Update Deployment Strategy
*/}}
{{- define "antivir.rollingUpdateDeploymentStrategy" -}}
maxSurge: {{ default "50%" .Values.rollingUpdateDeploymentStrategy.maxSurge }}
maxUnavailable: {{ default "20%" .Values.rollingUpdateDeploymentStrategy.maxUnavailable }}
{{- end }}

{{/*
 Variables definition
*/}}
{{- define "virusscan" -}}
{{- if $.Values.global -}}
{{  default .Values.virusscan $.Values.global.virusscan }}
{{- else -}}
{{ .Values.virusscan }}
{{- end -}}
{{- end -}}

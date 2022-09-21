{{/*
Expand the name of the chart.
*/}}
{{- define "ccadmin.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "ccadmin.envvars" -}}
{{- include "ccadmin.name" . }}-env-vars
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ccadmin.fullname" -}}
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
{{- define "ccadmin.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ccadmin.labels" -}}
name: {{ include "ccadmin.name" . }}
chart: {{ include "ccadmin.chart" . }}
{{ include "ccadmin.selectorLabels" . }}
{{- if .Chart.AppVersion }}
version: {{ .Chart.AppVersion | quote }}
{{- end }}
heritage: {{ .Release.Service }}
{{- end }}


{{- define "ccadmin.envvars.labels" -}}
name: {{ include "ccadmin.envvars" . }}
chart: {{ include "ccadmin.chart" . }}
{{- if .Chart.AppVersion }}
version: {{ .Chart.AppVersion | quote }}
{{- end }}
heritage: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ccadmin.selectorLabels" -}}
app: {{ template "ccadmin.name" . }}
component: {{ template "ccadmin.fullname" . }}
release: {{ .Release.Name }}
tier: {{ .Values.tier }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ccadmin.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ccadmin.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Rolling Update Deployment Strategy
*/}}
{{- define "ccadmin.rollingUpdateDeploymentStrategy" -}}
maxSurge: {{ default "50%" .Values.rollingUpdateDeploymentStrategy.maxSurge }}
maxUnavailable: {{ default "20%" .Values.rollingUpdateDeploymentStrategy.maxUnavailable }}
{{- end }}

{{/*
Build global override variables in JSON to be parsed in templates
*/}}
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
{{- define "hosts_domain" -}}
{{- get (include "hosts" . | fromJson) "domain" -}}
{{- end -}}

{{- define "hosts_cc" -}}
{{- get (include "hosts" . | fromJson) "clincard" -}}
{{- end -}}

{{- define "hosts_api" -}}
{{- get (include "hosts" . | fromJson) "api" -}}
{{- end -}}

{{- define "hosts_apiint" -}}
{{- get (include "hosts" . | fromJson) "apiinternal" -}}
{{- end -}}

{{- define "hosts_static" -}}
{{- get (include "hosts" . | fromJson) "static" -}}
{{- end -}}

{{- define "hosts_ccadmin" -}}
{{- get (include "hosts" . | fromJson) "ccadmin" -}}
{{- end -}}

{{- define "hosts_ccalt" -}}
{{- get (include "hosts" . | fromJson) "ccalt" -}}
{{- end -}}

{{- define "hosts_ws" -}}
{{- get (include "hosts" . | fromJson) "ws" -}}
{{- end -}}

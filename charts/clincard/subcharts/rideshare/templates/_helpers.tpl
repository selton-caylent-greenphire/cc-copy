{{/*
Expand the name of the chart.
*/}}
{{- define "rideshare.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "rideshare.fullname" -}}
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

{{- define "rideshare.celery.fullname" -}}
{{ template "rideshare.fullname" . }}-celery
{{- end -}}

{{- define "rideshare.consumer.fullname" -}}
{{ template "rideshare.fullname" . }}-consumer
{{- end -}}

{{- define "rideshare.svc.fullname" -}}
{{ template "rideshare.fullname" . }}-svc
{{- end -}}

{{- define "rideshare.secrets" -}}
{{ template "rideshare.fullname" . }}-secrets
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "rideshare.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "rideshare.labels" -}}
name: {{ include "rideshare.name" . }}
chart: {{ include "rideshare.chart" . }}
{{ include "rideshare.selectorLabels" . }}
{{- if .Chart.AppVersion }}
version: {{ .Chart.AppVersion | quote }}
{{- end }}
heritage: {{ .Release.Service }}
{{- end }}

{{- define "rideshare.celery.labels" -}}
name: {{ include "rideshare.celery.fullname" . }}
chart: {{ include "rideshare.chart" . }}
{{ include "rideshare.celery.selectorLabels" . }}
{{- if .Chart.AppVersion }}
version: {{ .Chart.AppVersion | quote }}
{{- end }}
heritage: {{ .Release.Service }}
{{- end }}

{{- define "rideshare.consumer.labels" -}}
name: {{ include "rideshare.consumer.fullname" . }}
chart: {{ include "rideshare.chart" . }}
{{ include "rideshare.consumer.selectorLabels" . }}
{{- if .Chart.AppVersion }}
version: {{ .Chart.AppVersion | quote }}
{{- end }}
heritage: {{ .Release.Service }}
{{- end }}

{{- define "rideshare.svc.labels" -}}
name: {{ include "rideshare.svc.fullname" . }}
chart: {{ include "rideshare.chart" . }}
{{ include "rideshare.selectorLabels" . }}
{{- if .Chart.AppVersion }}
version: {{ .Chart.AppVersion | quote }}
{{- end }}
heritage: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "rideshare.selectorLabels" -}}
app: {{ template "rideshare.name" . }}
component: {{ template "rideshare.fullname" . }}
release: {{ .Release.Name }}
tier: {{ .Values.tier }}
{{- end }}

{{- define "rideshare.celery.selectorLabels" -}}
app: {{ template "rideshare.name" . }}
component: {{ template "rideshare.celery.fullname" . }}
release: {{ .Release.Name }}
tier: {{ .Values.rideshareCelery.tier }}
{{- end }}

{{- define "rideshare.consumer.selectorLabels" -}}
app: {{ template "rideshare.name" . }}
component: {{ template "rideshare.consumer.fullname" . }}
release: {{ .Release.Name }}
tier: {{ .Values.rideshareConsumer.tier }}
{{- end }}

{{- define "rideshare.svc.selectorLabels" -}}
app: {{ template "rideshare.name" . }}
component: {{ template "rideshare.svc.fullname" . }}
release: {{ .Release.Name }}
tier: {{ .Values.rideshareService.tier }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "rideshare.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "rideshare.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Rolling Update Deployment Strategy
*/}}
{{- define "rideshare.rollingUpdateDeploymentStrategy" -}}
maxSurge: {{ default "50%" .Values.rollingUpdateDeploymentStrategy.maxSurge }}
maxUnavailable: {{ default "20%" .Values.rollingUpdateDeploymentStrategy.maxUnavailable }}
{{- end }}

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
Build global.hosts override variables in JSON to be parsed in templates
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

{{- define "cel_usr" -}}
{{ get (include "celery" . | fromJson) "username" }}
{{- end -}}

{{- define "cel_svc" -}}
{{ get (include "celery" . | fromJson) "service" }}
{{- end -}}

{{- define "db_usr" -}}
{{- get (include "db" . | fromJson) "username" -}}
{{- end -}}

{{- define "db_svc" -}}
{{- get (include "db" . | fromJson) "service" -}}
{{- end -}}

{{- define "db_adm" -}}
{{- get (include "db" . | fromJson) "db_admin" -}}
{{- end -}}

{{- define "db_db" -}}
{{- get (include "db" . | fromJson) "database" -}}
{{- end -}}

{{- define "rmq_usr" -}}
{{- get (include "rabbit" . | fromJson) "username" -}}
{{- end -}}

{{- define "rmq_svc" -}}
{{- get (include "rabbit" . | fromJson) "service" -}}
{{- end -}}

{{- define "hosts_ws" -}}
{{- get (include "hosts" . | fromJson) "ws" -}}
{{- end -}}
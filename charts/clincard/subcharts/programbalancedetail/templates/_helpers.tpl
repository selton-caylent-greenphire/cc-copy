{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "programbalancedetail.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "programbalancedetail.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "programbalancedetail.labels" -}}
name: {{ include "programbalancedetail.name" . }}
chart: {{ include "programbalancedetail.chart" . }}
{{- if .Chart.AppVersion }}
version: {{ .Chart.AppVersion | quote }}
{{- end }}
heritage: {{ .Release.Service }}
{{- end }}

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

{{- define "couchdb" }}
{{- $i := 0 -}}
{{- $length := len .Values.couchdb -}}
{ 
{{- range $key, $val := .Values.couchdb -}}
  {{- if hasKey $.Values "global" -}}
    {{- if hasKey $.Values.global "couchdb" -}}
      {{- if hasKey $.Values.global.couchdb $key -}}
        {{ $key | quote }}: {{ index $.Values.global.couchdb ($key) | quote }}
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
{{- define "programbalancedetail.fullname" -}}
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
{{- define "programbalancedetail.consumer.fullname" -}}
{{ template "programbalancedetail.fullname" . }}-consumer
{{- end -}}

{{- define "programbalancedetail.couchinit.fullname" -}}
{{ template "programbalancedetail.fullname" . }}-couchinit
{{- end -}}

{{/*
Create the name of the service account to use for the master component
*/}}
{{- define "programbalancedetail.serviceAccountName.master" -}}
{{- if .Values.serviceAccounts.master.create -}}
    {{ default (include "programbalancedetail.master.fullname" .) .Values.serviceAccounts.master.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.master.name }}
{{- end -}}
{{- end -}}

{{/*
Define autoscaling scaleTargetRef block.
*/}}
{{- define "programbalancedetail.consumer.autoscaling.scaleTargetRef" -}}
name: {{ include "programbalancedetail.consumer.fullname" . }}
kind: {{ default "Deployment" .Values.resources.consumer.autoscaling.resourceKind }}
{{- end }}

{{/*
Define autoscaling trigger.metadata.mode block.
*/}}
{{- define "programbalancedetail.consumer.autoscaling.triggerMetadata.mode" -}}
{{- default "QueueLength" .Values.resources.consumer.autoscaling.metricType -}}
{{- end }}

{{/*
Define autoscaling trigger.metadata block.
*/}}
{{- define "programbalancedetail.consumer.autoscaling.triggerMetadata" -}}
hostFromEnv: {{ default "RABBITMQ_URL" .Values.resources.consumer.autoscaling.rabbitmqUrlEnvVar }} # reads from target
metricName: {{ default ( printf "%s-%s" .Values.resources.consumer.autoscaling.rabbitmqQueueName ( include "programbalancedetail.consumer.autoscaling.triggerMetadata.mode" . )) .Values.resources.consumer.autoscaling.rabbitmqMetricName }} # Optional
mode: {{ include "programbalancedetail.consumer.autoscaling.triggerMetadata.mode" . }} # QueueLength | MessageRate
protocol: {{ default "auto" .Values.resources.consumer.autoscaling.protocol }} # based on host url or either amqp or http
queueName: {{ .Values.resources.consumer.autoscaling.rabbitmqQueueName }}
value: {{ .Values.resources.consumer.autoscaling.rabbitmqTargetValue | quote }}
{{- end }}
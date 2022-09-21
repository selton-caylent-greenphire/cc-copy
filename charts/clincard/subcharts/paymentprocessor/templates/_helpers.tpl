{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "paymentprocessor.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "paymentprocessor.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
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
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "paymentprocessor.fullname" -}}
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
{{- define "paymentprocessor.payments.fullname" -}}
{{ template "paymentprocessor.fullname" . }}-payment-processor
{{- end -}}

{{- define "paymentprocessor.rqworker.fullname" -}}
{{ template "paymentprocessor.fullname" . }}-rqworker
{{- end -}}

{{/*
Create the name of the service account to use for the components
*/}}
{{- define "paymentprocessor.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "paymentprocessor.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "paymentprocessor.labels" -}}
name: {{ include "paymentprocessor.name" . }}
chart: {{ include "paymentprocessor.chart" . }}
{{- if .Chart.AppVersion }}
version: {{ .Chart.AppVersion | quote }}
{{- end }}
heritage: {{ .Release.Service }}
{{- end }}

{{/*
Define common variables
*/}}
{{- define "psvc" -}}
{{ get (include "portaldb" . | fromJson) "service" }}
{{- end -}}

{{- define "pdb_adm" -}}
{{  get (include "portaldb" . | fromJson) "db_admin" }}
{{- end -}}

{{- define "pusr" -}}
{{ get (include "portaldb" . | fromJson) "username" }}
{{- end -}}

{{- define "pdb" -}}
{{ get (include "portaldb" . | fromJson) "database" }}
{{- end -}}

{{- define "rmq_usr" -}}
{{ get (include "rabbit" . | fromJson) "username" }}
{{- end -}}

{{- define "rmq_svc" -}}
{{ get (include "rabbit" . | fromJson) "service" }}
{{- end -}}

{{/*
Define autoscaling scaleTargetRef block.
*/}}
{{- define "paymentprocessor.autoscaling.scaleTargetRef" -}}
name: {{ include "paymentprocessor.fullname" . }}
kind: {{ default "Deployment" .Values.autoscaling.resourceKind }}
{{- end }}

{{/*
Define autoscaling trigger.metadata.mode block.
*/}}
{{- define "paymentprocessor.autoscaling.triggerMetadata.mode" -}}
{{- default "QueueLength" .Values.autoscaling.metricType -}}
{{- end }}

{{/*
Define autoscaling trigger.metadata block.
*/}}
{{- define "paymentprocessor.autoscaling.triggerMetadata" -}}
hostFromEnv: {{ default "RABBITMQ_URL" .Values.autoscaling.rabbitmqUrlEnvVar }} # reads from target
metricName: {{ default ( printf "%s-%s" .Values.autoscaling.rabbitmqQueueName ( include "paymentprocessor.autoscaling.triggerMetadata.mode" . )) .Values.autoscaling.rabbitmqMetricName }} # Optional
mode: {{ include "paymentprocessor.autoscaling.triggerMetadata.mode" . }} # QueueLength | MessageRate
protocol: {{ default "auto" .Values.autoscaling.protocol }} # based on host url or either amqp or http
queueName: {{ .Values.autoscaling.rabbitmqQueueName }}
value: {{ .Values.autoscaling.rabbitmqTargetValue | quote }}
{{- end }}
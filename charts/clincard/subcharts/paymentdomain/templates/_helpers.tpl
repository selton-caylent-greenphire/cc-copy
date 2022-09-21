{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "paymentdomain.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
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
Create chart name and version as used by the chart label.
*/}}
{{- define "paymentdomain.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "paymentdomain.labels" -}}
name: {{ include "paymentdomain.name" . }}
chart: {{ include "paymentdomain.chart" . }}
{{- if .Chart.AppVersion }}
version: {{ .Chart.AppVersion | quote }}
{{- end }}
heritage: {{ .Release.Service }}
{{- end }}


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
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "paymentdomain.fullname" -}}
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
{{- define "paymentdomain.consumer.fullname" -}}
{{ template "paymentdomain.fullname" . }}-consumer
{{- end -}}

{{/*
Create the name of the service account to use for the master component
*/}}
{{- define "paymentdomain.serviceAccountName.master" -}}
{{- if .Values.serviceAccounts.master.create -}}
    {{ default (include "paymentdomain.master.fullname" .) .Values.serviceAccounts.master.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.master.name }}
{{- end -}}
{{- end -}}

{{/*
Define autoscaling scaleTargetRef block.
*/}}
{{- define "paymentdomain.consumer.autoscaling.scaleTargetRef" -}}
name: {{ include "paymentdomain.consumer.fullname" . }}
kind: {{ default "Deployment" .Values.resources.consumer.autoscaling.resourceKind }}
{{- end }}

{{/*
Define autoscaling trigger.metadata.mode block.
*/}}
{{- define "paymentdomain.consumer.autoscaling.triggerMetadata.mode" -}}
{{- default "QueueLength" .Values.resources.consumer.autoscaling.metricType -}}
{{- end }}

{{/*
Define autoscaling trigger.metadata block.
*/}}
{{- define "paymentdomain.consumer.autoscaling.triggerMetadata" -}}
hostFromEnv: {{ default "RABBITMQ_URL" .Values.resources.consumer.autoscaling.rabbitmqUrlEnvVar }} # reads from target
metricName: {{ default ( printf "%s-%s" .Values.resources.consumer.autoscaling.rabbitmqQueueName ( include "paymentdomain.consumer.autoscaling.triggerMetadata.mode" . )) .Values.resources.consumer.autoscaling.rabbitmqMetricName }} # Optional
mode: {{ include "paymentdomain.consumer.autoscaling.triggerMetadata.mode" . }} # QueueLength | MessageRate
protocol: {{ default "auto" .Values.resources.consumer.autoscaling.protocol }} # based on host url or either amqp or http
queueName: {{ .Values.resources.consumer.autoscaling.rabbitmqQueueName }}
value: {{ .Values.resources.consumer.autoscaling.rabbitmqTargetValue | quote }}
{{- end }}
{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "tenninetynine.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
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
{{- define "tenninetynine.fullname" -}}
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
Build global override variables in JSON to be parsed in templates
*/}}
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
Create a default fully qualified master name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "tenninetynine.consumer.fullname" -}}
{{ template "tenninetynine.fullname" . }}-consumer
{{- end -}}

{{/*
Create the name of the service account to use for the master component
*/}}
{{- define "tenninetynine.serviceAccountName.master" -}}
{{- if .Values.serviceAccounts.master.create -}}
    {{ default (include "tenninetynine.master.fullname" .) .Values.serviceAccounts.master.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.master.name }}
{{- end -}}
{{- end -}}

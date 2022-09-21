{{- define "opentelemetry_envs" }}
- name: OTEL_TRACES_EXPORTER
  value: otlp_proto_http
- name: OTEL_EXPORTER_OTLP_TRACES_ENDPOINT
  value: http://sumologic-sumologic-otelcol.monitoring:55681/v1/traces
- name: OTEL_SERVICE_NAME
  value: {{ template "service.fullname" . }}
- name: OTEL_RESOURCE_ATTRIBUTES
  value: "application={{ .Release.Namespace }}"
{{ end }}

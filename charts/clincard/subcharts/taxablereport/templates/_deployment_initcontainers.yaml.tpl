- name: wait-for-configsvc
  image: alpine/curl
  command: ["sh", "-c", "until curl --fail --connect-timeout 5 http://{{ .Values.dependencies.configsvc}}.{{ .Release.Namespace}}:8080/swagger.json; do sleep 2; done"]
- name: wait-for-paymentdomain
  image: alpine/curl
  command: ["sh", "-c", "until curl --fail --connect-timeout 5 http://{{ .Values.dependencies.paymentdomain}}.{{ .Release.Namespace}}:8080/swagger.json; do sleep 2; done"]
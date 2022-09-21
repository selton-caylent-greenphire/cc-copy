- name: GOOGLE_API_JS_KEY
  valueFrom:
    secretKeyRef:
      key: google_api_js_key
      name: {{ template "service.secret" . }}
- name: GOOGLE_MAPS_API_KEY
  valueFrom:
    secretKeyRef:
      key: google_maps_api_key
      name: {{ template "service.secret" . }}
- name: GOOGLE_RECAPTCHA_SECRET_KEY
  valueFrom:
    secretKeyRef:
      key: google_recaptcha_secret_key
      name: {{ template "service.secret" . }}
- name: GOOGLE_RECAPTCHA_SITE_KEY
  valueFrom:
    secretKeyRef:
      key: google_recaptcha_site_key
      name: {{ template "service.secret" . }}
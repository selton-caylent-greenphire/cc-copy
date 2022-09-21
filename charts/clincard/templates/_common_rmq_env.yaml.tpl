- name: RABBIT_PASS
  valueFrom:
    secretKeyRef:
      key: payments
      name: {{ .Values.dependencies.rabbitsecrets }}
- name: RABBIT_CELERY_PASS
  valueFrom:
    secretKeyRef:
      key: celery
      name: {{ .Values.dependencies.rabbitsecrets }}
- name: RABBITMQ_URL
  value: {{ printf "amqp://%s:$(RABBIT_PASS)@%s.%s:5672/" (include "rmq_usr" .) (include "rmq_svc" .) .Release.Namespace }}
- name: CELERY_RABBITMQ_URL
  value: {{ printf "amqp://%s:$(RABBIT_CELERY_PASS)@%s.%s:5672/celery" (include "cel_usr" .) (include "cel_svc" .) .Release.Namespace }}
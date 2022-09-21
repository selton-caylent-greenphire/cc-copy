{{- if .Values.ebs.create -}}
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
 name: gp2-encrypted
 annotations:
   storageclass.beta.kubernetes.io/is-default-class: "true"
 labels:
   k8s-addon: storage-aws.addons.k8s.io
provisioner: kubernetes.io/aws-ebs
parameters:
 type: gp2
 encrypted: "true"
---
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: io1-encrypted-fast
  labels:
    k8s-addon: storage-aws.addons.k8s.io
provisioner: kubernetes.io/aws-ebs
parameters:
  type: io1
  iopsPerGB: "50"
  encrypted: "true"
---
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: io1-encrypted-medium
  labels:
    k8s-addon: storage-aws.addons.k8s.io
provisioner: kubernetes.io/aws-ebs
parameters:
  type: io1
  iopsPerGB: "25"
  encrypted: "true"
{{- end -}}
{{/*
Create a default fully qualified app name.
*/}}
{{- define "purely.fullname" -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "purely.labels" -}}
app: {{ .name }}
{{- end }}

{{/*
Common environment variables for services
*/}}
{{- define "purely.commonEnv" -}}
- name: MONGODB_HOST
  valueFrom:
    configMapKeyRef:
      name: purely-config
      key: MONGODB_HOST
- name: MONGODB_PORT
  valueFrom:
    configMapKeyRef:
      name: purely-config
      key: MONGODB_PORT
- name: MONGODB_USERNAME
  valueFrom:
    secretKeyRef:
      name: mongodb-secret
      key: mongo-root-username
- name: MONGODB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: mongodb-secret
      key: mongo-root-password
- name: MONGODB_AUTHSOURCE
  valueFrom:
    configMapKeyRef:
      name: purely-config
      key: MONGODB_AUTHSOURCE
- name: SERVICE_REGISTRY_SERVICE_URL
  valueFrom:
    configMapKeyRef:
      name: purely-config
      key: SERVICE_REGISTRY_SERVICE_URL
{{- end }}
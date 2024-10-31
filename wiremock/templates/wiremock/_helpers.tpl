{{/*
Expand the name of the chart.
*/}}
{{- define "wiremock.name" -}}
{{- default .Chart.Name .Values.wiremock_istance_local.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "wiremock.fullname" -}}
{{- if .Values.wiremock_istance_local.fullnameOverride }}
{{- .Values.wiremock_istance_local.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.wiremock_istance_local.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "wiremock.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "wiremock.labels" -}}
helm.sh/chart: {{ include "wiremock.chart" . }}
{{ include "wiremock.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "wiremock.selectorLabels" -}}
app.kubernetes.io/name: {{ include "wiremock.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "wiremock.serviceAccountName" -}}
{{- if .Values.wiremock_istance_local.serviceAccount.create }}
{{- default (include "wiremock.fullname" .) .Values.wiremock_istance_local.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.wiremock_istance_local.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Pod annotations
*/}}
{{- define "wiremock.podAnnotations" -}}
checksum/configMappings: {{ include (print $.Template.BasePath "/wiremock/configmap-mappings.yaml") . | sha256sum }}
checksum/configResponses: {{ include (print $.Template.BasePath "/wiremock/configmap-responses.yaml") . | sha256sum }}
{{- if .Values.wiremock_istance_local.podAnnotations }}
{{ .Values.wiremock_istance_local.podAnnotations }}
{{- end }}
{{- end }}


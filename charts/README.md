# Clincard Charts

**Table of Content**
- [Clincard Charts](#clincard-charts)
    - [Project structure](#project-structure)
  - [Subcharts](#subcharts)
    - [Adding a new subchart dependency](#adding-a-new-subchart-dependency)
    - [Adding dependency in Chart.yaml](#adding-dependency-in-chartyaml)
    - [Enabling dependency and overwrite the sub-chart values.yaml](#enabling-dependency-and-overwrite-the-sub-chart-valuesyaml)
  - [Global Values](#global-values)
  - [Version](#version)
  - [Helm charts helpers](#helm-charts-helpers)
    - [Use of _helpers.tpl file](#use-of-_helperstpl-file)
    - [Define a dynamic template file](#define-a-dynamic-template-file)
  - [Change procedure](#change-procedure)
    - [Templating](#templating)
    - [Update the Chart version](#update-the-chart-version)
    - [Check your work](#check-your-work)
      - [--dry-run install](#--dry-run-install)
      - [helm template validation](#helm-template-validation)
      - [helm lint validation](#helm-lint-validation)
    - [Commit & Push](#commit--push)
  - [Helm useful commands](#helm-useful-commands)
    - [Chart history](#chart-history)
    - [Helm rollback](#helm-rollback)
  - [The Flux Console](#the-flux-console)

This directory contains the helm charts. These are derived from the old Kubernetes manifests that are found in Github in the repo /Greenphire/Kubernetes. Changes here should go through keith.milligan@greenphire.com. Developers should very rarely need to change what's in here. However in the beginning of continuous delivery and continuous deployment (for low level environments), there may be templates that need to have settable values. The basic structure of the chart is as follows:

| File         | Description |
|--------------|-------------|
| Chart.yaml   | Defines the chart. Any time a chart is updated here, you will need to bump the chart's version number so that Flux will know there's been an update that needs deployment. It will also help you see whether the chart deploys. |
| values.yaml  | The values file. Every item in a chart that can be changed is set here. This file contains default values. The HelmRelease file found in `/Greenphire/clincard-config/<cluster>/<namespace>/releases` defines what the values are for a particular deploy.|
| templates    | Contains all the helm template files. These are Kubernetes manifests that have had values templated so that they can be set as needed for each deployment. |

### Project structure

Clinard's main chart is in the `charts/clincard` path. This chart uses multiple sub-charts dependencies located in `charts/clincard/subcharts`

```sh
├ clincard 
├── Chart.yaml  ## Main Chart info and configuration 
├── README.md ## Main chart documentation 
├── subcharts ## Sub-charts dependencies folder
├── templates ## Main chart helm templates  
└── values.yaml ## Main chart values file. 
```
## Subcharts
Most of the microservices for ClincCard (with the exception of the off-the-shelf deployments like rabbit) are kept as subcharts in the ClinCard chart. Subcharts can be individually enabled and disabled in the release, and values in those subcharts overridden.

### Adding a new subchart dependency
To include a new subchart dependency, you need to create the new chart in the `subchart` folder and configure it into the main `Chart.yaml` file located in `charts/clincard/Chart.yaml`

```sh
├ clincard
├── Chart.yaml  ## Main Chart info and configuration 
├── README.md 
├── subcharts ## Subcharts dependencies folder
├──── antivir ## New subchart dependency
├────── templates ## subchart helm templates
├────── Chart.yaml ## Subchart info and configuration
├────── README.md ## Subchart documentation
├────── values.yaml ## Subchart values file
├── templates 
└── values.yaml ## Main chart values file. 
```
### Adding dependency in Chart.yaml

You need to configure the path and conditions to enable the subchart dependency in the dependency block in the `Chart.yaml` file
```yaml 
## charts/clincard/Chart.yaml 
apiVersion: v2
appVersion: "1.0"
description: A Helm chart deploying ClinCard
name: clincard
version: 0.15.6
dependencies:  ## Dependency block 
- name: antivir ## subchart dependency
  version: ">= 0.1.0" ## Required version
  repository: file://subcharts/antivir/ ## Subchart dependency path
  condition: antivir.enabled ## Condition to enable the subchart dependency
```

### Enabling dependency and overwrite the sub-chart values.yaml
Once you are including the subchart dependency in the main Chart.yaml file, you can enable it in the main values.yaml file located in `charts/clincard/values.yaml`
```yaml
## charts/clincard/values.yaml
## Main chart configurations
## ....

## Subchart block configuration 
antivir: 
  enabled: true ## Subchart dependency condition (enable/disable)

## Main chart configurations
## ....
```

All variables that you define into the subchart dependency block will overwrite the `subchart/values.yaml` file.

**Example**:

***charts/clincard/values.yaml***
```yaml
antivir: 
  enabled: true ## Subchart dependency condition (enable/disable)
  secretpath: mysecretpath
  tier: custom
```
***charts/clincard/subcharts/antivir/values.yaml***
```yaml
secretpath: lower
tier: api
```
> with the previous configuration, If the helm chart template is populated, it would have values `mysecretpath` and `custom` for `secretpath` and `tier` variables.

## Global Values
We use templating to create "global" values that override certain values globally. See the `_helpers.tpl` file to understand how these global values work. Things like URLs can just be set in the main Clincard chart's `global:` section, and they will be changed everywhere, without the need to override the values in invidiual charts.
## Version
All these charts are targeted toward [Helm](https://helm.sh/) Version 3. Helm is a tool for deploying to Kubernetes clusters. You can find Helm at the link [here](https://helm.sh/docs/intro/install/). It is not strictly needed to install Helm to deploy a release change, but to change the charts it is a must, and it is a helpful tool generally. Helm piggybacks off your Kubernetes permissions, so if you can use the `kubectl` tool, you can use Helm.

## Helm charts helpers
Helpers are used to defining global variables and dynamic templates that you can use in your chart.

### Use of _helpers.tpl file
This helper file is located in the templates folder in each chart. 
```sh
├── Chart.yaml  
├── README.md 
├── templates ## helm chart templates 
├──── _helpers.tpl ## Default helper file
├──── deployment.yaml 
├──── service.yaml 
├──── secrets.yaml 
└── values.yaml ## Chart values file. 
```
In this file, you can define global variables or functions that you will use in your chart. 
***Example:***
```yaml
## _helpers.tpl
{{- define "service.fullname" -}}
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
```
You can use the previous definition into your template files as follow:

Use the `template` tag to include the value as was defined in the `helpers.tpl` file
```yaml
## deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ template "service.fullname" . }}
```
Or use the `include` tag if you want to use multiple functions to modify the value defined in the `helpers.tpl` file
labels: 
```yaml
## deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "service.fullname" . | quote }}
```

### Define a dynamic template file
You can define a `tpl` file to use it as dynamic template in your chart.
In the following example we are going to define a dynamic `_configmap.json.tpl`

***templates/_configmap.json.tpl***
```json
    "gunicorn": {
        "bind": {{ default "0.0.0.0:3320" .gunicornBind | quote}},
        "workers": {{ default 2 .gunicornWorkers}},
        "threads": {{ default 1 .gunicornThreads}},
        "timeout": {{ default 60 .gunicornTimeout}},        
        "accesslog": {{ default "-" .gunicornAccesslog | quote}} ,
        "logger_class": {{ default "jslog4kube.GunicornLogger" .gunicornLoggerClass | quote}}
    }
```

***values.yaml***
```yaml
configmap-1:
  name: map-1
  gunicornBind: "192.168.1.1:3320"
  gunicornWorkers: 20   
configmap-2:
  name: map-2
  gunicornBind: "192.168.1.2:3320"  
  gunicornWorkers: 5   
  gunicornTimeout: 120
```

***template/configmap-1.yaml***
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Values.configmap-1.name }}  
data:
  value: {{ include (print $.Template.BasePath "_configmap.json.tpl" ) .Values.configmap-1 | toYaml | indent 4 }} 
```

***template/configmap-2.yaml***
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Values.configmap-2.name }}  
data:
  value: {{ include (print $.Template.BasePath "_configmap.json.tpl" ) .Values.configmap-2 | toYaml | indent 4 }}  
```
> **Note:**: Take care with the context that you use in the included template sentence. In the previous example, we are using two different contexts to use the template file (`.Values.configmap-1`, `.Values.configmap-2`)


With the previous configuration, the template population will be the following:

```yaml
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: map-1  
data:
  value: |
  "gunicorn": {
        "bind": "192.168.1.1:3320",
        "workers": 20,
        "threads": 1 ,
        "timeout": 60,        
        "accesslog": "-",
        "logger_class": "jslog4kube.GunicornLogger"
    } 
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: map-2  
data:
  value: |
  "gunicorn": {
        "bind": "192.168.1.2:3320",
        "workers": 5,
        "threads": 1,
        "timeout": 120,        
        "accesslog": "-",
        "logger_class": "jslog4kube.GunicornLogger"
    } 
```
## Change procedure
### Templating
If a change needs to be made to template a value, for instance:
```yaml
mail_host: smtp.gmail.com
```
We want to be able to change this on each deployment. So we need to make it take a value:
```yaml
mail_host: {{ .Values.email_host }}
```
We need to then make a corresponding entry into the `values.yaml` file:
```yaml
email_host: smtp.gmail.com
```
This does not actually change the default value, but now you can make an entry in the values section of the `/Greenphire/clincard-config/<cluster>/<namespace>/releases` files:
```yaml
  values:
    email_host: smtp.greenphire.net
```
This value in the HelmRelease manifest that Flux uses to deploy will override the default found in the chart. This can now be changed in any release without needing to make a change to any Kubernetes manifest. Alternately, if you had several email related values, you could choose to template like this:
```yaml
mail_host: smtp.gmail.com
mail_user: clincard
mail_html: false
```
The template here should be grouped in the `values.yaml` file:
```yaml
email:
  host: smtp.gmail.com
  user: clincard
  html: false
 ```
 And then the template would be changed to reflect this:
 ```yaml
 mail_host: {{ .Values.email.host }}
 mail_user: {{ .Values.email.user }}
 mail_html: {{ .Values.email.html }}
```
Again, you can now override these values in your `/Greenphire/clincard-config/<cluster>/<namespace>/releases` files.

<em>NOTE</em>: Secrets should never be entered into a template or values file. To understand secrets, see the main README file.

### Update the Chart version
Change `Chart.yaml` to increase the `version:` field so that Flux knows there's a chart change that needs to be deployed.

### Check your work
#### --dry-run install 
Make sure any change you make to the chart can render into Kubernetes manifest and that the result is what you expect. This can be done with Helm.
```sh
helm install --generate-name <chart directory> --dry-run [-n dummynamespace]
```
If the chart is already deployed in your set namespace, you might need to give it an optional dummy namespace to avoid a `rendered manifests contain a resource that already exists.` error. Also, you'll want to lint the chart as well:

#### helm template validation
Another way to accomplish this is using the helm template tool to validate what will be populated with the current configuration: `helm template <release_name> . -n <ns>`

```sh  
helm template clincard . -n prod 
```
If you get one error you can use the `--debug` flag to identify where is failing your template. 
```sh 
helm template clincard . -n prod --debug
```

#### helm lint validation

```sh
helm lint <chart directory> --strict
```
Fix any errors that crop up here.
### Commit & Push
Commit and push your chart change. Flux has an update interval of five minutes by default, so it should take a few minutes for Flux to deploy the change. Check what chart version is installed with helm:
```sh
helm list
```
When the chart version committed matches what you see with `helm list` the deploy has completed.

## Helm useful commands 
You can use some helm commands to validate the chart history and execute a rollback if it is required. Flux will deploy the latest version committed in the repository. 

### Chart history
You can validate the chart's history versions with:  `helm history -n <ns> <helm_release>`

```sh
> helm history -n uat clincard
REVISION        UPDATED                         STATUS          CHART                           APP VERSION     DESCRIPTION                                                                                                                                                  317             Fri Aug 26 18:36:00 2022        superseded      clincard-0.15.4+c12eb6b78bc1    1.0             Upgrade complete                                                                                                                                                     318             Mon Aug 29 03:04:55 2022        superseded      clincard-0.15.5+68b29c773ba9    1.0             Upgrade complete                                                                                                                                                     319             Mon Aug 29 14:21:07 2022        superseded      clincard-0.15.5+44d4a59b4609    1.0             Upgrade complete                                                                                                                                                     320             Mon Aug 29 19:41:41 2022        superseded      clincard-0.15.5+d016896cbcbb    1.0             Upgrade complete                                                                                                                                                     321             Tue Aug 30 02:22:21 2022        superseded      clincard-0.15.5+d016896cbcbb    1.0             Upgrade complete                                                                                                                                                     322             Tue Aug 30 18:44:03 2022        deployed        clincard-0.15.6+933f11318ef5    1.0             Upgrade complete    
```
### Helm rollback

If you required execute a rollback for a previous revision you can use  `helm rollback -n <ns> <helm_release> <revision>`
```sh
> helm rollback -n uat clincard 321
```
## The Flux Console
The Flux Console `fluxctl` can be useful for examining the Flux environment.  More information on the Flux Console can be found [here](https://docs.fluxcd.io/en/1.18.0/references/fluxctl.html).

Read more about flux [here](https://github.com/Greenphire/clincard-config#flux-v2) 
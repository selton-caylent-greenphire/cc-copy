# clincard-config
ClinCard automated deployment config

**Table of Content**
- [clincard-config](#clincard-config)
- [Branching Strategy](#branching-strategy)
- [Project Structure](#project-structure)
  - [Releases](#releases)
  - [Secret management](#secret-management)
    - [Secret Values in a HelmRelease](#secret-values-in-a-helmrelease)
    - [Deleting a secret](#deleting-a-secret)
    - [Working with External Secrets](#working-with-external-secrets)
    - [ParameterStore Structure and Testing In Lower Environments](#parameterstore-structure-and-testing-in-lower-environments)
  - [Helm Commands Work Alongside Flux](#helm-commands-work-alongside-flux)
  - [Troubleshooting Charts and Releases](#troubleshooting-charts-and-releases)
  - [Deleting a release](#deleting-a-release)
    - [Deleting a release](#deleting-a-release-1)
  - [Note on the autotest (cctest namespace on ccsqa) environment](#note-on-the-autotest-cctest-namespace-on-ccsqa-environment)
- [Charts documentation](#charts-documentation)
    - [Documentation considerations.](#documentation-considerations)
    - [pre-commit hooks](#pre-commit-hooks)
- [Flux v2](#flux-v2)
  - [Install the Flux CLI](#install-the-flux-cli)
    - [With Homebrew for macOS and Linux:](#with-homebrew-for-macos-and-linux)
    - [With Bash for macOS and Linux:](#with-bash-for-macos-and-linux)
    - [With Chocolatey for Windows:](#with-chocolatey-for-windows)
  - [Resources](#resources)
    - [GitRepository](#gitrepository)
    - [Kustomization](#kustomization)
    - [HelmRelease](#helmrelease)

---------------------------

# Branching Strategy
Note:
In this paragraph we use "namespace" but these are really specific instances of a running Clincard application

There will be a branch for each EKS namespace controlled by Automated Deployment, the namespaces are grouped under the
"cluster" directory. To make a change to a specific namespace, you must be on the namespace branch and making changes 
to the files located under the "cluster/namespace" directory for that namespace. Sort of like launching nuclear warheads,
a 2 key approach. Changes made outside the branch/environment directory do nothing and will not be reflected in any 
environment. This kept our branches flexible for development teams to work, be able to pull master into Lower Level 
Environment(LLE) branches and allow us to promote code from LLE to production.

Current Mapping:

| BRANCH  | DIRECTORY     | ENVIRONMENT                    |
|---------|---------------|--------------------------------|
| master  | ccprod01/prod | PRODUCTION                     |
| uat     | uat01/uat     | UAT(Pre-Prod environment)      |
| staging | ccsqa/staging | Stage Testing                  |
| teamd   | ccsqa/team-d  | TEAM-D development environment |
| csm     | ccsqa/csm     | CSM(Gainsight integration)     |


# Project Structure
| Directory                                                         | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
|-------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ansible                                                           | Ansible scripts to control cluster configuration, make changes to EKS clusters. See the [readme](ansible/deploy_scripts/README.md)                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| `<environment>`<br/>Ex:<br/>* ccprod01<br/>* ccuat01<br/>* ccsqa  | Flux deploy for a specific cluster and its namespaces. In this directory are subdirectories for each namespace in the cluster, these subdirectories must match values in the ansible deploy_scripts `flux-<cluster_name>.yml`. This controls the deployment(changes), IE: what microservices are enabled, clincard/microservice image version, Developers should be free to change lower level environments here while changes to the uat/master branch must go through proper GITHUB PR review.                                                                       |
| charts                                                            | Helm charts needed for CC deployment. The template files that are equivalent to the old Kubernetes manifests can be found here. Nothing here should be changed unless it's to add template values. To make a change to a specific release, use the `<clustername>/<namespace>/releases` HelmRelease manifests used by Flux. If you find an item in the templates (manifests in the old lingo) that should be changeable, contact mark.mcguigon@greenphire.com to have the change made if you are unsure what to do. It will then be changeable for the flux deployment |
| legacy                                                            | Legacy Kubernetes manifests that are needed to do something outside of Helm/Flux.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| scripts                                                           | Scripts that perform various maintinence functions to Clincard on kubernetes, but are not part of the application itself.                                                                                                                                                                                                                                                                                                                                                                                                                                              |
## Releases
Flux manages releases via the HelmRelease manifest. These are found in the `<clustername>/<namespace>/releases`. 
Use the `values:` section of this manifest to override values found in the `values.yaml` file in the Helm chart. 
Look at individual charts `values.yaml` file to see which values can be overridden. 
Note that the clincard chart has been subcharted, where the main Clincard services are part of the main chart, but the microservices are subcharts of the main chart. 
There are two things to be aware of here:
  * The first is that `global:` values override those values in every subchart.
  * Second, to override values in a subchart, you should use that subchart's section in the main chart. 
    * For example:
```yaml
    paymentindex:
      enabled: true
      secretpath: preprod
      image: 160116585046.dkr.ecr.us-west-2.amazonaws.com/paymentindex-consumer:1.0.7
```
Here the microservice is enabled, the path variable for externalSecrets in ParameterStore and the subchart's image value is overridden by the HelmRelease.


## Secret management
Secret management is done by the [External Secrets Manager](https://medium.com/aeris-things/kubernetes-external-secrets-join-the-disjoints-5dab8910d2c8). Secrets should be deployed in AWS Parameter Store, and made into Kubernetes secrets via the External Secrets Manager. These ExternalSecrets can be put into the charts and treated as regular Kubernetes secrets, since they are "converted" into regular kubernetes secrets. Secrets that are not part of any chart can be put into the environment's `secrets` directory, alongside the `release` directory.

### Secret Values in a HelmRelease
If a secret is required in a part of the values' section of the HelmRelease, those secrets should be put into the Parameter Store and retreived via the `valuesFrom:` method in the HelmRelease. The `valuesFrom:` section containing the secret will get merged with the `values:` section by Flux.

Contains any secrets needed to deploy ahead of the Clincard application. Generally these are secrets for:  
 * Redis
 * RabbitMQ
 * CouchDB

Other secrets specific to Clincard Services are located in the charts/clincard/subcharts which are configurable
in the releases/clincard.yaml file. 

NOTE: There are some ExternalSecrets which depend on values in the "clincard.yaml" HelmRelease file or the subchart values file(default values).
For example the username a service uses to connect to postgres. This is a value you can override in the HelmRelease file
or use the default in the subchart's values file. Whichever you use for the environment, you must have an ExternalSecret 
called "postgres-{{username}}" and the value of this in ParameterStore is the password.


### Deleting a secret
```sh
kubectl delete externalsecret/<secretname> -n <namespace>
```

### Working with External Secrets
The External Secrets' plugin runs a pod in the external-secrets namespace that maintains synchronization between Amazon Parameter Store and Kubernetes Secrets. You can read more about the plugin [here](https://www.godaddy.com/engineering/2019/04/16/kubernetes-external-secrets/). Flux does not manage the movement of secrets from ssm (Parameter Store) to Kubernetes secrets, but it does manage the deployment of External Secrets. The External Secrets plugin uses the Custom Resource Definition `ExternalSecret` to define external secrets. You can see the status of all the external secrets by using the command:
```sh
kubectl get externalsecrets -n <namespace>
```
The output will look something like:
```sh
auth-secret         7s          SUCCESS   64d
clincard-secrets    6s          SUCCESS   64d
couchdb-secret      8s          SUCCESS   64d
nginx-cert          2s          SUCCESS   62d
paymentindex        7s          SUCCESS   64d
postgres-secret     6s          SUCCESS   64d
rabbit-secret       3s          SUCCESS   64d
redis               4s          SUCCESS   64d
rideshare-svc       6s          SUCCESS   64d
sandbox-secret      0s          SUCCESS   63d
tinvalidation       7s          SUCCESS   64d
websockets-secret   0s          SUCCESS   64d
```
Again, like with `HelmRelease` you can take a closer look at issues by describing the external secret:
```sh
kubectl describe externalsecret/<secretname>
```
Check the `Status:` and `Events:` to see errors.

### ParameterStore Structure and Testing In Lower Environments
Since all credentials are stored in ParameterStore using ExternalSecretes, we can change the "path" in ExternalSecret
to point to a production value. We can control which AWS clusters can connect to which "paths" in ParameterStore to 
reduce the risk of using the wrong parameter in the wrong environment.

Structure:
  * /clincard/common/nginx-cert
  * /clincard/lower/rabbit_user
  * /clincard/preprod/rabbit_user
  * /clincard/prod/rabbit_user

Expected AWS Access Control List:
  * SQA EKS CLUSTER
    * /clincard/common/nginx-cert
    * /clincard/lower/rabbit_user
    * /clincard/prod/{ENV VARIABLE}(see 'Note' below)
  * UAT EKS CLUSTER
    * /clincard/common/nginx-cert
    * /clincard/preprod/rabbit_user
  * PROD EKS CLUSTER
    * /clincard/common/nginx-cert
    * /clincard/prod/rabbit_user

Note:  
We can control permissions at a single ParameterStore entry, this allows us to use a few common Production values in 
lower level environments. These are listed below:
  * JIRA_API_TOKEN
  * JIRA_GREENPHIRE_SYSTEM_USER
  * GOOGLE_MAPS_API_KEY
  * GOOGLE_API_JS_KEY
  * GOOGLE_RECAPTCHA_SECRET_KEY
  * GOOGLE_RECAPTCHA_SITE_KEY

If you come across an Environment Variable not in the above list, submit a HELP ticket with details.

## Helm Commands Work Alongside Flux
Deployed Helm Charts don't behave any differently just because they were deployed via flux. The following commands are useful in troubleshooting:
```helm list -n <namespace>```
This will list all the charts installed in the namespace, and the status of the charts.
```helm delete <releasename> -n <namespace>```
Will remove a chart. Note that Flux will redeploy it if it's being managed by a `HelmRelease` (see below). Generally Flux should be permitted to do its job, but sometimes helm commands can be useful in seeing issues a layer below.
## Troubleshooting Charts and Releases
Flux deploys Helm charts using a Custom Resource Definition called `HelmRelease`. Sometimes a chart may not upgrade correctly because of an error in the chart. You can see the status of a chart by using `kubectl get helmreleases -n <namespace>` The output will look something like this:
```sh
NAME         RELEASE      PHASE       STATUS     MESSAGE                                                              AGE
clincard     clincard     Failed      failed     Release failed for Helm release 'clincard' in 'staging'.             9d
couchdb-ha   couchdb-ha   Succeeded   deployed   Release was successful for Helm release 'couchdb-ha' in 'staging'.   9d
memcached    memcached    Succeeded   deployed   Release was successful for Helm release 'memcached' in 'staging'.    9d
rabbit       rabbit       Succeeded   deployed   Release was successful for Helm release 'rabbit' in 'staging'.       9d
redis        redis        Succeeded   deployed   Release was successful for Helm release 'redis' in 'staging'.        9d
```
Here we can see the clincard chart is in a failed state. Because the upgrade failed, it will not redeploy any pods. Any changes will not be deployed until this error is cleared. To get a better idea of what specifically is failing, use `kubectl describe helmrelease/clincard -n <namespace>`. The output will look like this:
```sh
Events:
  Type     Reason             Age                  From           Message
  ----     ------             ----                 ----           -------
  Warning  FailedReleaseSync  35m (x16 over 79m)   helm-operator  synchronization of release 'clincard' in namespace 'staging' failed: dry-run upgrade failed: dry-run upgrade for comparison failed: template: clincard/templates/service.yaml:42:32: executing "clincard/templates/service.yaml" at <{{template "service.fullname" .}}>: template "service.fullname" not defined
  Warning  FailedReleaseSync  34m (x17 over 82m)   helm-operator  synchronization of release 'clincard' in namespace 'staging' failed: dry-run upgrade failed: dry-run upgrade for comparison failed: template: clincard/templates/service.yaml:42:32: executing "clincard/templates/service.yaml" at <{{template "service.fullname" .}}>: template "service.fullname" not defined
  Warning  FailedReleaseSync  33m (x17 over 81m)   helm-operator  synchronization of release 'clincard' in namespace 'staging' failed: dry-run upgrade failed: dry-run upgrade for comparison failed: template: clincard/templates/service.yaml:42:32: executing "clincard/templates/service.yaml" at <{{template "service.fullname" .}}>: template "service.fullname" not defined
  Warning  FailedReleaseSync  20m (x5 over 32m)    helm-operator  synchronization of release 'clincard' in namespace 'staging' failed: dry-run upgrade failed: dry-run upgrade for comparison failed: template: clincard/templates/clincard-secrets.yaml:5:20: executing "clincard/templates/clincard-secrets.yaml" at <{{template "service.fullname" .}}>: template "service.fullname" not defined
  Warning  FailedReleaseSync  19m (x6 over 32m)    helm-operator  synchronization of release 'clincard' in namespace 'staging' failed: dry-run upgrade failed: dry-run upgrade for comparison failed: template: clincard/templates/clincard-secrets.yaml:5:20: executing "clincard/templates/clincard-secrets.yaml" at <{{template "service.fullname" .}}>: template "service.fullname" not defined
  Warning  FailedReleaseSync  15m (x7 over 32m)    helm-operator  synchronization of release 'clincard' in namespace 'staging' failed: dry-run upgrade failed: dry-run upgrade for comparison failed: template: clincard/templates/clincard-secrets.yaml:5:20: executing "clincard/templates/clincard-secrets.yaml" at <{{template "service.fullname" .}}>: template "service.fullname" not defined
  Warning  FailedReleaseSync  14m                  helm-operator  synchronization of release 'clincard' in namespace 'staging' failed: upgrade failed: cannot patch "clincard-consumer" with kind Deployment: Deployment.apps "clincard-consumer" is invalid: spec.selector: Invalid value: v1.LabelSelector{MatchLabels:map[string]string{"app":"clincard", "component":"clincard", "release":"clincard", "tier":"reports"}, MatchExpressions:[]v1.LabelSelectorRequirement(nil)}: field is immutable && cannot patch "clincard" with kind Deployment: Deployment.apps "clincard" is invalid: spec.selector: Invalid value: v1.LabelSelector{MatchLabels:map[string]string{"app":"clincard", "component":"clincard", "release":"clincard", "tier":"reports"}, MatchExpressions:[]v1.LabelSelectorRequirement(nil)}: field is immutable
  Warning  FailedReleaseSync  5m18s (x4 over 14m)  helm-operator  synchronization of release 'clincard' in namespace 'staging' failed: failed to determine sync action for release: status 'failed' of release does not allow a safe upgrade
  Warning  FailedReleaseSync  4m41s (x5 over 13m)  helm-operator  synchronization of release 'clincard' in namespace 'staging' failed: failed to determine sync action for release: status 'failed' of release does not allow a safe upgrade
  Warning  FailedReleaseSync  28s (x6 over 12m)    helm-operator  synchronization of release 'clincard' in namespace 'staging' failed: failed to determine sync action for release: status 'failed' of release does not allow a safe upgrade
  ```
  There's a history of errors here with the chart. The first was it did not have a template defined:
  ```sh
  Warning  FailedReleaseSync  34m (x17 over 82m)   helm-operator  synchronization of release 'clincard' in namespace 'staging' failed: dry-run upgrade failed: dry-run upgrade for comparison failed: template: clincard/templates/service.yaml:42:32: executing "clincard/templates/service.yaml" at <{{template "service.fullname" .}}>: template "service.fullname" not defined
  ```
  When that was fixed, it then displayed an error about not being able to safely upgrade:
  ```sh
  Warning  FailedReleaseSync  28s (x6 over 12m)    helm-operator  synchronization of release 'clincard' in namespace 'staging' failed: failed to determine sync action for release: status 'failed' of release does not allow a safe upgrade
  ```
  It is possible to make changes to a chart where Helm is unable to perform an upgrade. If you see this error, it means you will need to do a `helm delete <release name>` and allow Flux to redeploy it. Usually this is fine to do.
## Deleting a release
If a release is deleted from Git, Flux will not remove the release. This is because we don't enable flux to delete charts it does not control. Because Flux has to co-exist on clusters with charts it has not deployed, we turn this off. So to delete a HelmRelease or ExternalSecret, after removing it from Git, you also need to remove it from Kubernetes.

### Deleting a release
```sh
kubectl delete helmrelease/<releasename> -n <namespace>
```
After this, Flux should no longer deploy the secret or release.

## Note on the autotest (cctest namespace on ccsqa) environment
The autotest environment was based on an earlier release of the charts that did not use subcharting. So it should not be used as an example of how later environments work.

# Charts documentation
Once your chart is ready, you could generate the corresponding documentation using [helm-docs](https://github.com/norwoodj/helm-docs).

```sh
# into the chart folder execute the following command
> helm-docs -s file
```
> You can configure a pre-commit hook to automate document creation. [pre-commit hooks](#pre-commit-hooks)
### Documentation considerations.
1. Set chart description,maintainers and keywords in the `Chart.yaml` file. 
   ```yaml
   apiVersion: v2
   name: service
   description: A Helm chart to define <service> for clincard
   type: application
   version: 0.1.0
   appVersion: "1.16.0"
   maintainers:
   - name: Developer Name
     email: developer@greenphire.com
   keywords:
   - <service>
   - <relations>
   - <dependencies>
   ```
2. Use the following comments structure in the `values.yaml` file to see them in the generated README.md
   ```yaml
   serviceAccount:
     # -- Flag to enable or diable the serviceAccount creation
     create: false 
     name: "" 
   ```
> read more about [helm-docs](https://github.com/norwoodj/helm-docs).

### pre-commit hooks

If you want to use the pre-commit hook, you need to install the following tools on your machine:
   - [pre-commit](https://pre-commit.com/#install).
   - [helm-docs](https://github.com/norwoodj/helm-docs).


Check the `.pre-commit-config.yaml` file exist in the root path for this repository. 

Once you have all the necessary tools in your environment, you must install the pre-commit with the following commands.

```sh
# clincard-config/
pre-commit install
pre-commit install-hooks
```
> After this, the hook will always be executed when you run a `git commit` command. 

(optional) If you wan to run it manually execute the following command.

```sh
# clincard-config/
pre-commit run --all-files
``` 



# Flux v2
Flux is looking at clincard-Config repository, meant to be the Single Source of Truth, to deploy the clincard application. In this section it will be show some useful commands around it.

## Install the Flux CLI
The Flux CLI is available as a binary executable for all major platforms, the binaries can be downloaded from GitHub [releases page](https://github.com/fluxcd/flux2/releases).

### With Homebrew for macOS and Linux:
> brew install fluxcd/tap/flux
### With Bash for macOS and Linux:
> curl -s https://fluxcd.io/install.sh | sudo bash
### With Chocolatey for Windows:
> choco install flux

## Resources

### GitRepository

The GitRepository API defines a *Source* to produce an Artifact for a Git repository revision. This is where the Kustomization and HelmRelease will look at in order to run. *ITSG manage this resource,* Inside the cluster we have more than one GitRepository, *flux-system* is looking at ITSG, no need to worry about it. Each clincard environment will have their own GitRepository.

Usefull commands:
* Check if flux is looking at the latest git commit. We can see if the *Revision* column matches what is in the Github Repository page.
  ```bash
  $ flux get source git
  NAME        	REVISION      	SUSPENDED	READY	MESSAGE
  clincard-uat	uat/a17b7f0   	False    	True 	stored artifact for revision 'uat/a17b7f00ca02f8458e2ae2925fbf783c19be5854'
  flux-system 	master/250eee6	False    	True 	stored artifact for revision 'master/250eee684da57e82249a6cae112d671fdf9e7068'
  ```
* Flux takes 5 minutes (by default) to reconciliate with Git, but we can force that.
  ```bash
  $ flux reconcile source git clincard-uat
  ► annotating GitRepository clincard-uat in flux-system namespace
  ✔ GitRepository annotated
  ◎ waiting for GitRepository reconciliation
  ✔ fetched revision uat/a17b7f00ca02f8458e2ae2925fbf783c19be5854

  ```
* Kubectl command to get gitrepositories:
  ```bash
  $ kubectl get gitrepositories.source.toolkit.fluxcd.io -A
  NAMESPACE     NAME           URL                                               AGE   READY   STATUS
  flux-system   clincard-uat   ssh://git@github.com/Greenphire/clincard-config   30d   True    stored artifact for revision 'uat/a17b7f00ca02f8458e2ae2925fbf783c19be5854'
  flux-system   flux-system    ssh://git@github.com/Greenphire/itsg              34d   True    stored artifact for revision 'master/250eee684da57e82249a6cae112d671fdf9e7068'
  ```

### Kustomization
The Kustomization API defines a pipeline for fetching, decrypting, building, validating and applying Kustomize overlays or plain Kubernetes manifests. *ITSG manage this resource,* for each environment we'll have at least 2, one for releases and one for additional secrets. This resource is the core of the environment, Clincard HelmRelease is deployed by it.

Useful commands:

* Check if flux applied the kustomization with the Latest GitRepository Source.
    ```bash
    $ flux get kustomization -n uat
    NAME        	REVISION   	SUSPENDED	READY	MESSAGE
    uat-releases	uat/a17b7f0	False    	True 	Applied revision: uat/a17b7f0
    uat-secrets 	uat/a17b7f0	False    	True 	Applied revision: uat/a17b7f0
    ```

* Force flux to reconciliate the kustomization with the latest Git Source.
    ```bash
    $ flux reconcile kustomization -n uat uat-releases
    ► annotating Kustomization uat-releases in uat namespace
    ✔ Kustomization annotated
    ◎ waiting for Kustomization reconciliation
    ✔ applied revision uat/a17b7f00ca02f8458e2ae2925fbf783c19be5854
    ```

* Kubectl command to get all Kustomizations
    ```bash
    $ kubectl get kustomizations.kustomize.toolkit.fluxcd.io
    NAME           AGE   READY   STATUS
    uat-releases   30d   True    Applied revision: uat/a17b7f00ca02f8458e2ae2925fbf783c19be5854
    uat-secrets    30d   True    Applied revision: uat/a17b7f00ca02f8458e2ae2925fbf783c19be5854
    ```

### HelmRelease
Unlike the other two resources, this one is managed by clincard-config repo, we can look at the files under ccuat01/uat/releases, ccprod01/prod/releases/ folders in the root of the project,for example, to check and change the configuration.

* Check if HelmRelease is looking at the latest Chart version
    ```bash
    $ flux get hr -n uat
    NAME      	REVISION	SUSPENDED	READY	MESSAGE
    clincard  	0.9.19  	False    	True 	Release reconciliation succeeded
    couchdb-ha	1.4.5   	False    	True 	Release reconciliation succeeded
    ```

* Reconcile HelmRelease to fech the latest release
    ```bash
    $ flux reconcile hr -n uat clincard
    ► annotating HelmRelease clincard in uat namespace
    ✔ HelmRelease annotated
    ◎ waiting for HelmRelease reconciliation
    ✔ applied revision 0.9.19
    ```

* Kubectl command to get all HelmReleases
    ```bash
    $ flux reconcile hr -n uat clincard
    ► annotating HelmRelease clincard in uat namespace
    ✔ HelmRelease annotated
    ◎ waiting for HelmRelease reconciliation
    ✔ applied revision 0.9.19
    ```
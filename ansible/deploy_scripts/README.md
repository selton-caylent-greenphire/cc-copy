# Ansible deployment scripts

In this directory there are subdirectories for each environment controlled by Infra As Code(IAC).
Each subdirectory contains 2 files, a flux-`<environment>`.sh and flux-`<environment>`.yml. These files control what 
will deploy to the cluster. 


## Process
These files must be run on an INFRA controlled deployment server, on the `master` branch. 
This is a manual, controlled process and usually done by someone from the Infrastructure team. Generally required 
for new environment deployment or changes to an existing namespace.

Coordinate changes to these files with:
  * infrastructure:
    * derek.vandenbosch@greenphire.com
    * mike.seigafuse@greenphire.com
  * clincard
    * mark.mcguigon@greenphire.com 
    * ryan.shenck@greenphire.com
    * helene.mcelroy@greenphire.com

Documentation:
The ansible script above uses the following packages:
  * [community.aws](https://docs.ansible.com/ansible/latest/collections/community/aws/index.html)
  * [community.kubernetes](https://docs.ansible.com/ansible/latest/collections/community/kubernetes/k8s_module.html)

See the above links information in regard to the tags in "community.kubernetes.k8s"

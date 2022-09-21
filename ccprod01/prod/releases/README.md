## Production Releases

In this directory place all required deployment files required for Clincard. Generally this directory contains:  
* clincard.yaml
* couchdb.yaml
* memcached.yaml
* rabbitmq.yaml
* redis.yaml


The clincard.yaml file controls:
 * which Clincard Services are enabled for automated deployments
 * what images to use for Clincard Services
 * external secret path overrides
   * You can config individual services to look at Lower Level or Production ParameterStore values.
 * Global values like URL DNS names

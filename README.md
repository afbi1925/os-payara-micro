Payara micro for Openshift. Permissions are setup so that it will run with an arbitrary user, 
as required by most Openshift installations. 

Also includes some convenience to setup certificates and set java runtime properties, 
as well as some sane basic parameters, so that memory consumption stays appropriate
even if running on huge nodes sometimes found in Openshift infrastructures. 


# Supported tags and respective `Dockerfile` links

-	[`latest`](https://github.com/nextstepman/os-payara-micro/blob/master/Dockerfile): contains latest released version of Payara Micro
-	[`5-181`](https://github.com/nextstepman/os-payara-micro/blob/5.181/Dockerfile): contains 5.181 build of Payara Micro

# Usage

## Quick start

The intended use of this image is to have your own Dockerfile and deploy a single war file with an microservice. 
Example:

```
FROM nextstepman/os-payara-micro:5.181
COPY target/vin-decoder.war deployments
```

Otherwise, you can also start the docker container and run Payara Micro manually for testing:

```
docker run -p 8080:8080 docker run nextstepman/os-payara-micro:5.181
```

To start payara and with the default settings and deploy a war file "vin-decoder.war" from the local target folder, which is mounted:

```
docker run -it --rm -v `pwd`/target:/opt/payara/target -p 8080:8080 -p 8181:8181 --env DEPLOY=target/vin-decoder.war nextstepman/os-payara-micro:5.181
```

## Open ports

The following ports are opened by default:

 - 8080 - HTTP listener
 - 8181 - HTTPS listener

## Default Settings

### Permissions

Payara runs in folder `/opt/payara` which is owned by user `payara:root` and has mode 0775, 
so that the default user in Openshift will be able to write to that directory.
 
### Java Runtime Settings

The image uses 3 environment variables to set default java runtime parameters:

* `JAVA_BASE_OPTIONS`: sets basic java memory settings but not the specific heap. See Dockerfile for the full list
* `JAVA_MEMORY_OPTIONS`: sets heap, metaspace and stack size with a default of 512 MB heap. Override that for your specific settings.  
* `JAVA_OPTIONS`: set additional java settings, such as -agentpath etc. It is empty by default.

These will be applied in the run_payara.sh shell script which is set as entrypoint. See that file for details

### Files

For convenience, the image copies the default files cacerts.jks, keystore.jks inluded in the payara micro jar to the default folder `/opt/payara`.

The `JAVA_BASE_OPTIONS` contains options to use the stated trust- and keystore. Also, the standard configured `CMD` is set to use the given startup files. 
So you can simply add certificates as required to the given trust- and keystores or overwrite the given command files 

Also the empty post-boot-commands.txt, post-deploy-commands.txt and pre-boot-commands.txt are copied to the default folder `/opt/payara`.

So you can simply overwrite these files as part of your Dockerfile to have specific asadmin commands applied at startup, e.g. to define your jdbc datasources.

### Deployment

The entrypoint `run_payara.sh` inspects the variables `DEPLOY` and `DEPLOYDIR` and adds `--deploy` or `--deploydir` arguments. Use `DEPLOY` to either deploy a single war file or
exploded war directory, or `DEPLOYDIR` (default is /opt/payara/deployments) to deploy all applications within a directory.

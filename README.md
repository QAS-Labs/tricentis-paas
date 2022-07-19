# K8s cluster in a box!

This is a quickstart to deploy Tricentis qTest on kind multi-node cluster.

## Prerequisites

* PostgreSQL
* Docker
* kubectl 
* Helm
* Kind

## Clone this repo
<code>git clone git@github.com:QAS-Labs/qtest-paas</code>

## qTest Manager parameters to change in mgr-values-kind.yaml or mgr-values-aws-eks-op.yaml


| Parameter                   | Description                                          | Default |
| --------------------------- | ---------------------------------------------------- | ------- |
| `client.jdbc.postgres.url` | PSQL database URL | `jdbc:postgresql://host.docker.internal/qtest` |
| `client.jdbc.postgres.username` | PSQL username | `postgres` |
| `client.jdbc.postgres.password` | PSQL password | `cG9zdGdyZXM=` (`postgres`, base64-encoded) |
| `client.jdbc.postgres.readonly.url` | PSQL readonly database URL | `jdbc:postgresql://host.docker.internal/qtest` |
| `client.jdbc.postgres.readonly.username` | PSQL username | `postgres` |
| `client.jdbc.postgres.readonly.password` | PSQL password | `cG9zdGdyZXM=` (`postgres`, base64-encoded) |
| `client.jdbc.sslEnable` | Enable ssl connections | `false` |
| `client.jdbc.sslMountPath` | Postgresql ssl certificate mount directory  | `\etc\ssl` |
| `client.jdbc.sslPath` | Postgresql ssl connection string | `?ssl=true&sslmode=verify-full&sslrootcert=/etc/ssl/root.crt` (please chnage only cert path) |
| `client.jdbc.cert` | Postgresql client certificate | `` (postgres client certificate, base64-encoded) |
| `mail.host` | SMTP host name | `smtp.local` |
| `mail.port` | SMTP port number | `465` |
| `mail.username` | SMTP username | `qtest` |
| `mail.password` | SMTP password | `cG9zdGdyZXM=` (`postgres`, base64-encoded) |
| `mail.supportEmailAddress` | qTest Support email address | `supports@tricentis.com` |
| `elasticSearch.host` | Elasticsearch host | `host.docker.internal` |
| `elasticSearch.port` | Elasticsearch port | `9200` |
| `elasticSearch.scheme` | Elasticsearch port | `http` |
| `blobstorage.type` | qTest Manager attachements folder type | `disk_storage` (Accepted values disk_storage, amazon_s3_access_key) |
| `blobstorage.region` | S3 bucket region | `us-east-1` (Needed when blobstorage.type is amazon_s3_access_key) |
| `blobstorage.sharedBucket` | S3 bucket name | `qtest` (Needed when blobstorage.type is amazon_s3_access_key) |
| `s3.accessKey` | Access key of S3 bucket | `` |
| `s3.secretKey` | Secret key of S3 bucket | `` |
| `s3.folder` | Access key of S3 bucket | `qtest/manager` |
| `s3.scanUrl` | Access key of S3 bucket | `https://clamav-13.qtest.local` |
| `notification.urlExternal` | Notification URL | `https://nephele.qtest.local` |
| `preUrl` | qTest Manager URL | `http://<sitename>.qtest.local` |
| `preUrlHttps` | qTest Manager URL | `https://<sitename>.qtest.local` |
| `attachment.folder.path` | qTest attachement folder path | `/mnt/data/qtest/attachments` |
| `license.folder.path` | qTest Manager license folder path | `/mnt/data/qtest/license` |
| `qtest.request.nonce.disabled` | qTest request nonce disabled | `true` |
| `qtest.request.nonce.mode` | qTest request nonce mode | `HighPrecision` |
| `security.csrf.source.trust.pattern` | qTest Manager csrf security pattern | `` |
| `cors.allowed.all` | cors allowed | `true` |
| `cors.allowed.domains` | cors allowed domains | `` |
| `vera.auto.testrun.beta.clients` | SMTP port number | `-1` |
| `persistence.existingClaim` | Existing PersistentVolumeClaim | "" |
| `persistence.storageClass` | Existing StorageClass | "" |
| `persistence.accessMode` | Storage Access Mode | `ReadWriteOnce` |
| `persistence.size` | Storage size | `10Gi` |
| `persistence.s3.region` | S3 region | "" |
| `persistence.s3.bucketName` | S3 bucket name | "" |
| `persistence.s3.folder` | S3 folder | "" |
| `service.port` | Port on service for other pods to talk to | `8080` |
| `service.targetPort` | Port on container to serve traffic | `8080` |
| `ingress.enabled` | Is Ingress enabled? | `false` |
| `ingress.class` | Name of IngressClass | `nginx` |
| `ingress.host` | qTest Manager hostname | `mgr.qtest.local` |
| `ingress.tls.hosts` | Configuration for TLS on the Ingress | `mgr.qtest.local` |

## Parameters app configurations to change in parameters-values-kind.yaml


 Parameter                   | Description                                          | Default |
| --------------------------- | ---------------------------------------------------- | ------- |
| `qTestParametersDBName` | PSQL database name of the parameters app | `parameters` |
| `qTestParametersDBUserName` | PSQL username | `postgres` |
| `qTestParametersDBHostName` | PSQL database host name | `host.docker.internal` |
| `qTestParametersDBSSLEnable` | Enable ssl connections | `false` |
| `qTestParametersDBSSLMountPath` | Postgresql ssl certificate mount directory | `\etc\ssl` |
| `qTestParametersDBSSL` | SSL Connection which appends for SSL Connection (only change cert name) | `?ssl=true&sslmode=verify-full&sslrootcert=/etc/ssl/root.crt` |
| `qTestParametersDBRootCRT` | Postgresql client certificate | `` (postgres client certificate, base64-encoded) |
| `serverAppSSLRequired` | Runs pod of Parameters app on SSL | `false` |

## Launch app configurations to change in launch-values-kind.yaml


 Parameter                   | Description                                          | Default |
| --------------------------- | ---------------------------------------------------- | ------- |
| `qTestLaunchDBName` | PSQL database name of the qTest Manager | `qtest` |
| `qTestLaunchDBUserName` | PSQL username | `postgres` |
| `qTestLaunchDBHostName` | PSQL database host name | `host.docker.internal` |
| `qTestLaunchRootURL` | qTest Launch url | `https://launch.qtest.local` |
| `qTestLaunchDBSSLEnable` | Enable ssl connections | `false` |
| `qTestLaunchDBSSLMountPath` | Postgresql ssl certificate mount directory | `\etc\ssl` |
| `qTestLaunchDBSSL` | SSL Connection which appends for SSL Connection (only change cert name) | `?ssl=true&sslmode=verify-full&sslrootcert=/etc/ssl/root.crt` |
| `qTestLaunchDBRootCRT` | Postgresql client certificate | `` (postgres client certificate, base64-encoded) |

## Pulse app configurations to change in pulse-values-kind.yaml


 Parameter                   | Description                                          | Default |
| --------------------------- | ---------------------------------------------------- | ------- |
| `qTestPulseDBName` | PSQL database name of the pulse | `pulse` |
| `qTestPulseDBUserName` | PSQL username | `postgres` |
| `qTestPulseDBHostName` | PSQL database host name | `host.docker.internal` |
| `qTestPulseRootURL` | qTest Pulse url | `https://pulse.qtest.local` |
| `qTestPulseScenarioURL` | qTest Launch url | `https://scenario.qtest.local` |
| `qTestPulseDBSSLEnable` | Enable ssl connections | `false` |
| `qTestPulseDBSSLMountPath` | Postgresql ssl certificate mount directory | `\etc\ssl` |
| `qTestPulseDBSSL` | SSL Connection which appends for SSL Connection (only change cert name) | `?ssl=true&sslmode=verify-full&sslrootcert=/etc/ssl/root.crt` |
| `qTestPulseDBRootCRT` | Postgresql client certificate | `` (postgres client certificate, base64-encoded) |

## Scenario app configurations to change in scenario-values-kind.yaml


 Parameter                   | Description                                          | Default |
| --------------------------- | ---------------------------------------------------- | ------- |
| `qTestScenarioDBName` | PSQL database name of the scenario | `scenario` |
| `qTestScenarioDBUserName` | PSQL username | `postgres` |
| `qTestScenarioDBHostName` | PSQL database host name | `host.docker.internal` |
| `qTestScenarioLocalBaseURL` | qTest Pulse url | `https://scenario.qtest.local` |
| `qTestScenarioQTestURL` | qTest Launch url | `https://nephele.qtest.local` |
| `qTestScenarioDBSSLEnable` | Enable ssl connections | `false` |
| `qTestScenarioDBSSLMountPath` | Postgresql ssl certificate mount directory | `\etc\ssl` |
| `qTestScenarioDBSSL` | SSL Connection which appends for SSL Connection (only change cert name) | `?ssl=true&sslmode=verify-full&sslrootcert=/etc/ssl/root.crt` |
| `qTestScenarioDBRootCRT` | Postgresql client certificate | `` (postgres client certificate, base64-encoded) |

## Session app configurations to change in sessions-values-kind.yaml


 Parameter                   | Description                                          | Default |
| --------------------------- | ---------------------------------------------------- | ------- |
| `qTestSessionDBName` | PSQL database name of the session | `sessions` |
| `qTestSessionDBUserName` | PSQL username | `postgres` |
| `qTestSessionDBHostName` | PSQL database host name | `host.docker.internal` |
| `qTestStorageBucketName` | Amazon S3 bucket name | `aws-session-bucket-name` |
| `qTestSessionClamavURL` | qTest clama url | `https://clam.qtest.local` |
| `qTestSessionStorageType` | Session storage type | `amazon_s3 | disk_storage` |
| `qTestSessionDBSSLEnable` | Enable ssl connections | `false` |
| `qTestSessionDBSSLMountPath` | Postgresql ssl certificate mount directory | `\etc\ssl` |
| `qTestSessionDBSSL` | SSL Connection which appends for SSL Connection (only change cert name) | `?ssl=true&sslmode=verify-full&sslrootcert=/etc/ssl/root.crt` |
| `qTestSessionDBRootCRT` | Postgresql client certificate | `` (postgres client certificate, base64-encoded) |

## Insights app configurations to change in insights-values-kind.yaml


 Parameter                   | Description                                          | Default |
| --------------------------- | ---------------------------------------------------- | ------- |
| `qTestInsightsDBName` | PSQL database name of the qTest manager | `qTest` |
| `qTestInsightsDBUser` | PSQL username | `postgres` |
| `qTestInsightsDBHost` | PSQL database host name | `host.docker.internal` |
| `qTestInsightsWriteQTestDBName` | PSQL database name of the qTest manager | `qTest` |
| `qTestInsightsWriteQTestDBUser` | PSQL username | `postgres` |
| `qTestInsightsWriteQTestDBPassword` | PSQL password | `cG9zdGdyZXM=` (`postgres`, base64-encoded) |
| `qTestInsightsWriteQTestDBHost` | PSQL database host name | `host.docker.internal` |
| `qTestInsightsSessionDBName` | PSQL database name of the session | `sessions` |
| `qTestInsightsSessionDBUser` | PSQL username | `postgres` |
| `qTestInsightsSessionDBPassword` | PSQL password | `cG9zdGdyZXM=` (`postgres`, base64-encoded) |
| `qTestInsightsSessionDBHost` | PSQL database host name | `host.docker.internal` |
| `serverAppSSLRequired` | Runs pod of Insights app on SSL | `false` |

## Insights etl app configurations to change in insights-etl-values-kind.yaml


 Parameter                   | Description                                          | Default |
| --------------------------- | ---------------------------------------------------- | ------- |
| `qTestInsightsEtlDBName` | PSQL database name of the qTest manager | `qTest` |
| `qTestInsightsEtlDBUser` | PSQL username | `postgres` |
| `qTestInsightsEtlDBHost` | PSQL database host name | `host.docker.internal` |
| `qTestInsightsEtlWriteQTestDBName` | PSQL database name of the qTest manager | `qTest` |
| `qTestInsightsEtlWriteQTestDBUser` | PSQL username | `postgres` |
| `qTestInsightsEtlWriteQTestDBHost` | PSQL database host name | `host.docker.internal` |
| `qTestInsightsEtlSessionDBName` | PSQL database name of the session | `sessions` |
| `qTestInsightsEtlSessionDBUser` | PSQL username | `postgres` |
| `qTestInsightsEtlSessionDBHost` | PSQL database host name | `host.docker.internal` |

## Test configurations app parameters to change in testconfig-values-kind.yaml


Parameter                   | Description                                          | Default |
| --------------------------- | ---------------------------------------------------- | ------- |
| `qTestTestConfigDBName` | PSQL database name of the qTest manager | `qTest` |
| `qTestTestConfigDBUser` | PSQL username | `postgres` |
| `qTestTestConfigDBHost` | PSQL database host name | `host.docker.internal` |

* Once the server is up and running, copy the server id from the Administrator -> license
* Reach out the tricentis team and provide the server id for license file
* copy the license to `license.folder.path` directory to kind nodes
    - docker cp license.lic kind-worker:/`license.folder.path`
    - docker cp license.lic kind-worker2:/`license.folder.path`
* Login to kind worker and create directory /mnt/data/qtest/attachments and /mnt/data/qtest/license
* Move the license from /mnt directory to /mnt/data/qtest/license

## Set up cluster
If you already have a kind cluster skip the section
<code>./kindup.sh</code>

## Installation
Add the qTest Helm repo:
```bash
helm repo add qtest https://GITHUB_TOKEN@raw.githubusercontent.com/QAS-Labs/qtest-chart/gh-pages
helm repo update
```
Install the qTest Manager chart with the release name `qtest-manager` in `qtest` namespace:
```bash
helm install qtest-manager -f mgr-values-kind.yaml -n qtest --create-namespace
```
Note that qTest Manager chart should be the __first__ chart to be installed.
All other qTest charts may be installed subsequently in the similar manner.  For example, to install qTest Parameters with the release name `qtest-parameters`:
```bash
helm install qtest-parameters -f parameters-values-kind.yaml -n qtest
```
## Uninstallation
Removal is the reverse of installation. Start removal of the apps first and then Manager.  Example:
```bash
helm uninstall qtest-parameters
helm uninstall qtest-manager

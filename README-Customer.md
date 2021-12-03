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

## qTest Manager parameters to change in values-local.yaml
<pre>

| Parameter                   | Description                                          | Default |
| --------------------------- | ---------------------------------------------------- | ------- |
| `client.jdbc.postgres.url` | PSQL database URL | `jdbc:postgresql://host.docker.internal/qtest` |
| `client.jdbc.postgres.username` | PSQL username | `postgres` |
| `client.jdbc.postgres.password` | PSQL password | `cG9zdGdyZXM=` (`postgres`, base64-encoded) |
| `client.jdbc.postgres.readonly.url` | PSQL readonly database URL | `jdbc:postgresql://host.docker.internal/qtest` |
| `client.jdbc.postgres.readonly.username` | PSQL username | `postgres` |
| `client.jdbc.postgres.readonly.password` | PSQL password | `cG9zdGdyZXM=` (`postgres`, base64-encoded) |
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

</pre>

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
helm install qtest-manager qtest/qtest-mgr -f mgr-values-kind.yaml -n qtest --create-namespace
```
Note that qTest Manager chart should be the __first__ chart to be installed.
All other qTest charts may be installed subsequently in the similar manner.  For example, to install qTest Parameters with the release name `qtest-parameters`:
```bash
helm install qtest-parameters qtest/qtest-parameters -n qtest
```
## Uninstallation
Removal is the reverse of installation. Start removal of the apps first and then Manager.  Example:
```bash
helm uninstall qtest-parameters
helm uninstall qtest-manager


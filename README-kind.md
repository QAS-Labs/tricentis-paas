# Deploy qTest Applications Using Kubernetes in Docker (KinD)

## Prerequisite Software
Software|Minimum Version|Install Instructions
:---|:---:|:---:
PostgreSQL|13|[Link](https://documentation.tricentis.com/qtest/10500/en/content/onpremise/installation/prerequisites/onpremise_prerequisite_software_for_linux.htm)|
Elasticsearch|7.x|[Link](https://documentation.tricentis.com/qtest/11000/en/content/onpremise/installation/prerequisites/onpremise_prerequisite_software_for_linux.htm)
Docker|20|[Link](https://docs.docker.com/engine/install/)
Helm|3.7.x|[Link](https://helm.sh/docs/)
kubectl|1.20|[link](https://kubernetes.io/docs/tasks/tools/)
KinD|0.11.x|[Link](https://kind.sigs.k8s.io/)

## Prequisite Environmental Configurations
- Root access preferred. If not permitted, the ability to run all commands and install pre-requisites as non-root is required
- Access to public internet outbound
- Docker Hub Token *(Provided by Tricentis Implementation Team)*
- FQDN or DNS Alias for the target server where KinD cluster will be created

## Clone the qTest PaaS Repository
Choose a location on the local filesystem to clone this repository
`git clone https://github.com/QAS-Labs/tricentis-paas.git`

**NOTE**: *Please remember to periodically Git Pull to refresh your local copy of this repository. Changes will take place without notice*

## Create KinD Cluster using Shell script 
`chmod +x kindup.sh`
`./kindup.sh`

## Install Helm Chart Repository
`helm repo add qtest https://GITHUB_TOKEN@raw.githubusercontent.com/QAS-Labs/qtest-chart/gh-pages`
`helm repo update`

## Edit the Deployment YAML File

*__Notes:__*
- *Example used: [mgr-values-kind.yaml](https://github.com/QAS-Labs/tricentis-paas/blob/main/mgr-values-kind.yaml)*
- *Values not listed here should not be edited*

Value|Description|Example Value|Details
:--|:--|:--
client.jdbc.postgres.url|JDBC Connection String Value for PostgreSQL|jdbc:postgresql://database.domain.com:5432/qtest|*String must include <FQDN_of_PostgreSQL_Server>:<PostgreSQL_Listening_Port>/<qTest_Manager_Databasename>*|
client.jdbc.postgres.usrrname|PostgreSQL User|postgres|*Must be a super user in the public schema*|
client.jdbc.postgres.password|PostrgreSQL Password|aGVsbG8K|*Must be a password [encoded to base64](https://www.man7.org/linux/man-pages/man1/base64.1.html)*|
client.jdbc.postgres.readonly.url|Connection String Value for PostgreSQL Replica|jdbc:postgresql://database.domain.com:5432/qtest|*Only required if you are using a PostgreSQL Replica*|
client.jdbc.postgres.readonly.username|PostgreSQL Replica User|postgres|*Only required if you are using a PostgreSQL Replica*|
client.jdbc.postgres.readonly.password|PostrgreSQL Replica Password|aGVsbG8K|*This password must be [encoded to base64](https://www.man7.org/linux/man-pages/man1/base64.1.html)*|
client.jdbc.sslEnable|Enable TLS connections|true|
client.jdbc.sslMountPath|Postgresql TLS certificate mount directory|\etc\ssl|
client.jdbc.sslPath|Postgresql TLS connection string|?ssl=true&sslmode=verify-full&sslrootcert=/etc/ssl/root.crt|*Only change path and cert name in this string*|
client.jdbc.cert|Postgresql client certificate|client.crt|*PostgreSQL TLS client certificate, [base64-encoded]((https://www.man7.org/linux/man-pages/man1/base64.1.html)*|
mail.host|SMTP Hostname|mail.domain.com|*Optional*
mail.port|SMTP Port|465|*Optional*
mail.username|SMTP Username|mailuser|*Optional*
mail.password|SMTP Password|bWFpbHNlcnZlcgo=|*This password must be [encoded to base64](https://www.man7.org/linux/man-pages/man1/base64.1.html)*|
elasticSearch.scheme|Elasticsearch HTTP Scheme|http|
elasticSearch.host|Elasticsearch Hostname|elastic.domain.net|
elasticSearch.port|Elasticsearch Port|9200|
notification.urlExternal|qTest URL|https://qtest.domain.net|
preUrl|qTest URL|http://qtest.domain.net|
preUrlHttps|qTest URL|https://qtest.domain.net|
attachmentFolderPath|Location in filesystem where attachments will be stored|/opt/qtest/data/attachments|
licenseFolderPath|Location in filesystem where license file will be stored|/opt/qtest/data/attachments|
blobStorage.type|Type of filesystem to be used for object storage|disk_storage|*Options* - disk_storage, amazon_s3_access_key|
blobstorage.region| AWS S3 bucket region |us-east-1|*Only nNeeded when blobstorage.type is amazon_s3_access_key*|
blobstorage.sharedBucket|AWS S3 bucket name |qtest|*Only needed when blobstorage.type is amazon_s3_access_key*|
s3.accessKey|Access key for AWS S3 bucket| |*Only needed when blobstorage.type is amazon_s3_access_key*|
s3.secretKey|Secret key for AWs S3 bucket| |*Only needed when blobstorage.type is amazon_s3_access_key*|
s3.folder|Folder location in AWS S3 bucket|qtest/manager|*Only needed when blobstorage.type is amazon_s3_access_key*|
s3.scanUrl|Virus Scan URL for AWS S3 uploads|https://clamav.qtest.local|*Only needed when blobstorage.type is amazon_s3_access_key*|
ingress.hosts|qTest Server Hostname|server-qtest.domain.net|
ingress.tls.hosts|qTest Server Hostname|server-qtest.domain.net|
limitRange.limits.max.cpu|Max CPU that a single container in a pod can request|4|
limitRange.limits.max.memory|Max RAM that a single container in a pod can request|16Gi|
limitRange.limits.default.cpu|Default CPU that a container can use if not specified in the Pod spec|2|
limitRange.limits.default.memory|Default RAM that a container can use if not specified in the Pod spec|8Gi|
limitRange.limits.defaultRequest.cpu|Default CPU that a container can request if not specified in the Pod spec|2|
limitRange.limits.defaultRequest.memory|Default RAM that a container can request if not specified in the Pod spec|8Gi|
persistence.size|Max size of the persistent volume|10Gi|*Value can be increased as hoc. Will take effect on startup*|
persistence.s3.region|AWS S3 region|us-east-1|*Only needed when blobstorage.type is amazon_s3_access_key*|
persistence.s3.bucketName|AWS S3 bucket name|qtest|*Only needed when blobstorage.type is amazon_s3_access_key*|
persistence.s3.folder|AWS S3 folder |qtest/manager|*Only needed when blobstorage.type is amazon_s3_access_key*|

## Deploy qTest Application(s)
Install the qTest Manager chart with the release name `qtest-manager` in the `qtest` namespace:
`helm install qtest-manager -f mgr-values-kind.yaml qtest/qtest-mgr -n qtest --create-namespace`

*__Notes:__*
- *qTest Manager chart should be the *first* chart to be installed.*
- *All other qTest charts may be installed subsequently in the similar manner.  For example, to install qTest Parameters with the release name `qtest-parameters`*
  `helm install qtest-parameters -f parameters-values-kind.yaml qtest/parameters -n qtest`

## License qTest 

- After appliation startup, copy the server ID from the Administration screen
- Provide the server ID to your CSM or Implementation Engineer

#### Option 1 
- Import the license file using the Import button in the Administration screen

#### Option 2
- Copy the license file to the location specified in `license.folder.path` in the YAML file
- Run the following command on each worker node to copy the license file into the container:
  `docker cp -p license.lic kind-worker:/<license_folder_path>`

## Uninstallation 
To remove qTest applications, use the following command: 
`helm uninstall qtest-mgr`

*Replace qtest-mgr with the application name you wish to uninstall*
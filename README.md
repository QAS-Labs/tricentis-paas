# K8s cluster in a box!

This is a quickstart to deploy qTest on your local dev K8s multi-node cluster.

## Prerequisites

* PostgreSQL (local)
* Docker Desktop
* Git Bash (or WSL2)
* kubectl 
* Helm
* Kind

## Clone this repo
<code>git clone git@github.com:QAS-Labs/qtest-paas</code>

## Set up cluster
<code>./kindup.sh</code>

## Build qTest and Liquibase
Please refer to qTest build instructions; but, in a nutshell:

<code>mvn clean install -DskipTests -Pminify-js</code><p>

Note for <b>Windows</b> users:  If you run out of heap space, you can build without the -Pminify-js profile.  Please add the following in your <code>src/main/resources/configuration/common/override.properties</code> file (don't check this in!) and rebuild without the -Pminify-js flag:
<pre>testconductor.isnotminify=true</pre>

<code>docker build . -f ./docker/qtest/Dockerfile -t localhost:5000/qtestmgr && docker push localhost:5000/qtestmgr</code><p>
<code>docker build . -f ./docker/liquibase/Dockerfile -t localhost:5000/liquibase && docker push localhost:5000/liquibase</code>

Note for <b>Windows</b> users:  If you have an error starting the qTest container in Windows, chances are you might have the Windows EOL characters in your entry script.  To remove them:

<code>dos2unix.exe $QTEST_HOME/docker/qtest/entrypoint.sh</code>

## Deploy qTest via local Helm
<code>export QCHART="location of your qtest_chart Helm repo"</code><p>
<code>helm install qtest -f mgr-values-kind.yaml $QCHART/Charts/qtest-chart</code>

## Sanity Tests
<code>./sanity.sh</code>

## Tear down cluster
<code>kind delete cluster</code>

## Add the below entries to your host file
<pre>
127.0.0.1       nephele.qtest.local
127.0.0.1       qtestdev1.qtest.local
127.0.0.1       nginx.local
127.0.0.1       jira.local
127.0.0.1       scenario.local
127.0.0.1       qtest.local
127.0.0.1       notification.qtest.local
</pre>

## Guide to run qTest Manager in onPremise mode
<pre>
testconductor:
  environment:
    isOnPremise: true

  # Under qTestManager
  attachmentFolderPath: /mnt/data/qtest/attachments
  licenseFolderPath: /mnt/data/qtest/license
</pre>

* Once the server is up and running, copy the server id from the Administrator -> license
* Generate the license with the server id and place it in qtest-pass directory
* copy the license to /mnt directory to kind nodes
    - docker cp license.lic kind-worker:/mnt
    - docker cp license.lic kind-worker2:/mnt
* Login to kind worker and create directory /mnt/data/qtest/attachments and /mnt/data/qtest/license
* Move the license from /mnt directory to /mnt/data/qtest/license

## Guide to run a single instance
<pre>
testconductor:
  environment:
    isOnPremise: false
    singleInstance: true
</pre>
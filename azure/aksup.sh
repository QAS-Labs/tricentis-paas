#!/bin/bash
####################################################################
# Script to spin up a burst AKS cluster (experimental).
# Note: You need to do a one-time "az login" before running this.
####################################################################
resourceGroupName="qtest"
clusterName="azure-qk8s"
location="westus2"

vmCount="1"
vmSize="Standard_B4ms"
#vmSize="Standard_D4s_v4"

echo "Creating group $resourceGroupName..."
echo "Don't forget to clean up by deleting the above resource: az group delete --name $resourceGroupName"

az group create --location $location --name $resourceGroupName
az aks create -n "$clusterName" -g "$resourceGroupName" --location $location \
    --node-count $vmCount --node-vm-size $vmSize \
    --network-plugin azure --enable-managed-identity \
    -a "http_application_routing,ingress-appgw" --appgw-name "$clusterName-appgw" --appgw-subnet-cidr "10.2.0.0/16" \
    --generate-ssh-keys

dns=$(az aks show --resource-group $resourceGroupName --name $clusterName \--query addonProfiles.httpApplicationRouting.config.HTTPApplicationRoutingZoneName -o table | grep \.io)
echo "Your DNS zone is $dns"

# Update manager values with new DNS
sed -i "s/mgr-service\...*$/mgr-service\.$dns/" mgr-values-aks.yaml

# Add kube context
az aks get-credentials --resource-group $resourceGroupName --name $clusterName
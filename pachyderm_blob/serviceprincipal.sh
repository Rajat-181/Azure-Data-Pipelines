#!/bin/bash

#################### Variables ####################
AKS_RESOURCE_GROUP='crowe-demo'
AKS_CLUSTER_NAME='aks-cluster'
ACR_REGISTRY_NAME='dockerrepodemo'
SERVICE_PRINCIPAL_NAME='servicenamedemo'
MAIL_ID='yuvraj@purdue.edu'
###################################################

az aks create --name $AKS_CLUSTER_NAME --resource-group $AKS_RESOURCE_GROUP

# Populate the ACR login server and resource id.
ACR_LOGIN_SERVER=$(az acr show --name $ACR_REGISTRY_NAME --query loginServer --output tsv)
ACR_REGISTRY_ID=$(az acr show --name $ACR_REGISTRY_NAME --query id --output tsv)

# Create acrpull role assignment with a scope of the ACR resource.
SP_PASSWD=$(az ad sp create-for-rbac --name http://$SERVICE_PRINCIPAL_NAME --role acrpull --scopes $ACR_REGISTRY_ID --query password --output tsv)

# Get the service principal client id.
CLIENT_ID=$(az ad sp show --id http://$SERVICE_PRINCIPAL_NAME --query appId --output tsv)

# Output used when creating Kubernetes secret.
echo "Service principal ID: $CLIENT_ID"
echo "Service principal password: $SP_PASSWD"

kubectl create secret docker-registry acr-auth --docker-server $ACR_REGISTRY_NAME --docker-username $CLIENT_ID --docker-password $SP_PASSWD --docker-email $MAIL_ID

# Verify creation of secrets
kubectl get secrets

#!/bin/bash

#################### Variables ####################
AKS_RESOURCE_GROUP='crowe-demo'
AKS_CLUSTER_NAME='aks-cluster'
ACR_RESOURCE_GROUP='crowe-demo'
ACR_REGISTRY_NAME='dockerrepodemo'
###################################################

# Get the id of the service principal configured for AKS
CLIENT_ID=$(az aks show --resource-group $AKS_RESOURCE_GROUP --name $AKS_CLUSTER_NAME --query "servicePrincipalProfile.clientId" --output tsv)

# Get the ACR registry resource id
ACR_ID=$(az acr show --name $ACR_REGISTRY_NAME --resource-group $ACR_RESOURCE_GROUP --query "id" --output tsv)

# Create role assignment
az role assignment create --assignee $CLIENT_ID --role acrpull --scope $ACR_ID

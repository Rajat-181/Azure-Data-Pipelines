#!/bin/bash

#################### Variables ####################
ACR_REGISTRY_NAME='dockerrepodemo'
RES_GROUP=$ACR_REGISTRY_NAME # Resource Group name
AKV_NAME=$ACR_REGISTRY_NAME-vault # Azure Key Vault Name
###################################################

cd pachyderm_blob/
az acr build --registry $ACR_REGISTRY_NAME --image crowe_cron:v2 .

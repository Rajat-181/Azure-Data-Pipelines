#!/bin/bash

#################### Variables ####################
ACR_REGISTRY_NAME='dockerrepodemo'
RES_GROUP=$ACR_NAME # Resource Group name
AKV_NAME=$ACR_NAME-vault # Azure Key Vault Name
###################################################

cd pachyderm_validation/
az acr build --registry $ACR_REGISTRY_NAME --image chg_validate_image:v2 .

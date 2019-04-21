#################### Variables ####################
AZURE_RESOURCE_GROUP="crowe-demo"
AZURE_LOCATION="eastus"
AKS_NODE_SIZE="Standard_DS2_v2"
AKS_CLUSTER_NAME="aks-cluster"
AKS_NODE_COUNT=2
AKS_VERSION="1.12.5"
AZURE_STORAGE_ACCOUNT="crowedemostorage"
AZURE_BLOB_CONTAINER_NAME="crowe-file"
STORAGE_SIZE=1
STORAGE_SKU="Standard_LRS"
ACR_REGISTRY_NAME="dockerrepodemo"
ACR_SKU="Basic"
###################################################

# Create Resource Group
az group create --name=${AZURE_RESOURCE_GROUP} --location=${AZURE_LOCATION}

# Create AKS Cluster
az aks create --resource-group ${AZURE_RESOURCE_GROUP} --name ${AKS_CLUSTER_NAME} --generate-ssh-keys --node-vm-size ${AKS_NODE_SIZE} --node-count ${AKS_NODE_COUNT} --kubernetes-version ${AKS_VERSION}

# Connect to AKS Cluster
az aks get-credentials --resource-group ${AZURE_RESOURCE_GROUP} --name ${AKS_CLUSTER_NAME}

# Create Storage Account
az storage account create --name ${AZURE_STORAGE_ACCOUNT} --location ${AZURE_LOCATION} --resource-group ${AZURE_RESOURCE_GROUP} --kind Storage --sku=${STORAGE_SKU}

# Retrieve the Azure Storage Account Key
AZURE_STORAGE_KEY=`az storage account keys list --account-name ${AZURE_STORAGE_ACCOUNT} --resource-group ${AZURE_RESOURCE_GROUP} --output tsv | grep "key1" | cut -d $'\t' -f3`

# Create Container within a Storage Account
az storage container create --name ${AZURE_BLOB_CONTAINER_NAME} --account-key ${AZURE_STORAGE_KEY} --account-name ${AZURE_STORAGE_ACCOUNT}

# Install PachCTL (Currently Command is for installation on Linux)
curl -o /tmp/pachctl.deb -L https://github.com/pachyderm/pachyderm/releases/download/v1.7.1/pachctl_1.7.1_amd64.deb && sudo dpkg -i /tmp/pachctl.deb

# Start Pachyderm
pachctl deploy microsoft ${AZURE_BLOB_CONTAINER_NAME} ${AZURE_STORAGE_ACCOUNT} ${AZURE_STORAGE_KEY} ${STORAGE_SIZE} --dynamic-etcd-nodes 1

# Check if Pachyderm is up and running on Kubernetes
kubectl get pods

# Forward Pachyderm Ports
pachctl port-forward &

# Check Pachyderm Version
pachctl version

# Create ACR
az acr create -n ${ACR_REGISTRY_NAME} -g ${AZURE_RESOURCE_GROUP} --sku ${ACR_SKU}

# Fetch Service Principal Id
AKS_SERVICE_PRINCIPAL=`az aks list | grep "clientId" | cut -d':' -f2`

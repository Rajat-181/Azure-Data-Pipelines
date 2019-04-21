import os, uuid, sys
from azure.storage.blob import BlockBlobService, PublicAccess
from dateutil.parser import parse

# Mentioning the storage account name and key
act_name = "crowedemostorage"
act_key = "WWxjJW+GkKIkklkXEuR6nDalogfrriKUG3Ra03Z3/xiwg5EA3lOVutjqqJbxCBCxd9C8HrtAuV6OC0Nzwz1rbQ=="
block_blob_service = BlockBlobService(account_name=act_name, account_key=act_key)

# Creating function to validate the file names

def validateFileNamingConvention(filename):
	try:
		parse(filename[0:10])
		return True
	except:
		return False

# Creating function to move file from one blob container to another

def moveFileToAnotherContainer(source_container,destination_container,file_name):
	# Creating Blob URL
	blob_url = block_blob_service.make_blob_url(source_container,file_name)
	print(blob_url)

	# Copying blob to another container
	block_blob_service.copy_blob(destination_container, file_name, blob_url)

	# Deleting blob from main container
	block_blob_service.delete_blob(source_container, file_name)

# Create Containers within Blob
container_name = "crowe-file"
processed_container_name = "processed-container"
invalid_container_name = "invalid-container"

block_blob_service.create_container(processed_container_name)
block_blob_service.create_container(invalid_container_name)

# Iterate through the blobs in the container
generator = block_blob_service.list_blobs(container_name,prefix="2")
print("Running Crowe Industry Practicum Project")

for blob in generator:
	if blob.name.endswith('.csv'):
		if validateFileNamingConvention(blob.name):
			print(blob.name, "is a valid file")
			newname = blob.name.split('_')[1]
			file_path_name = "/pfs/out/" + blob.name
			print(file_path_name)
			block_blob_service.get_blob_to_path(container_name, blob.name,file_path_name)
			print("Pushing to Pachctl Input Repo")
			print("Copying file to Processed Container")
			block_blob_service.create_blob_from_path(processed_container_name, blob.name, file_path_name)
		else:
			print(blob.name, "is an invalid file")
			print("Copying file to Invalid Files Container")

			moveFileToAnotherContainer(container_name,invalid_container_name,blob.name)
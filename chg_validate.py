import os, uuid, sys
from azure.storage.blob import BlockBlobService, PublicAccess
from dateutil.parser import parse

# Mentioning the storage account name and key
act_name = "crowedemostorage"
act_key = "WWxjJW+GkKIkklkXEuR6nDalogfrriKUG3Ra03Z3/xiwg5EA3lOVutjqqJbxCBCxd9C8HrtAuV6OC0Nzwz1rbQ=="
block_blob_service = BlockBlobService(account_name=act_name, account_key=act_key)

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

container_name = "pachy-container"
processed_container_name = "processed-container"
validate_success_container_name="validate-success"
validate_failure_container_name="validate-failure"
block_blob_service.create_container(processed_container_name)
block_blob_service.create_container(validate_success_container_name)
block_blob_service.create_container(validate_failure_container_name)

# Iterate through the blobs in the container

generator = block_blob_service.list_blobs(container_name,prefix="2")
print("Running Crowe Industry Practicum Project")

def validateEndLines(File_Name):
	validateStatus = True
	Open_file = open(path+File_Name,'r').readlines()
	print("File is Opened")
	if(len(Open_file) > 0):
		no_of_header_cols = len(Open_file[0].split("|"))
		for column in Open_file[0].split("|"):
			if(isinstance(column,str)) == False:
				validateStatus = False
				print("Validation #5 failed")
				print(column,type(column))
				break
	for line in Open_file:
		if os.name == "nt":
			if('\r\n' not in line):
				validateStatus = False
				print("Validation #2 failed")
				break
			else:
				if('\n' not in line):
					validateStatus = False
					print("Validation #2 failed")
					break
		if(len(line.split("|")) != no_of_header_cols):
			validateStatus = False
			print("Validation #7 failed")
			break
		for field in line.split("|"):
			if(field != "" and "str" == type(field)):
				if(field.strip() == ""):
					validateStatus = False
					print("Validation #8 failed")
					break
				if(field.trim() != field):
					validateStatus = False
					print("Validation #9 failed")
					break
	return validateStatus

path = '/pfs/query/'
for filename in os.listdir(path):
	if validateEndLines(filename):
		print(filename,":Success")

		print("Copying file to Validate Success Container")
		print(validate_success_container_name, filename, filename)

		moveFileToAnotherContainer(container_name,validate_success_container_name,filename)

	else:
		print(filename,":Fail")
		print("Copying file to Validate Failure Container")
		print(validate_failure_container_name, filename, filename)

		moveFileToAnotherContainer(container_name,validate_failure_container_name,filename)

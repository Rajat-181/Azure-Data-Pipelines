# Azure-Data-Pipelines
Industry Practicum Project on developing a scalable data pipeline using Microsoft Azure, Kubernetes and Pachyderm

Microsoft Azure data pipeline implementation for Crowe LLC
Report: https://www.dropbox.com/s/89ski1ng4cae01v/Crowe%20Paper.pdf?dl=0 
Presentation: https://www.dropbox.com/s/l0wf6xgd9wezo1a/Final%20Presentation%20Crowe.pptx?dl=0

Our client is one of the largest public accounting, consulting, and technology firms in the U.S. with a need to process massive amounts of healthcare data. In particular, the client’s “Revenue Analytics” product gathers data from over 1000 hospitals. As their business grows, having a decentralized database brings more disparity. It creates difficulty in scaling the infrastructure, using computing effectively, and managing failures and downtime. With this project, we facilitate the commoditization of this data in the cloud using Kubernetes and Blob storage. This approach allows us to create an easily accessible, robust and centralized data and analysis platform meeting the needs of various stakeholders. Moreover, this new data architecture overcomes the challenges of the client’s current architecture in which a series of ETL transformations push data into various database locations. Previously, the client could not track the point of failures in their data pipelines. We solve this problem via Azure cloud services along with Kubernetes and Docker to design, develop and track all data pipelines. These data pipelines feed a centralized “SQL Data Hub” that drives all decision-making processes and powers enhanced BI reporting.

Understanding the various files -

Setup-Environment.sh - This file is used to setup the infrastructure on Azure (Creates Resource Group, Create Storage Account, Create Blob Container, Install Pachyderm, Create ACR.

Setup-SQL.sh - This file is used to create the SQL Server and Database on Azure.

Pachyderm_Blob - This folder contains the various artifacts

crowe_input.py - The python file contains the code to fetch files from Blob and store in Pachyderm Input Repository.
Dockerfile & requirements.txt - This contains the Docker file and the requirements for installing the dependencies.
crowe_input_json.json - This file contains the configuration file of Pachyderm to initiate Docker containers on Kubernetes.
servicerinicipal.sh - This file creates the Kubernetes Cluster to create ACR credentials.
acr.sh - This file fetches the ACR credentials.
Pachyderm_Validation - This folder contains the various artifacts

chg_validate.py - The python file contains the code which creates the validation logic and the logic to insert data into SQL
Dockerfile & requirements.txt - This contains the Docker file and the requirements for installing the dependencies.
crowe_input_chg.json - This file contains the configuration file of Pachyderm to initiate Docker containers on Kubernetes.

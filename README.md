# How to deploy:
1) Install Service Fabric
1) Create your own SignalR and Service Bus resources in Azure
1) Run Initialize-LocalEnvironment.ps1. This script will set up your environment, you could reexecute this script once something changed in the projects environment
1) Run Set-Configs.ps1. This script updates configs in all projects, you could reexecute this script once something changed in the configs
1) Run Set-SampleData.ps1. This script clean up your database and Storage Container and fill it with test data.

## For now you should manually deploy database before running Set-SampleData.ps1. Also you should publish your server into some folder and point IIS WebSite to this folder

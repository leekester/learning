# Azure Container Registry Deployment
Here we have Bicep which can be used to deploy an Azure Container Registry (ACR).  
Couple of things to mention:
* ACR isn't free. At the time of writing, it's around £0.16/day for a Basic SKU and £0.60/day for Standard.
* Update deploy.ps1 to override any default values in the .bicep file, or pass in some JSON as parameters.
* The Standard SKU is required if you'd like an anonymous/public/unauthenticated ACR.

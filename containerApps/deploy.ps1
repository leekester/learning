$resourceGroup = "rg-containerapp"
$location = "uksouth"
$deployName = ("deployment_" + (Get-Date -Format ddMMyy_HHmmss))
az group create -n $resourceGroup -l $location

az deployment group create `
  --name $deployName `
  --resource-group $resourceGroup `
  --template-file ./containerApp.bicep
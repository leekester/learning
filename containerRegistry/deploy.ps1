$resourceGroup = "rg-acr"
$location = "uksouth"
$deployName = ("deployment_acr_" + (Get-Date -Format ddMMyy_HHmmss))
$randomSuffix = Get-Random -Minimum 10000000 -Maximum 99999999
$anonymousPullEnabled = $true
$acrSku = "Standard"
az group create -n $resourceGroup -l $location

az deployment group create `
  --name $deployName `
  --resource-group $resourceGroup `
  --template-file ./containerRegistry.bicep `
  --parameters `
  randomSuffix=$randomSuffix `
  acrSku=$acrSku `
  anonymousPullEnabled=$anonymousPullEnabled
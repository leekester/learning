$resourceGroup = "rg-containerapp"
$location = "uksouth"
$deployName = ("deployment_containerApp_" + (Get-Date -Format ddMMyy_HHmmss))
az group create -n $resourceGroup -l $location

az deployment group create `
  --name $deployName `
  --resource-group $resourceGroup `
  --template-file ./containerApp.bicep

Write-Host "Adding revision 2 of application..." -ForegroundColor Yellow
az containerapp update --name app-petsapp `
  --resource-group rg-containerapp `
  --image acrdemo49577068.azurecr.io/apps/containerapp:v2 `
  --revision-suffix v2

Write-Host "Reverting revision 1 to 100% of traffic..." -ForegroundColor Yellow
az containerapp ingress traffic set --name app-petsapp `
  --resource-group rg-containerapp `
  --revision-weight app-petsapp--v1=100

<#
Write-Host "Split traffic across revisions..." -ForegroundColor Yellow
az containerapp ingress traffic set --name app-petsapp `
  --resource-group rg-containerapp `
  --revision-weight app-petsapp--v1=95 app-petsapp--v2=5
#>
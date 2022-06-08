$uri = "https://app-petsapp.delightfulpond-dfdb7bdc.uksouth.azurecontainerapps.io"
$count = 200

$canaryCount = 0
$puppyCount = 0
ForEach ($i in 1..$count) {
  $content = (Invoke-WebRequest -Uri $uri).Content
  $title = ($content | findstr /i "title").Split('<title>').Split('</title>')
  If ($title -match "Puppies") {
    $colour = "Green"
    $puppyCount++
  }
  If ($title -match "Canaries") {
    $colour = "Red"
    $canaryCount++
  }
  Write-Host $title -ForegroundColor ($colour)
}

Write-Host
Write-Host ("Total puppy count: " + $puppyCount)
Write-Host ("Total puppy count: " + $canaryCount)
Write-Host
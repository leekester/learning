$outputFile = "test.properties"
$ErrorActionPreference = "Stop"
$appConfigInstance = "https://<YOUR-APP-CONFIG>.azconfig.io"
$method = "GET"
$body = $null
$credential = "<YOUR-CREDENTIAL>"
$secret = "<YOUR-SECRET>"

function Sign-Request(
    [string] $hostname,
    [string] $method,      # GET, PUT, POST, DELETE
    [string] $url,         # path+query
    [string] $body,        # request body
    [string] $credential,  # access key id
    [string] $secret       # access key value (base64 encoded)
)
{  
    $verb = $method.ToUpperInvariant()
    $utcNow = (Get-Date).ToUniversalTime().ToString("R", [Globalization.DateTimeFormatInfo]::InvariantInfo)
    $contentHash = Compute-SHA256Hash $body

    $signedHeaders = "x-ms-date;host;x-ms-content-sha256";  # Semicolon separated header names

    $stringToSign = $verb + "`n" +
                    $url + "`n" +
                    $utcNow + ";" + $hostname + ";" + $contentHash  # Semicolon separated signedHeaders values

    $signature = Compute-HMACSHA256Hash $secret $stringToSign

    # Return request headers
    return @{
        "x-ms-date" = $utcNow;
        "x-ms-content-sha256" = $contentHash;
        "Authorization" = "HMAC-SHA256 Credential=" + $credential + "&SignedHeaders=" + $signedHeaders + "&Signature=" + $signature
    }
}

function Compute-SHA256Hash(
    [string] $content
)
{
    $sha256 = [System.Security.Cryptography.SHA256]::Create()
    try {
        return [Convert]::ToBase64String($sha256.ComputeHash([Text.Encoding]::ASCII.GetBytes($content)))
    }
    finally {
        $sha256.Dispose()
    }
}

function Compute-HMACSHA256Hash(
    [string] $secret,      # base64 encoded
    [string] $content
)
{
    $hmac = [System.Security.Cryptography.HMACSHA256]::new([Convert]::FromBase64String($secret))
    try {
        return [Convert]::ToBase64String($hmac.ComputeHash([Text.Encoding]::ASCII.GetBytes($content)))
    }
    finally {
        $hmac.Dispose()
    }
}

$config = @()
$count = 1
$configPage = $null # Clear variable when testing multiple runs

# Loop to handle cases where results are paginated
Do {
    If ($configPage.'@nextLink') {
        $uriSuffix = $configPage.'@nextLink'
        } Else {
        $uriSuffix = "/kv?api-version=1.0"
    }
    $uri = [System.Uri]::new($appConfigInstance + $uriSuffix)
    $headers = Sign-Request $uri.Authority $method $uri.PathAndQuery $body $credential $secret
    $configPage = Invoke-RestMethod -Uri $uri -Method $method -Headers $headers -Body $body
    $config += $configPage.items
    Write-Host ("Getting page " + $count + " of results...") -ForegroundColor Yellow
    $count++
    } Until ($configPage.'@nextLink' -eq $null)

# Generate file

If (Test-Path -Path $outputFile) {
    Remove-Item -Path $outputFile
    }

Sleep 3
Write-Host
Write-Host "Creating properties file..."
$lineCount = 0
ForEach ($keyPair in $config) {
    $lineCount++
    Write-Host ("Writing line " + $lineCount + " of " + $config.Count + "...") -ForegroundColor Yellow
    $line = ($keyPair.key + "=" + $keyPair.value)
    Add-Content -Path ./test.properties -Value $line
    }
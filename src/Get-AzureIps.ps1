
$sourceUrl = "https://www.microsoft.com/en-us/download/details.aspx?id=56519"
$pageContent = Invoke-WebRequest -Uri $sourceUrl -UseBasicParsing
$downloadUrlPattern = "https://download\.microsoft\.com/download/[^\s""]+"
$downloadUrl = [regex]::Match($pageContent.Content, $downloadUrlPattern).Value
$fileName = $downloadUrl.Split("/")[-1]
$downloadReq = Invoke-WebRequest -Uri $downloadUrl -UseBasicParsing
$json = [System.Text.Encoding]::UTF8.GetString($downloadReq.Content)
$serviceTags = ($json | ConvertFrom-Json).values

$readme = "# Azure IP Ranges and Service Tags – Public Cloud`n Azure IPs and Service Tags provided using static URLs, individual files per Service Tag and versioned files for use within KQL queries, etc.`n---`n"

$latestPath = 'ServiceTags_Public_Latest.json'
$json | Out-File $latestPath

$readme += "Latest Version: [$latestPath]($latestPath)`n`n"

$versionedPath = "versions/$($fileName)"
$versionedFolder = Split-Path $versionedPath
if (-not (Test-Path -Path $versionedFolder)) {
    New-Item -ItemType Directory -Path $versionedFolder | Out-Null
}
$json | Out-File $versionedPath
$readme += "Versioned Files: [$versionedFolder]($versionedFolder)`n`n"

$serviceTagsFolder = 'serviceTags'
if (-not (Test-Path -Path $serviceTagsFolder)) {
    New-Item -ItemType Directory -Path $serviceTagsFolder | Out-Null
}
$readme += "Service Tag Files: $serviceTagsFolder`n"
$readme += "| Service Tag | Full Service Tag | All IPs | IPv4 | IPv6 |`n|---|---|---|---|---|`n"
foreach ($serviceTag in $serviceTags) {
    $serviceTagFolder = "$serviceTagsFolder/$($serviceTag.id)"
    if (-not (Test-Path -Path $serviceTagFolder)) {
        New-Item -ItemType Directory -Path $serviceTagFolder | Out-Null
    }
    $serviceTagPath = "$serviceTagFolder/serviceTag.json"
    $serviceTag | ConvertTo-Json | Out-File $serviceTagPath

    $ipsOnlyPath = "$serviceTagFolder/ips.json"
    $serviceTag.properties.addressPrefixes | ConvertTo-Json | Out-File $ipsOnlyPath

    $ipv4OnlyPath = "$serviceTagFolder/ipv4.json"
    $ipv4Addresses = $serviceTag.properties.addressPrefixes | Where-Object { $_ -match '^\d{1,3}(\.\d{1,3}){3}\/\d{1,2}$' }
    $ipv4Addresses | ConvertTo-Json | Out-File $ipv4OnlyPath

    $ipv6OnlyPath = "$serviceTagFolder/ipv6.json"
    $ipv6Addresses = $serviceTag.properties.addressPrefixes | Where-Object { $_ -match '^[a-fA-F0-9:]+\/\d{1,3}$' }
    $ipv6Addresses | ConvertTo-Json | Out-File $ipv6OnlyPath

    $readme += "| $($serviceTag.id) | [$serviceTagPath]($serviceTagPath) | [$ipsOnlyPath]($ipsOnlyPath) | [$ipv4OnlyPath]($ipv4OnlyPath) | [$ipv6OnlyPath]($ipv6OnlyPath) |`n"
}

$readme | Out-File 'README.md'

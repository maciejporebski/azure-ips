$downloadUrl = "https://download.microsoft.com/download/7/1/D/71D86715-5596-4529-9B13-DA13A5DE5B63/ServiceTags_Public_Latest.json"
$fileName = $downloadUrl.Split("/")[-1]
$downloadReq = Invoke-WebRequest -Uri $downloadUrl -UseBasicParsing
$json = [System.Text.Encoding]::UTF8.GetString($downloadReq.Content)
$serviceTags = ($json | ConvertFrom-Json).values

$latestPath = 'ServiceTags_Public_Latest.json'
$json | Out-File $latestPath

$versionedPath = "versions/$($fileName)"
$versionedFolder = Split-Path $versionedPath
if (-not (Test-Path -Path $versionedFolder)) {
    New-Item -ItemType Directory -Path $versionedFolder | Out-Null
}
$json | Out-File $versionedPath

$serviceTagsFolder = 'serviceTags'
if (-not (Test-Path -Path $serviceTagsFolder)) {
    New-Item -ItemType Directory -Path $serviceTagsFolder | Out-Null
}
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
}

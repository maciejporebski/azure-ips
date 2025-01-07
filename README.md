# Azure IP Ranges and Service Tags – Public Cloud

 Azure IPs and Service Tags provided using static URLs, individual files per Service Tag and versioned files for use within KQL queries, etc.

## Latest Version
The following file tracks the current version:

[ServiceTags_Public_Latest.json](ServiceTags_Public_Latest.json)

## Versioned Files
Version-specific files can be found in the [versions](versions) directory.

The file name pattern is: `ServiceTags_Public_yyyymmdd.json`

eg. version `20250106` is located under [versions/ServiceTags_Public_20250106.json](\versions\ServiceTags_Public_20250106.json)

## Service Tag-Specific Files
Each Service Tag is broken down into a number of individual files, containing:

- **serviceTag.json**: Full Service Tag json
- **ips.json**: A JSON array of all IPv4 and IPv6 addresses belonging to the Service Tag
- **ipv4.json**: A JSON array of just IPv4 addresses belonging to the Service Tag
- **ipv6.json**: A JSON array of just IPv6 addresses belonging to the Service Tag

Service-Tag-specific files are located in the [serviceTags](serviceTags) directory, with a sub-directory named after the Service Tag's ID:

- serviceTags
  - \<service-tag-id\>
    - ips.json
    - ipv4.json
    - ipv6.json

eg. files for the `AzureCloud` are found under:
- [serviceTags/AzureCloud/serviceTag.json](serviceTags/AzureCloud/serviceTag.json)
- [serviceTags/AzureCloud/ips.json](serviceTags/AzureCloud/ips.json)
- [serviceTags/AzureCloud/ipv4.json](serviceTags/AzureCloud/ipv4.json)
- [serviceTags/AzureCloud/ipv6.json](serviceTags/AzureCloud/ipv6.json)

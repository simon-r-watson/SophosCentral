# Endpoint Migration Between Tenants

* Based on this - <https://developer.sophos.com/endpoint-migrations>

1. Connect as a partner or enterprise customer

```powershell
$ClientID = Read-Host -Prompt 'Client ID'
$ClientSecret = Read-Host -AsSecureString -Prompt 'Client Secret'
Connect-SophosCentral -ClientID $ClientID -ClientSecret $ClientSecret
```

2. Select the source/destination Tenant ID's. Select one row only for each popup and press ok.

```powershell
$SourceTenantID = (Get-SophosCentralCustomerTenant | Out-GridView -PassThru -Title "Source Tenant").id
$DestinationTenantID = (Get-SophosCentralCustomerTenant | Out-GridView -PassThru -Title "Destination Tenant").id
```

3. Select the endpoints in the source tenant you want to migrate

```powershell
Connect-SophosCentralCustomerTenant -CustomerTenantID $SourceTenantID
$Endpoints = Get-SophosCentralEndpoint | Out-GridView -PassThru
```

4. Create the receive job in the destination tenant

```powershell
$jobDetails = Invoke-SophosCentralEndpointMigrationReceive -EndpointID ($Endpoints).id -SourceTenantID $SourceTenantID -DestinationTenantID $DestinationTenantID
$jobDetails
```

5. Create the send job in the source tenant

```powershell
$jobSendDetails = Invoke-SophosCentralEndpointMigrationSend -EndpointID ($Endpoints).id -SourceTenantID $SourceTenantID -MigrationID $jobDetails.id -MigrationToken $jobDetails.token
$jobSendDetails
```

6. Check status of the endpoint migration

```powershell
Get-SophosCentralEndpointMigrationStatus -MigrationID $jobDetails.id
```

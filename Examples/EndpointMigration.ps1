#Based on this - https://developer.sophos.com/endpoint-migrations

#Connect as a partner or enterprise customer
Connect-SophosCentral -SecretVault -AzKeyVault

$SourceTenantID = '5af77067-4c7b-4ce9-93cc-39c9a2f54e4d'
$DestinationTenantID = 'b2aaa273-2f27-4036-9e07-f1b1832d589c'

#Get all endpoints in the source tenant
#You must filter this if you only what to migrate a subset on the endpoints in the source tenant
Connect-SophosCentralCustomerTenant -CustomerTenantID $SourceTenantID
$Endpoints = Get-SophosCentralEndpoint
#Filter example using Out-GridView
$Endpoints = Get-SophosCentralEndpoint | Out-GridView -PassThru

#Create the receive job in the destination tenant
$jobDetails = Invoke-SophosCentralEndpointMigrationReceive -EndpointID ($Endpoints).id -SourceTenantID $SourceTenantID -DestinationTenantID $DestinationTenantID
$jobDetails

#Create the send job in the source tenant
$jobSendDetails = Invoke-SophosCentralEndpointMigrationSend -EndpointID ($Endpoints).id -SourceTenantID $SourceTenantID -MigrationID $jobDetails.id -MigrationToken $jobDetails.token
$jobSendDetails

#Get status of the endpoint migration
Get-SophosCentralEndpointMigrationStatus -MigrationID $jobDetails.id


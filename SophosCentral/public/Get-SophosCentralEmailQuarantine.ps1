function Get-SophosCentralEmailQuarantine {
    <#
    .SYNOPSIS
        Summary of all the quarantined messages matching your search and filter conditions.
    .DESCRIPTION
        Summary of all the quarantined messages matching your search and filter conditions.
    .PARAMETER BeginDate
        Messages quarantined on or after this date. Used with endDate.
    .PARAMETER EndDate
        Messages quarantined on or after this date. Used with beginDate.
    .PARAMETER ID
        ID from 'X-Sophos-Email-ID' header.
    .PARAMETER FromContains
        Return all rows which contains the provided text in from field.
    .PARAMETER ToContains
        Return all rows which contains the provided text in to field.
    .PARAMETER SubjectContains
        Return all rows which contains the provided text in subject field.
    .PARAMETER AttachmentNameContains
        Return all rows which contains the provided text in attachment names.
    .PARAMETER SizeInMBGreaterThan
        Return all rows where the message size in MB is greater than the provided value.
    .PARAMETER SizeInMBLowerThan
        Return all rows where the message size in MB is less than the provided value.
    .PARAMETER Direction
        Return all rows where the message direction is inbound or outbound.
    .PARAMETER ProductType
        Return all rows where the message product type is mailflow or gateway.
    .PARAMETER HasAnyAttachment
        Return all rows where email has at least one attachment.

    .EXAMPLE
        Get-SophosCentralEmailQuarantine -BeginDate (Get-Date).AddDays(-7) -EndDate (Get-Date) -Direction inbound

        List all quarantined inbound emails in the last 7 days
    .LINK
        https://developer.sophos.com/docs/email-v1/1/routes/quarantine/messages/search/post
    #>
    [CmdletBinding()]
    param (
        [Parameter(ParameterSetName = 'Quarantine')]
        [switch]$Quarantine,

        [Parameter(ParameterSetName = 'PostDelivery')]
        [switch]$PostDelivery,

        [Parameter(Mandatory = $true, ParameterSetName = 'PostDelivery')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Quarantine')]
        [datetime]$BeginDate,

        [Parameter(Mandatory = $true, ParameterSetName = 'PostDelivery')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Quarantine')]
        [datetime]$EndDate,

        [Parameter(ParameterSetName = 'PostDelivery')]
        [Parameter(ParameterSetName = 'Quarantine')]
        [string]$ID,

        [Parameter(ParameterSetName = 'PostDelivery')]
        [Parameter(ParameterSetName = 'Quarantine')]
        [string]$FromContains,

        [Parameter(ParameterSetName = 'PostDelivery')]
        [Parameter(ParameterSetName = 'Quarantine')]
        [string]$ToContains,

        [Parameter(ParameterSetName = 'PostDelivery')]
        [Parameter(ParameterSetName = 'Quarantine')]
        [string]$SubjectContains,

        [Parameter(ParameterSetName = 'PostDelivery')]
        [Parameter(ParameterSetName = 'Quarantine')]
        [string]$AttachmentNameContains,

        [Parameter(ParameterSetName = 'PostDelivery')]
        [Parameter(ParameterSetName = 'Quarantine')]
        [int]$SizeInMBGreaterThan,

        [Parameter(ParameterSetName = 'PostDelivery')]
        [Parameter(ParameterSetName = 'Quarantine')]
        [int]$SizeInMBLowerThan,

        [Parameter(ParameterSetName = 'Quarantine')]
        [ValidateSet('inbound', 'outbound')]
        [string]$Direction,

        [Parameter(ParameterSetName = 'PostDelivery')]
        [Parameter(ParameterSetName = 'Quarantine')]
        [ValidateSet('mailflow', 'gateway')]
        [string]$ProductType,

        [Parameter(ParameterSetName = 'PostDelivery')]
        [Parameter(ParameterSetName = 'Quarantine')]
        [bool]$HasAnyAttachment
    )
    Test-SophosCentralConnected

    $body = @{}
    if ($BeginDate) { $body.Add('beginDate', $BeginDate) }
    if ($EndDate) { $body.Add('endDate', $EndDate) }

    $filter = @{}
    if ($id) { $filter.Add('id', $id) }
    if ($FromContains) { $filter.Add('fromContains', $FromContains) }
    if ($ToContains) { $filter.Add('toContains', $ToContains) }
    if ($SubjectContains) { $filter.Add('subjectContains', $SubjectContains) }
    if ($AttachmentNameContains) { $filter.Add('attachmentNameContains', $AttachmentNameContains) }
    if ($SizeInMBGreaterThan) { $filter.Add('sizeInMBGreaterThan', $SizeInMBGreaterThan) }
    if ($SizeInMBLowerThan) { $filter.Add('sizeInMBLowerThan', $SizeInMBLowerThan) }
    if ($Direction) { $filter.Add('direction', $Direction) }
    if ($ProductType) { $filter.Add('productType', $productType) }
    if ($HasAnyAttachment) { $filter.Add('hasAnyAttachment', $HasAnyAttachment) }

    if ($null -ne $filter) {
        $body.Add('filter', $filter)
    }

    if ($PostDelivery) {
        $queryPath = '/email/v1/post-delivery-quarantine/messages/search'
    } else {
        $queryPath = '/email/v1/quarantine/messages/search'
    }

    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + $queryPath)

    Invoke-SophosCentralWebRequest -Uri $uri -Method Post -Body $body
}

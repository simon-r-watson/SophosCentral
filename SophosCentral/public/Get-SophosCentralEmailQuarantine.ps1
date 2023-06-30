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
        Get-SophosCentralEndpoint

        List all endpoints in the tenant
    .LINK
        https://developer.sophos.com/docs/email-v1/1/routes/quarantine/messages/search/post
    #>
    [CmdletBinding()]
    param (
        [datetime]$BeginDate,
        [datetime]$EndDate,
        [string]$ID,
        [string]$FromContains,
        [string]$ToContains,
        [string]$SubjectContains,
        [string]$AttachmentNameContains,
        [int]$SizeInMBGreaterThan,
        [int]$SizeInMBLowerThan,

        [ValidateSet('inbound', 'outbound')]
        [string]$Direction,

        [ValidateSet('mailflow', 'gateway')]
        [string]$ProductType,

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

    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/email/v1/quarantine/messages/search')

    Invoke-SophosCentralWebRequest -Uri $uri -Method Post -Body $body
}

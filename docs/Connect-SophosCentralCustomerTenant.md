---
external help file: SophosCentral-help.xml
Module Name: SophosCentral
online version: https://developer.sophos.com/getting-started
schema: 2.0.0
---

# Connect-SophosCentralCustomerTenant

## SYNOPSIS
Connect to a Customer tenant (for Sophos partners only)

## SYNTAX

### ByID
```
Connect-SophosCentralCustomerTenant -CustomerTenantID <String> [<CommonParameters>]
```

### BySearchString
```
Connect-SophosCentralCustomerTenant -CustomerNameSearch <String> [<CommonParameters>]
```

## DESCRIPTION
Connect to a Customer tenant (for Sophos partners only).
You must connect with "Connect-SophosCentral" first using a Partner service principal

To find the customer tenant ID, use the "Get-SophosCentralCustomerTenants" function

## EXAMPLES

### EXAMPLE 1
```
Connect-SophosCentralCustomerTenant -CustomerTenantID "asdkjdfjkwetkjdfs"
```

### EXAMPLE 2
```
Connect-SophosCentralCustomerTenant -CustomerTenantID (Get-SophosCentralCustomerTenants | Where-Object {$_.Name -like "*Contoso*"}).ID
```

### EXAMPLE 3
```
Connect-SophosCentralCustomerTenant -CustomerNameSearch "Contoso*"
```

## PARAMETERS

### -CustomerTenantID
The Customers tenant ID

```yaml
Type: String
Parameter Sets: ByID
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomerNameSearch
Search the tenants you have access to by their name in Sophos Central, use "*" as a wildcard.
For example, if you want to connect to "Contoso Legal" \`
you could enter "Contoso*" here.

```yaml
Type: String
Parameter Sets: BySearchString
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://developer.sophos.com/getting-started](https://developer.sophos.com/getting-started)


---
external help file: SophosCentral-help.xml
Module Name: SophosCentral
online version: https://developer.sophos.com/getting-started-tenant
schema: 2.0.0
---

# Connect-SophosCentral

## SYNOPSIS
Connect to Sophos Central using your client ID and client secret, from you API credentials/service principal

## SYNTAX

```
Connect-SophosCentral [-ClientID] <String> [[-ClientSecret] <SecureString>] [-AccessTokenOnly]
 [<CommonParameters>]
```

## DESCRIPTION
Connect to Sophos Central using your client ID and client secret, from you API credentials/service principal

Sophos customers can connect to their tenant using a client id/secret.
Follow Step 1 here to create it
https://developer.sophos.com/getting-started-tenant

Sophos partners can use a partner client id/secret here to connect to the customers.
Follow Step 1 here to create it
https://developer.sophos.com/getting-started

## EXAMPLES

### EXAMPLE 1
```
Connect-SophosCentral -ClientID "asdkjsdfksjdf" -ClientSecret (Read-Host -AsSecureString -Prompt "Client Secret:")
```

## PARAMETERS

### -ClientID
The client ID from the Sophos Central API credential/service principal

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientSecret
The client secret from the Sophos Central API credential/service principal

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AccessTokenOnly
Internal use (for this module) only.
Used to generate a new access token, when the current one expires

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://developer.sophos.com/getting-started-tenant](https://developer.sophos.com/getting-started-tenant)

[https://developer.sophos.com/getting-started](https://developer.sophos.com/getting-started)


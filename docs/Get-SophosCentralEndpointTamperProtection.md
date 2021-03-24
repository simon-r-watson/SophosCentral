---
external help file: SophosCentral-help.xml
Module Name: SophosCentral
online version: https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoints/%7BendpointId%7D/tamper-protection/get
schema: 2.0.0
---

# Get-SophosCentralEndpointTamperProtection

## SYNOPSIS
Get Tamper Protection Status

## SYNTAX

```
Get-SophosCentralEndpointTamperProtection [-EndpointID] <String[]> [<CommonParameters>]
```

## DESCRIPTION
Get Tamper Protection Status

## EXAMPLES

### EXAMPLE 1
```
Get-SophosCentralEndpointTamperProtection -EndpointID '23a920fa-9a34-4869-bc3d-a1626e50f670'
```

### EXAMPLE 2
```
Get-SophosCentralEndpointTamperProtection -EndpointID (Get-SophosCentralEndpoints).ID
```

## PARAMETERS

### -EndpointID
The ID of the Endpoint.
Use Get-SophosCentralEndpoints to list them

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: ID

Required: True
Position: 1
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

[https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoints/%7BendpointId%7D/tamper-protection/get](https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoints/%7BendpointId%7D/tamper-protection/get)


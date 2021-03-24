---
external help file: SophosCentral-help.xml
Module Name: SophosCentral
online version: https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoints/%7BendpointId%7D/tamper-protection/post
schema: 2.0.0
---

# Set-SophosCentralEndpointTamperProtection

## SYNOPSIS
Update Tamper Protection settings

## SYNTAX

### Update Status
```
Set-SophosCentralEndpointTamperProtection -EndpointID <String[]> -Enabled <Boolean> [<CommonParameters>]
```

### Regenerate Password
```
Set-SophosCentralEndpointTamperProtection -EndpointID <String[]> [-RegeneratePassword] [<CommonParameters>]
```

## DESCRIPTION
Update Tamper Protection settings

## EXAMPLES

### EXAMPLE 1
```
Set-SophosCentralEndpointTamperProtection -EndpointID '23a920fa-9a34-4869-bc3d-a1626e50f670' -Enabled $false
```

### EXAMPLE 2
```
Set-SophosCentralEndpointTamperProtection -EndpointID '23a920fa-9a34-4869-bc3d-a1626e50f670' -RegeneratePassword
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
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Enabled
Use $true to enable Tamper Protection, $false to disable

```yaml
Type: Boolean
Parameter Sets: Update Status
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -RegeneratePassword
Use this switch to generate a new Tamper Protection password

```yaml
Type: SwitchParameter
Parameter Sets: Regenerate Password
Aliases:

Required: True
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

[https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoints/%7BendpointId%7D/tamper-protection/post](https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoints/%7BendpointId%7D/tamper-protection/post)


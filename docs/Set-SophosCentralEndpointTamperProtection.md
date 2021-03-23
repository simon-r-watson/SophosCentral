---
external help file: SophosCentral-help.xml
Module Name: SophosCentral
online version:
schema: 2.0.0
---

# Set-SophosCentralEndpointTamperProtection

## SYNOPSIS
Update Tamper Protection settings

## SYNTAX

### Status
```
Set-SophosCentralEndpointTamperProtection -EndpointID <String[]> -Enabled <Boolean> [<CommonParameters>]
```

### Password
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
{{ Fill EndpointID Description }}

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
{{ Fill Enabled Description }}

```yaml
Type: Boolean
Parameter Sets: Status
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -RegeneratePassword
{{ Fill RegeneratePassword Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Password
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

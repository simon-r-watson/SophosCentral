---
external help file: SophosCentral-help.xml
Module Name: SophosCentral
online version:
schema: 2.0.0
---

# Invoke-SophosCentralEndpointUpdate

## SYNOPSIS
Trigger a update on an Endpoint in Sophos Central

## SYNTAX

```
Invoke-SophosCentralEndpointUpdate [-EndpointID] <String[]> [<CommonParameters>]
```

## DESCRIPTION
Trigger a update on an Endpoint in Sophos Central

## EXAMPLES

### EXAMPLE 1
```
Invoke-SophosCentralEndpointUpdate -EndpointID "6d41e78e-0360-4de3-8669-bb7b797ee515"
```

### EXAMPLE 2
```
Invoke-SophosCentralEndpointUpdate -EndpointID (Get-SophosCentralEndpoints).ID
```

## PARAMETERS

### -EndpointID
{{ Fill EndpointID Description }}

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

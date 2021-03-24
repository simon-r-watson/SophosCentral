---
external help file: SophosCentral-help.xml
Module Name: SophosCentral
online version: https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoints/%7BendpointId%7D/update-checks/post
schema: 2.0.0
---

# Invoke-SophosCentralEndpointUpdate

## SYNOPSIS
Trigger an update on an Endpoint in Sophos Central

## SYNTAX

```
Invoke-SophosCentralEndpointUpdate [-EndpointID] <String[]> [<CommonParameters>]
```

## DESCRIPTION
Trigger an update on an Endpoint in Sophos Central

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

[https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoints/%7BendpointId%7D/update-checks/post](https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoints/%7BendpointId%7D/update-checks/post)


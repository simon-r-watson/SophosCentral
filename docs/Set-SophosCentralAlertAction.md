---
external help file: SophosCentral-help.xml
Module Name: SophosCentral
online version:
schema: 2.0.0
---

# Set-SophosCentralAlertAction

## SYNOPSIS
Trigger a scan on Endpoints in Sophos Central

## SYNTAX

```
Set-SophosCentralAlertAction [-AlertID] <String[]> [-Action] <String> [[-message] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Trigger a scan on Endpoints in Sophos Central

## EXAMPLES

### EXAMPLE 1
```
Set-SophosCentralAlertAction. -AlertID "6d41e78e-0360-4de3-8669-bb7b797ee515" -Action "clearThreat"
```

## PARAMETERS

### -AlertID
{{ Fill AlertID Description }}

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

### -Action
The alert action to perform.
To get the possible actions for an alert, check it the results from Get-SophosCentralAlerts

The action must be in the same capitalization as listed, otherwise it will fail

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -message
{{ Fill message Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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

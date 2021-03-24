---
external help file: SophosCentral-help.xml
Module Name: SophosCentral
online version: https://developer.sophos.com/docs/common-v1/1/routes/alerts/%7BalertId%7D/actions/post
schema: 2.0.0
---

# Set-SophosCentralAlertAction

## SYNOPSIS
Update an alert in Sophos Central

## SYNTAX

```
Set-SophosCentralAlertAction [-AlertID] <String[]> [-Action] <String> [[-Message] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Update an alert in Sophos Central

## EXAMPLES

### EXAMPLE 1
```
Set-SophosCentralAlertAction. -AlertID "6d41e78e-0360-4de3-8669-bb7b797ee515" -Action "clearThreat"
```

## PARAMETERS

### -AlertID
The ID of the alert.
Use Get-SophosCentralAlerts to list them

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
To get the possible actions for an alert, check the results from Get-SophosCentralAlerts

The action must be in the same capitalization as listed, otherwise it will fail

Possible options: 'acknowledge', 'cleanPua', 'cleanVirus', 'authPua', 'clearThreat', 'clearHmpa', 'sendMsgPua', 'sendMsgThreat'

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

### -Message
{{ Fill Message Description }}

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

[https://developer.sophos.com/docs/common-v1/1/routes/alerts/%7BalertId%7D/actions/post](https://developer.sophos.com/docs/common-v1/1/routes/alerts/%7BalertId%7D/actions/post)


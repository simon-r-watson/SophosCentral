---
external help file: SophosCentral-help.xml
Module Name: SophosCentral
online version: https://developer.sophos.com/docs/common-v1/1/routes/directory/users/post
schema: 2.0.0
---

# New-SophosCentralUser

## SYNOPSIS
Create a new user in Sophos Central

## SYNTAX

```
New-SophosCentralUser [-Name] <String> [[-FirstName] <String>] [[-LastName] <String>] [[-Email] <String>]
 [[-ExchangeLogin] <String>] [[-GroupIDs] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Create a new user in Sophos Central

## EXAMPLES

### EXAMPLE 1
```
New-SophosCentralUser -Name "John Smith" -FirstName "John" -LastName "Smith" -Email "jsmith@contoso.com"
```

## PARAMETERS

### -Name
This parameter is mandatory

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

### -FirstName
{{ Fill FirstName Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LastName
{{ Fill LastName Description }}

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

### -Email
{{ Fill Email Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExchangeLogin
{{ Fill ExchangeLogin Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GroupIDs
A list/array of group ID's to add them to.
To determine the ID of the groups use Get-SophosCentralUserGroups

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
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

[https://developer.sophos.com/docs/common-v1/1/routes/directory/users/post](https://developer.sophos.com/docs/common-v1/1/routes/directory/users/post)


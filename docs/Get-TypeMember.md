---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version:
schema: 2.0.0
---

# Get-TypeMember

## SYNOPSIS

Get type member information.

## SYNTAX

### member (Default)

```yaml
Get-TypeMember [-TypeName] <Type> [-MemberType <String>] [<CommonParameters>]
```

### static

```yaml
Get-TypeMember [-TypeName] <Type> [-StaticOnly] [<CommonParameters>]
```

### name

```yaml
Get-TypeMember [-TypeName] <Type> -MemberName <String> [<CommonParameters>]
```

## DESCRIPTION

This is an alternative to using Get-Member.
Specify a type name to see a simple view of an object's members.
The output will only show native members, including static methods, but not those added by PowerShell such as ScriptProperties.
The command in this module includes custom format and type extensions. See help examples.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Get-TypeMember DateTime

Type: System.DateTime

    Name                 MemberType ResultType   IsStatic
    ----                 ---------- ----------   --------
    MaxValue             Field      datetime         True
    MinValue             Field      datetime         True
    UnixEpoch            Field      datetime         True
    Add                  Method     DateTime        False
    AddDays              Method     DateTime        False
    AddHours             Method     DateTime        False
    ...
    Date                 Property   DateTime
    Day                  Property   Int32
    DayOfWeek            Property   DayOfWeek
    DayOfYear            Property   Int32
    Hour                 Property   Int32
    ...
```

Static items will be shown in green.

### EXAMPLE 2

```powershell
PS C:\> Get-TypeMember DateTime -StaticOnly

Type: System.DateTime

    Name            MemberType ResultType IsStatic
    ----            ---------- ---------- --------
    MaxValue        Field      datetime       True
    MinValue        Field      datetime       True
    UnixEpoch       Field      datetime       True
    Compare         Method     Int32          True
    DaysInMonth     Method     Int32          True
    ...
```

### EXAMPLE 3

```powershell
PS C:\> Get-TypeMember system.io.fileinfo -MemberType Property

Type: System.IO.FileInfo

    Name              MemberType ResultType     IsStatic
    ----              ---------- ----------     --------
    Attributes        Property   FileAttributes
    CreationTime      Property   DateTime
    CreationTimeUtc   Property   DateTime
    Directory         Property   DirectoryInfo
    DirectoryName     Property   String
    ...
```

Get only properties for System.IO.FileInfo.

### EXAMPLE

```powershell
PS C:\> Get-TypeMember datetime -MemberName add* | Format-Table -view syntax

        Type: System.DateTime

    Name            ReturnType Syntax
    ----            ---------- ------
    Add             DateTime   $obj.Add(\[TimeSpan\]value)
    AddDays         DateTime   $obj.AddDays(\[Double\]value)
    AddHours        DateTime   $obj.AddHours(\[Double\]value)
    AddMicroseconds DateTime   $obj.AddMicroseconds(\[Double\]value)
    AddMilliseconds DateTime   $obj.AddMilliseconds(\[Double\]value)
    AddMinutes      DateTime   $obj.AddMinutes(\[Double\]value)
    AddMonths       DateTime   $obj.AddMonths(\[Int32\]months)
    AddSeconds      DateTime   $obj.AddSeconds(\[Double\]value)
    AddTicks        DateTime   $obj.AddTicks(\[Int64\]value)
    AddYears        DateTime   $obj.AddYears(\[Int32\]value)
```

Use the custom table view to see method syntax.

### EXAMPLE

```powershell
PS C:\> Get-TypeMember system.io.path -static | Where-Object membertype -eq 'method' | Select-Object methodsyntax

Name                        ReturnType     IsStatic Syntax
----                        ----------     -------- ------
ChangeExtension             System.String      True $obj.ChangeExtension([Str...
Combine                     System.String      True {$obj.Combine([String[]]p...
GetDirectoryName            System.String      True $obj.GetDirectoryName([St...
GetExtension                System.String      True $obj.GetExtension([String...
GetFileName                 System.String      True $obj.GetFileName([String]...
GetFileNameWithoutExtension System.String      True $obj.GetFileNameWithoutEx...
GetFullPath                 System.String      True $obj.GetFullPath([String]...
...
```

MethodSyntax is a custom property set for Get-TypeMember output.

## PARAMETERS

### -TypeName

Specify a .NET type name like DateTime

```yaml
Type: Type
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StaticOnly

Get only static members.

```yaml
Type: SwitchParameter
Parameter Sets: static
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -MemberType

Filter for a specific member type.
Valid values are Property, Method, Event, and Field.

```yaml
Type: String
Parameter Sets: member
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MemberName

Specify a member name.

```yaml
Type: String
Parameter Sets: name
Aliases: Name

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: True
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### psTypeMember

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-Member]()

#requires -version 5.1

<#
This is an alternative function you can use in-place of Get-Member. This file and the
ps1xml file must be in the same folder. Dot-source the script file

PS C:\scripts\> . .\Get-TypeMember.ps1
#>

Function Get-MemberMethod {
    [cmdletbinding()]
    [OutputType('string')]
    [alias('gmm')]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipelineByPropertyName,
            HelpMessage = 'Specify the typename like System.Diagnostics.Process'
        )]
        [ValidateNotNullOrEmpty()]
        [alias('Type')]
        [type]$TypeName,
        [Parameter(
            Position = 1,
            Mandatory,
            ValueFromPipelineByPropertyName,
            HelpMessage = 'Specify the method name. The method name is case-sensitive'
        )]
        [alias('Name')]
        [string]$MethodName
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"

    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Processing method $MethodName from $($TypeName.Name)"

        $methods = $TypeName.GetMember($MethodName).Where({ $_.MemberType -eq 'method' })
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Found $($methods.count) overloads"
        foreach ($method in $methods) {
            $rType = $method.ReturnType.Name
            $params = foreach ($param in $method.GetParameters()) {
                '[{0}]{1}' -f $param.ParameterType.Name, $param.name
            }
            # This will include the return type
            # '{0} {1}({2})' -f $rtype, $method.Name, ($params -join ',')
            '$obj.{0}({1})' -f $method.Name, ($params -join ',')
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close Get-MemberMethod

Function Get-TypeMember {
    [cmdletbinding(DefaultParameterSetName = 'member')]
    [OutputType('psTypeMember')]
    [Alias('gtm')]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = 'Specify a .NET type name like DateTime'
        )]
        [ValidateNotNullOrEmpty()]
        [type]$TypeName,
        [Parameter(ParameterSetName = 'static', HelpMessage = 'Get only static members.')]
        [switch]$StaticOnly,
        [Parameter(ParameterSetName = 'member', HelpMessage = 'Filter for a specific member type.')]
        [ValidateSet('Property', 'Method', 'Event', 'Field')]
        [string]$MemberType,
        [Parameter(
            Mandatory,
            HelpMessage = "Specify a member name",
            ParameterSetName = "name"
        )]
        [SupportsWildCards()]
        [alias("Name")]
        [string]$MemberName
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"

        #define the appropriate filter
        if ($MemberName) {
            Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Filtering by member name $MemberName"
            $filter = { -Not $_.IsSpecialName -AND $_.Name -Like $MemberName}
        }
        elseif ($StaticOnly) {
            Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Filtering for Static methods"
            $filter = { -Not $_.IsSpecialName -AND $_.IsStatic }
        }
        elseif ($MemberType) {
            Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Filtering for $MemberType methods"
            $filter = { -Not $_.IsSpecialName -AND $_.MemberType -eq $MemberType }
        }
        else {
            Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Filtering for all non-special members"
            $filter = { -Not $_.IsSpecialName }
        }
    } #begin
    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Processing $($typename.name)"
        #Create the output
        $typeName.GetMembers() | Where-Object $filter |
        Select-Object -Property Name, MemberType, FieldType, PropertyType, ReturnType, IsStatic -Unique |
        Sort-Object -Property MemberType, Name |
        ForEach-Object {
            [PSCustomObject]@{
                PSTypeName   = 'psTypeMember'
                Type         = $typeName.FullName
                Name         = $_.Name
                MemberType   = $_.MemberType
                PropertyType = $_.PropertyType
                ReturnType   = $_.ReturnType
                FieldType    = $_.FieldType
                IsStatic     = $_.IsStatic
                Syntax       = Get-MemberMethod -Type $typename.FullName -MethodName $_.Name
            }
        } #Foreach-Object
    } #process
    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end
} #close function


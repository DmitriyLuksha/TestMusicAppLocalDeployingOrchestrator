[CmdletBinding()]
Param (
    [Parameter(Mandatory=$True)]
    [string]$ServerInstance,

    [Parameter(Mandatory=$True)]
    [string]$LoginName,

    [Parameter(Mandatory=$True)]
    [string]$DatabaseName
)

$ErrorActionPreference = "Stop";

Import-Module SqlServer;

Try {
    Get-SqlLogin -ServerInstance $ServerInstance -LoginName $LoginName | Out-Null;
    $IsLoginExists = $True;
}
Catch {
    $IsLoginExists = $False;
}

If ($IsLoginExists) {
    Write-Host "SQL Server login $LoginName already exists";
}
Else {
    Write-Host "Adding SQL Server login $LoginName";
    Add-SqlLogin -ServerInstance $ServerInstance -LoginName $LoginName -LoginType "WindowsUser" -DefaultDatabase $DatabaseName | Out-Null;
}
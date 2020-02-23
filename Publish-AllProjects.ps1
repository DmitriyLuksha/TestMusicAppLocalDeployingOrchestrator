[CmdletBinding()]
Param (
    [Parameter(Mandatory=$False)]
    [string]$ServerInstance
)

$ErrorActionPreference = "Stop";

$DatabaseConnectionString = ./Database/Format-DatabaseConnectionString.ps1 -ServerInstance $ServerInstance;
$MSNuildPath = "C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe";
$DBProjFilePath = [System.IO.Path]::GetFullPath("$PSScriptRoot\..\TestMusicAppDb\TestMusicAppDb.sqlproj");

Write-Host "Deploying database";
Start-Process -Wait -FilePath $MSNuildPath -ArgumentList "/t:reBuild,deploy /p:TargetConnectionString=`"$DatabaseConnectionString`" /p:TargetDatabase=TestMusicApp `"$DBProjFilePath`""
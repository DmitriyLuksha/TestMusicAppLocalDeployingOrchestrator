[CmdletBinding()]
Param (
    [Parameter(Mandatory=$False)]
    [string]$ServerInstance = "localhost"
)

$ErrorActionPreference = "Stop";

[System.Environment]::SetEnvironmentVariable('TestMusicAppServerInstance', $ServerInstance, [System.EnvironmentVariableTarget]::User);

$DatabaseConnectionString = ./Database/Get-DatabaseConnectionString.ps1;
$DatabaseName = ./Database/Get-DatabaseName.ps1;
$SQLServerIISLoginName = "IIS APPPOOL\$DatabaseName";

New-Item -ItemType Directory -Path "Temp" -Force | Out-Null;

./Git/Copy-GitRepositories.ps1;

./Packages/Install-PowershellModules.ps1;
./Packages/Install-StorageEmulator.ps1;

./Start-AllTools.ps1;

./Database/Add-Database.ps1;

$IsDatabaseAccessible = ./Database/Test-DatabaseConnection.ps1 -ConnectionString $DatabaseConnectionString;

if (!$IsDatabaseAccessible) {
    Throw "Databse with connection string '$DatabaseConnectionString' isn't accessible. Please, check your SQL Server instance name and if it's different - provide the right one. Also make sure that database instance is up";
}

./Database/Add-SQLServerLogin.ps1 -LoginName $SQLServerIISLoginName;

../TestMusicAppServer/Scripts/Add-TestMusicAppServerToIIS.ps1
../TestMusicAppClient/Scripts/Install-Packages.ps1
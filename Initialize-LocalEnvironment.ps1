[CmdletBinding()]
Param (
    [Parameter(Mandatory=$False)]
    [string]$ServerInstance
)

$ErrorActionPreference = "Stop";

If (!$ServerInstance) {
    $ServerInstance = "localhost";
}

$DatabaseConnectionString = ./Database/Format-DatabaseConnectionString.ps1 -ServerInstance $ServerInstance;
$SQLServerIISLoginName = "IIS APPPOOL\TestMusicApp";
$DatabaseName = "TestMusicApp";

New-Item -ItemType Directory -Path "Temp" -Force | Out-Null;

./Git/Copy-GitRepositories.ps1;

./Packages/Install-PowershellModules.ps1;
./Packages/Install-StorageEmulator.ps1;
./Packages/Start-Executables.ps1;

./Database/Add-Database.ps1 -ServerInstance $ServerInstance -DatabaseName $DatabaseName;

$IsDatabaseAccessible = ./Database/Test-DatabaseConnection.ps1 -ConnectionString $DatabaseConnectionString;

if (!$IsDatabaseAccessible) {
    Throw "Databse with connection string '$DatabaseConnectionString' isn't accessible. Please, check your SQL Server instance name and if it's different - provide the right one. Also make sure that database instance is up";
}

./Database/Add-SQLServerLogin.ps1 -ServerInstance $ServerInstance -LoginName $SQLServerIISLoginName -DatabaseName $DatabaseName;

../TestMusicAppServer/Scripts/Add-TestMusicAppServerToIIS.ps1
../TestMusicAppClient/Scripts/Install-Packages.ps1
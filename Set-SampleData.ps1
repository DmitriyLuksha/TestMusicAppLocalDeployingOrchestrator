[CmdletBinding()]
Param (
    [Parameter(Mandatory=$False)]
    [string]$ServerInstance,

    [Parameter(Mandatory=$False)]
    [string]$StorageConnectionString
)

$ErrorActionPreference = "Stop";

If (!$StorageConnectionString) {
    $StorageConnectionString = "UseDevelopmentStorage=true"
}

$TracksStorageContainerName = "audiofiles";
$DatabaseConnectionString = ./Database/Format-DatabaseConnectionString.ps1 -ServerInstance $ServerInstance;

./SampleData/Copy-SampleTracks.ps1 -DestinationStorageConnectionString $StorageConnectionString -DestinationContainer $TracksStorageContainerName;
./SampleData/Set-TestSQLData -TracksStorageConnectionString $StorageConnectionString -TracksStorageContainerName $TracksStorageContainerName -DatabaseConnectionString $DatabaseConnectionString;
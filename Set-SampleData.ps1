<#
.DESCRIPTION
This script deletes all existing data and replaces it with the test data set
#>

[CmdletBinding()]
Param (
    [Parameter(Mandatory=$False)]
    [string]$StorageConnectionString
)

$ErrorActionPreference = "Stop";

If (!$StorageConnectionString) {
    $StorageConnectionString = "UseDevelopmentStorage=true";
}

$TracksStorageContainerName = "audiofiles";
$DatabaseConnectionString = ./Database/Get-DatabaseConnectionString.ps1;

./SampleData/Copy-SampleTracks.ps1 -DestinationStorageConnectionString $StorageConnectionString -DestinationContainer $TracksStorageContainerName;
./SampleData/Set-TestSQLData -TracksStorageConnectionString $StorageConnectionString -TracksStorageContainerName $TracksStorageContainerName -DatabaseConnectionString $DatabaseConnectionString;
[CmdletBinding()]
Param (
    [Parameter(Mandatory=$False)]
    [string]$SampleTracksSasToken = "?st=2020-01-01T00%3A00%3A00Z&se=2100-01-01T00%3A00%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fZZdzAYurtG5IJS1J%2FJhlFvZZG%2BupmAv%2FPU5TkD8KqY%3D",

    [Parameter(Mandatory=$False)]
    [string]$SampleTracksStorageAccountName = "testmusicapp",

    [Parameter(Mandatory=$False)]
    [string]$SampleTracksContainerName = "sampletracks",

    [Parameter(Mandatory=$True)]
    [string]$DestinationStorageConnectionString,

    [Parameter(Mandatory=$True)]
    [string]$DestinationContainer
)

$ErrorActionPreference = "Stop";

Import-Module Az.Storage;

$SourceStorageContext = New-AzStorageContext -StorageAccountName $SampleTracksStorageAccountName -SasToken $SampleTracksSasToken;
$DestinationStorageContext = New-AzStorageContext -ConnectionString $DestinationStorageConnectionString;

$IsDestinationContainerExists = Get-AzStorageContainer -Name $DestinationContainer -Context $DestinationStorageContext -ErrorAction Ignore;

If ($IsDestinationContainerExists) {
    Write-Host "Removing existing files from the destination container";
    Get-AzStorageBlob -Container $DestinationContainer -Context $DestinationStorageContext | Remove-AzStorageBlob;
}
Else {
    Write-Host "Creating container $DestinationContainer";
    New-AzStorageContainer -Name $DestinationContainer -Context $DestinationStorageContext | Out-Null;
}

$TempDirectory = "Temp/SampleTracks";

New-Item -ItemType Directory -Path $TempDirectory -Force | Out-Null;

#Temp copy is used because copying directly from the Azure into local storage emulator didn't work for me

Write-Host "Receiving list of tracks";
$Blobs = Get-AzStorageBlob -Container $SampleTracksContainerName -Context $SourceStorageContext;

Write-Host "Downloading tracks";
Foreach ($Blob in $Blobs) {
    Get-AzStorageBlobContent -Container $SampleTracksContainerName -Context $SourceStorageContext -Blob $Blob.Name -Destination $TempDirectory | Out-Null;
}

Write-Host "Uploading tracks in the destination folder";
Foreach ($Blob in $Blobs) {
    Set-AzStorageBlobContent -Container $DestinationContainer -Context $DestinationStorageContext -File "$TempDirectory\$($Blob.Name)" | Out-Null;
}

Write-Host "Removing temp files";
Remove-Item $TempDirectory -Recurse;
$ErrorActionPreference = "Stop";

Write-Host "Publishing database";
& "$PSScriptRoot\..\TestMusicAppDb\Scripts\Publish-Database.ps1";

Write-Host "Publishing server";
& "$PSScriptRoot\..\TestMusicAppServer\Scripts\Publish-Server.ps1";
$ErrorActionPreference = "Stop";

Write-Host "Publishing database";
& "$PSScriptRoot\..\TestMusicAppDb\Scripts\Publish-Database.ps1";
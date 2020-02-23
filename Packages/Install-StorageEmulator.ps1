$ErrorActionPreference = "Stop";

If (Test-Path "${Env:ProgramFiles(x86)}\Microsoft SDKs\Azure\Storage Emulator\") {
    Write-Host "Azure Storage Emulator already installed";
    Exit;
}

New-Item -ItemType Directory -Force -Path "$PSScriptRoot\..\Temp" | Out-Null;

$Uri = "https://go.microsoft.com/fwlink/?linkid=717179&clcid=0x409";

$OutFile = Split-Path -Path $PSScriptRoot -Parent;
$OutFile = "$OutFile\Temp\microsoftazurestorageemulator.msi";

Write-Host "Downloading Azure Storage Emulator";

Invoke-WebRequest -Uri $Uri -OutFile $OutFile;

Write-Host "Installing Azure Storage Emulator";

Start-Process msiexec.exe -Wait -ArgumentList "/I $OutFile /quiet";

Write-Host "Removing installer";

Remove-Item $OutFile
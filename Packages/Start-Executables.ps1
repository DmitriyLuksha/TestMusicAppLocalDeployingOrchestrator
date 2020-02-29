$ErrorActionPreference = "Stop";

Function Start-Executable($Path, $ToolName, $Arguments) {
    $NormalizedPath = [System.IO.Path]::GetFullPath($Path);

    If (Get-Process | ?{$_.Path -Eq $NormalizedPath}) {
        Write-Host "$ToolName already running";
    }
    Else {
        Write-Host "Starting $ToolName";
        Start-Process $NormalizedPath $Arguments;
    }
}

Start-Executable -Path "${Env:ProgramFiles(x86)}\Microsoft SDKs\Azure\Storage Emulator\AzureStorageEmulator.exe" -ToolName "Azure Storage Emulator" -Arguments "start";
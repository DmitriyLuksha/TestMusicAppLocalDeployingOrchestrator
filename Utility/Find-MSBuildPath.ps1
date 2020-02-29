$ErrorActionPreference = "Stop";

$VSWherePath = "${Env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe";

If (!(Test-Path $VSWherePath)) {
    Throw "Unable to find vswhere.exe at '$VSWherePath'";
}

$VSRoot = & $VSWherePath -Latest -Prerelease -Products * -Requires Microsoft.Component.MSBuild -Property installationPath;

If ($VSRoot) {
    $PossibleMSBuildRelativePaths = "MSBuild\Current\Bin\MSBuild.exe", "MSBuild\15.0\Bin\MSBuild.exe";
    
    ForEach ($Path in $PossibleMSBuildRelativePaths) {
        $MSBuildPath = Join-Path $VSRoot $Path;

        If ((Test-Path $MSBuildPath)) {
            Write-Host "Found MSBuild at '$MSBuildPath'";
            Return $MSBuildPath;
        }
    }

    Throw "Unable to find MSBuild.exe in '$VSRoot'";
}
Else {
    Throw "Unable to find Visual Studio installation path";
}
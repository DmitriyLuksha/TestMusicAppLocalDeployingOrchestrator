$ErrorActionPreference = "Stop";

Function Copy-GitRepository($RepositoryName) {
    If (!(Test-Path "$PSScriptRoot\..\..\$RepositoryName")) {
        Write-Host "Cloning $RepositoryName";
        git clone git@github.com:DmitriyLuksha/$RepositoryName.git ..\$RepositoryName;
    }
    Else {
        Write-Host "$RepositoryName already cloned";
    }
}

Copy-GitRepository "TestMusicAppServer";
Copy-GitRepository "TestMusicAppDb";
Copy-GitRepository "TestMusicAppClient";
Copy-GitRepository "TestMusicAppServices";
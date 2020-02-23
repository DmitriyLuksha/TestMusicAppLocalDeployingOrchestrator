$ErrorActionPreference = "Stop";

Function Install-PowershellModule($ModuleName, $IsPack = $False) {
    If ($IsPack) {
        $ModuleToCheck = "$ModuleName.*";
    }
    Else {
        $ModuleToCheck = $ModuleName;
    }

    If (Get-Module -ListAvailable -Name $ModuleToCheck) {
        Write-Host "Module $ModuleName already installed";
    }
    Else {
        Write-Host "Installing module $ModuleName";
        Install-Module -Name $ModuleName -AllowClobber;
    }
}

Install-PowershellModule -ModuleName "SqlServer";
Install-PowershellModule -ModuleName "Az" -IsPack = $True;
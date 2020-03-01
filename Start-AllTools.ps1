<#
.DESCRIPTION
This script starts all tools, required in order to make all projects work
#>

$ErrorActionPreference = "Stop";

./Packages/Start-Executables.ps1;
./Packages/Start-Services.ps1;
<#
.DESCRIPTION
This script runs all scripts to set up ready to use environment. You should call this script when you deploy this project in the first time or after major changes
#>

[CmdletBinding()]
Param (
    [Parameter(Mandatory=$False)]
    [Switch]$PreventSettingTestData,

    [Parameter(Mandatory=$True)]
    [String]$ServiceBusConnectionString,

    [Parameter(Mandatory=$True)]
    [String]$SignalRConnectionString
)

$ErrorActionPreference = "Stop";

./Initialize-LocalEnvironment.ps1;
./Start-AllTools.ps1;
./Set-Configs.ps1 -ServiceBusConnectionString $ServiceBusConnectionString -SignalRConnectionString $SignalRConnectionString;
./Publish-AllProjects.ps1;

If (!$PreventSettingTestData) {
    ./Set-SampleData.ps1;
}
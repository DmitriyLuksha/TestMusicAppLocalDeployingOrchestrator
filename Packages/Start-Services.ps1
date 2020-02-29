$ErrorActionPreference = "Stop";

Function Start-ServiceWithStatusCheck($ServiceName) {
    $Service = Get-Service -Name $ServiceName;

    If (!($Service) -or ($Service.Status -ne 'Running')) {
        Write-Host "Starting service $ServiceName";
        Start-Service $ServiceName;
    }
    Else {
        Write-Host "Service $ServiceName already started";
    }
}

Start-ServiceWithStatusCheck "FabricHostSvc";
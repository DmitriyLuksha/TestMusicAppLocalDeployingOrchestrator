Import-Module SqlServer;

$ServerInstance = & "$PSScriptRoot/Get-ServerInstance.ps1";
$DatabaseName = & "$PSScriptRoot/Get-DatabaseName.ps1"
$Server = New-Object Microsoft.SqlServer.Management.Smo.Server($ServerInstance);

$IsDatabaseExists = $False;
foreach ($Database in $Server.Databases) {
    if ($Database.name -eq $DatabaseName) {
        $IsDatabaseExists = $True;
    }
}

If ($IsDatabaseExists) {
    Write-Host "Database $DatabaseName already exists";
}
Else {
    Write-Host "Creating database $DatabaseName";

    $NewDatabase = New-Object Microsoft.SqlServer.Management.Smo.Database($Server, $DatabaseName);
    $NewDatabase.Create();
}
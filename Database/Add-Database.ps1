[CmdletBinding()]
Param (
    [Parameter(Mandatory=$True)]
    [string]$ServerInstance,

    [Parameter(Mandatory=$True)]
    [string]$DatabaseName
)

Import-Module SqlServer;

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
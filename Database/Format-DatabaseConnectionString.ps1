[CmdletBinding()]
Param (
    [Parameter(Mandatory=$False)]
    [string]$ServerInstance
)

If (!$ServerInstance) {
    $ServerInstance = "localhost";
}

Return "Data Source=$ServerInstance;Integrated Security=SSPI;Initial Catalog=TestMusicApp";
[CmdletBinding()]
Param (
    [Parameter(Mandatory=$True)]
    [string]$ConnectionString
)

Try
{
    $SqlConnection = New-Object System.Data.SqlClient.SqlConnection
    $SqlConnection.ConnectionString = $ConnectionString;
    $SqlConnection.Open() 
    
    $IsOpen = $SqlConnection.State -eq "Open";

    $SqlConnection.Close()

    return $IsOpen;
}
Catch
{
    Return $False;
}
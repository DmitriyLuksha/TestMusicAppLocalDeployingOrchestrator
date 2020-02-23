[CmdletBinding()]
Param (
    [Parameter(Mandatory=$True)]
    [string]$TracksStorageConnectionString,

    [Parameter(Mandatory=$True)]
    [string]$TracksStorageContainerName,

    [Parameter(Mandatory=$True)]
    [string]$DatabaseConnectionString
)

$ErrorActionPreference = "Stop";

Import-Module Az.Storage;

Function Clear-Database($SqlConnection) {
    $DisableConstraintsCmd = $SqlConnection.CreateCommand();
    $DisableConstraintsCmd.CommandText = "EXEC sp_MSForEachTable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'";
    $DisableConstraintsCmd.ExecuteNonQuery() | Out-Null;

    $CleanDatabaseCmd = $SqlConnection.CreateCommand();
    $CleanDatabaseCmd.CommandText = "EXEC sp_MSForEachTable 'DELETE FROM ?'";
    $CleanDatabaseCmd.ExecuteNonQuery() | Out-Null;

    $EnableConstraintsCmd = $SqlConnection.CreateCommand();
    $EnableConstraintsCmd.CommandText = "EXEC sp_MSForEachTable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL'";
    $EnableConstraintsCmd.ExecuteNonQuery() | Out-Null;
}

Function Add-TestUsers($SqlConnection) {
    $AddTestUsersCmd = $SqlConnection.CreateCommand();
    $AddTestUsersCmd.CommandText = "EXEC AddTestUsers";
    $AddTestUsersCmd.ExecuteNonQuery() | Out-Null;
}

Function Add-TestPlaylists($SqlConnection) {
    $AddTestPlaylistsCmd = $SqlConnection.CreateCommand();
    $AddTestPlaylistsCmd.CommandText = "EXEC AddTestPlaylists";
    $AddTestPlaylistsCmd.ExecuteNonQuery() | Out-Null;
}

Function Add-TestTracks($SqlConnection, $TrackBlobs) {
    $TracksTable = New-Object System.Data.DataTable;
    $TracksTable.Columns.Add("TrackFileName", "System.String") | Out-Null;

    Foreach ($TrackBlob In $TrackBlobs) {
        $Row = $TracksTable.NewRow();
        $Row.TrackFileName = $TrackBlob.Name;
        $TracksTable.Rows.Add($Row);
    }

    $AddTestTracksCmd = $SqlConnection.CreateCommand();
    $AddTestTracksCmd.CommandText = "AddTestTracks";
    $AddTestTracksCmd.CommandType = [System.Data.CommandType]::StoredProcedure;

    $TrackFileNamesParam = New-Object System.Data.SqlClient.SqlParameter;
    $TrackFileNamesParam.ParameterName = "trackFileNames";
    $TrackFileNamesParam.SqlDbType = [System.Data.SqlDbType]::Structured;
    $TrackFileNamesParam.Direction = [System.Data.ParameterDirection]::Input;
    $TrackFileNamesParam.Value = $TracksTable;

    $AddTestTracksCmd.Parameters.Add($TrackFileNamesParam) | Out-Null;

    $AddTestTracksCmd.ExecuteNonQuery() | Out-Null;
}

Write-Host "Receiving list of tracks";
$StorageContext = New-AzStorageContext -ConnectionString $TracksStorageConnectionString;
$Blobs = Get-AzStorageBlob -Context $StorageContext -Container $TracksStorageContainerName;

Write-Host "Opening database connection";
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection;
$SqlConnection.ConnectionString = $DatabaseConnectionString;
$SqlConnection.Open();

Write-Host "Clearing database";
Clear-Database $SqlConnection;

Write-Host "Adding test users";
Add-TestUsers $SqlConnection;

Write-Host "Adding test playlists";
Add-TestPlaylists $SqlConnection;

Write-Host "Adding test tracks";
Add-TestTracks $SqlConnection $Blobs;

$SqlConnection.Close();
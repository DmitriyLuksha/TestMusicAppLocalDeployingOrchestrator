$ServerInstance = [System.Environment]::GetEnvironmentVariable('TestMusicAppServerInstance', [System.EnvironmentVariableTarget]::User);
Return $ServerInstance;
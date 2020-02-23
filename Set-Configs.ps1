[CmdletBinding()]
Param (
    [Parameter(Mandatory=$False)]
    [string]$ServerInstance,

    [Parameter(Mandatory=$True)]
    [string]$ServiceBusConnectionString,

    [Parameter(Mandatory=$True)]
    [string]$SignalRConnectionString,

    [Parameter(Mandatory=$False)]
    [string]$StorageConnectionString,

    [Parameter(Mandatory=$False)]
    [string]$ServerApplicationInsightsInstrumentationKey,

    [Parameter(Mandatory=$False)]
    [string]$AudioConverterInstrumentationKey,

    [Parameter(Mandatory=$False)]
    [string]$YoutubeConverterInstrumentationKey
)

$ErrorActionPreference = "Stop";

If (!$ServerInstance) {
    $ServerInstance = "localhost";
}

If (!$StorageConnectionString) {
    $StorageConnectionString = "UseDevelopmentStorage=true"
}

$DatabaseConnectionString = ./Database/Format-DatabaseConnectionString.ps1 -ServerInstance $ServerInstance;
$AudioConversionQueueName = "audioconversion";
$YoutubeConversionQueueName = "youtubeconversion";
$AudioUploadingResultQueueName = "audiouploadingresult";
$AudioFilesContainerName = "audiofiles";
$UnprocessedAudioFilesContainerName = "unprocessedaudiofiles";

$ServerConfigParams = @{
    'DatabaseConnectionString' = $DatabaseConnectionString;
    'ServiceBusConnectionString' = $ServiceBusConnectionString;
    'SignalRConnectionString' = $SignalRConnectionString;
    'StorageConnectionString' = $StorageConnectionString;
    'AudioConversionQueueName' = $AudioConversionQueueName;
    'YoutubeConversionQueueName' = $YoutubeConversionQueueName;
    'AudioUploadingResultQueueName' = $AudioUploadingResultQueueName;
    'AudioFilesContainerName' = $AudioFilesContainerName;
    'UnprocessedAudioFilesContainerName' = $UnprocessedAudioFilesContainerName;
    'ApplicationInsightsInstrumentationKey' = $ServerApplicationInsightsInstrumentationKey;
};

. $PSScriptRoot/../TestMusicAppServer/Scripts/Set-Config.ps1 @ServerConfigParams;

$ServicesConfigParams = @{
    'ServiceBusConnectionString' = $ServiceBusConnectionString;
    'AudioConversionQueueName' = $AudioConversionQueueName;
    'YoutubeConversionQueueName' = $YoutubeConversionQueueName;
    'AudioUploadingResultQueueName' = $AudioUploadingResultQueueName;
    'StorageConnectionString' = $StorageConnectionString;
    'AudioFilesContainerName' = $AudioFilesContainerName;
    'UnprocessedAudioFilesContainerName' = $UnprocessedAudioFilesContainerName;
    'AudioConverterInstrumentationKey' = $AudioConverterInstrumentationKey;
    'YoutubeConverterInstrumentationKey' = $YoutubeConverterInstrumentationKey;
};

. $PSScriptRoot/../TestMusicAppServices/Scripts/Set-Config.ps1 @ServicesConfigParams;
-- Run on SQL server
DECLARE 
        --@Start DATE = DATEADD(DAY, -2, GETUTCDATE()),
        --@Start DATE = DATEADD(YEAR, -1, GETUTCDATE()),
        @Start DATETIME = '2026-06-09',
        @End DATETIME = '2026-06-11',
        @Start2 DATETIME = '2026-02-07',
        @End2 DATETIME = '2026-02-11',
        --@End DATE = DATEADD(DAY, 1, GETUTCDATE()),
        @DeviceFilter varchar(10) = 'true',
        @Device varchar(10) = '83034';
WITH CombinedData AS (
  -- Collect Data from each table and combine it.
    SELECT
      dbaudit.[RevisionStamp]
      ,dbaudit.[TableName]
      ,dbaudit.[OperatorName]
      ,dbaudit.[StationName]
      ,dbaudit.[Actions]
      ,devicevw.[Deviceid]
      ,dbaudit.[Description]
      ,[Ca4kdb] = '01 - Live Events'
      ,CONVERT(VARCHAR(MAX), dbaudit.[OldData]) AS OldData
      ,CONVERT(VARCHAR(MAX), dbaudit.[NewData]) AS NewData
      FROM [CardAccessliveeventsPH].[dbo].[DBAudit] dbaudit
        LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[ca_vw_DeviceList] AS devicevw ON dbaudit.[caObjectID] = devicevw.[caObjectID]
        WHERE dbaudit.[Actions] IN ('U','D','I')
        AND dbaudit.[TableName] IN ('Reader')
        AND (@DeviceFilter <> 'True' OR dbaudit.[Description] LIKE '%' + @Device + '%')
        --AND OperatorName NOT IN ('cic','admin','BLOOMINGTON\SQLPROXYENT')
        AND [RevisionStamp] BETWEEN @Start and @End
  UNION ALL
    SELECT
      dbaudit.[RevisionStamp]
      ,dbaudit.[TableName]
      ,dbaudit.[OperatorName]
      ,dbaudit.[StationName]
      ,dbaudit.[Actions]
      ,devicevw.[Deviceid]
      ,dbaudit.[Description]
      ,[Ca4kdb] = '02 - Live Config'
      ,CONVERT(VARCHAR(MAX), dbaudit.[OldData]) AS OldData
      ,CONVERT(VARCHAR(MAX), dbaudit.[NewData]) AS NewData
      FROM [CardAccessliveConfigurationPH].[dbo].[DBAudit] dbaudit
        LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[ca_vw_DeviceList] AS devicevw ON dbaudit.[caObjectID] = devicevw.[caObjectID]
        WHERE dbaudit.[Actions] IN ('U','D','I')
        AND dbaudit.[TableName] IN ('Reader')
        AND (@DeviceFilter <> 'True' OR dbaudit.[Description] LIKE '%' + @Device + '%')
        --AND OperatorName NOT IN ('cic','admin','BLOOMINGTON\SQLPROXYENT')
        AND dbaudit.[RevisionStamp] BETWEEN @Start and @End
  UNION ALL
    SELECT
      dbaudit.[RevisionStamp]
      ,dbaudit.[TableName]
      ,dbaudit.[OperatorName]
      ,dbaudit.[StationName]
      ,dbaudit.[Actions]
      ,devicevw.[Deviceid]
      ,dbaudit.[Description]
      ,[Ca4kdb] = '03 - Archive Events'
      ,CONVERT(VARCHAR(MAX), dbaudit.[OldData]) AS OldData
      ,CONVERT(VARCHAR(MAX), dbaudit.[NewData]) AS NewData
      FROM [CardAccessarchiveeventsPH].[dbo].[DBAudit] dbaudit
        LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[ca_vw_DeviceList] AS devicevw ON dbaudit.[caObjectID] = devicevw.[caObjectID]
        WHERE [Actions] IN ('U','D','I')
        AND dbaudit.[TableName] IN ('Reader')
        AND (@DeviceFilter <> 'True' OR dbaudit.[Description] LIKE '%' + @Device + '%')
        --AND OperatorName NOT IN ('cic','admin','BLOOMINGTON\SQLPROXYENT')
        AND dbaudit.[RevisionStamp] BETWEEN @Start and @End
  UNION ALL
    SELECT
      dbaudit.[RevisionStamp]
      ,dbaudit.[TableName]
      ,dbaudit.[OperatorName]
      ,dbaudit.[StationName]
      ,dbaudit.[Actions]
      ,devicevw.[Deviceid]
      ,dbaudit.[Description]
      ,[Ca4kdb] ='04 - Archive Config'
      ,CONVERT(VARCHAR(MAX), dbaudit.[OldData]) AS OldData
      ,CONVERT(VARCHAR(MAX), dbaudit.[NewData]) AS NewData
      FROM [CardAccessarchiveConfigurationPH].[dbo].[DBAudit] dbaudit
        LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[ca_vw_DeviceList] AS devicevw ON dbaudit.[caObjectID] = devicevw.[caObjectID]
        WHERE dbaudit.[Actions] IN ('U','D','I')
        AND dbaudit.[TableName] IN ('Reader')
        AND (@DeviceFilter <> 'True' OR dbaudit.[Description] LIKE '%' + @Device + '%')
        --AND OperatorName NOT IN ('cic','admin','BLOOMINGTON\SQLPROXYENT')
        AND dbaudit.[RevisionStamp] BETWEEN @Start and @End
  UNION ALL
    SELECT
      dbaudit.[RevisionStamp]
      ,dbaudit.[TableName]
      ,dbaudit.[OperatorName]
      ,dbaudit.[StationName]
      ,dbaudit.[Actions]
      ,devicevw.[Deviceid]
      ,dbaudit.[Description]
      ,[Ca4kdb] = '05 - Archive Events_2'
      ,CONVERT(VARCHAR(MAX), dbaudit.[OldData]) AS OldData
      ,CONVERT(VARCHAR(MAX), dbaudit.[NewData]) AS NewData
      FROM [CardAccessarchiveeventsPH_2].[dbo].[DBAudit] dbaudit
      LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[ca_vw_DeviceList] AS devicevw ON dbaudit.[caObjectID] = devicevw.[caObjectID]
        WHERE [Actions] IN ('U','D','I')
        AND dbaudit.[TableName] IN ('Reader')
        AND (@DeviceFilter <> 'True' OR dbaudit.[Description] LIKE '%' + @Device + '%')
        --AND OperatorName NOT IN ('cic','admin','BLOOMINGTON\SQLPROXYENT')
        AND dbaudit.[RevisionStamp] BETWEEN @Start and @End
)

SELECT
  CASE
    WHEN [Actions] = 'U' THEN 'Update'
    WHEN [Actions] = 'D' THEN 'Delete'
    WHEN [Actions] = 'I' THEN 'Insert'
    Else [Actions]
  END 'Action'
  ,[Description]
  ,[Deviceid]
  ,[OperatorName]
   -- Original Format Get the Old Data and format it as 00-00-00 for 'Old Inp-Byp-Str'
      --SUBSTRING(OldData, CHARINDEX('Sensor="', OldData) + 8, 2) + '-' + SUBSTRING(OldData, CHARINDEX('Bypass="', OldData) + 8, 2) + '-' + SUBSTRING(OldData, CHARINDEX('Strike="', OldData) + 8, 2) 'Old Inp-Byp-Str',  
   -- Get the Old Data and format it as 00-00-00 for 'Old Inp-Byp-Str'
    ,RIGHT('00' + SUBSTRING(OldData, CHARINDEX('Sensor="', OldData) + 8, CHARINDEX('"', OldData, CHARINDEX('Sensor="', OldData) + 8) - (CHARINDEX('Sensor="', OldData) + 8)), 2) + '-' +
    RIGHT('00' + SUBSTRING(OldData, CHARINDEX('Bypass="', OldData) + 8, CHARINDEX('"', OldData, CHARINDEX('Bypass="', OldData) + 8) - (CHARINDEX('Bypass="', OldData) + 8)), 2) + '-' +
    RIGHT('00' + SUBSTRING(OldData, CHARINDEX('Strike="', OldData) + 8, CHARINDEX('"', OldData, CHARINDEX('Strike="', OldData) + 8) - (CHARINDEX('Strike="', OldData) + 8)), 2) 'Old Inp-Byp-Str'
   -- Original Format Get the New Data and format it as 00-00-00 for 'New Inp-Byp-Str'
      --SUBSTRING(NewData, CHARINDEX('Sensor="', NewData) + 8, 2) + '-' + SUBSTRING(NewData, CHARINDEX('Bypass="', NewData) + 8, 2) + '-' + SUBSTRING(NewData, CHARINDEX('Strike="', NewData) + 8, 2) 'New Inp-Byp-Str',
   -- Get the New Data and format it as 00-00-00 for 'New Inp-Byp-Str'
    ,RIGHT('00' + SUBSTRING(NewData, CHARINDEX('Sensor="', NewData) + 8, CHARINDEX('"', NewData, CHARINDEX('Sensor="', NewData) + 8) - (CHARINDEX('Sensor="', NewData) + 8)), 2) + '-' +
    RIGHT('00' + SUBSTRING(NewData, CHARINDEX('Bypass="', NewData) + 8, CHARINDEX('"', NewData, CHARINDEX('Bypass="', NewData) + 8) - (CHARINDEX('Bypass="', NewData) + 8)), 2) + '-' +
    RIGHT('00' + SUBSTRING(NewData, CHARINDEX('Strike="', NewData) + 8, CHARINDEX('"', NewData, CHARINDEX('Strike="', NewData) + 8) - (CHARINDEX('Strike="', NewData) + 8)), 2) 'New Inp-Byp-Str'
  ,[RevisionStamp]
  ,DATEADD(HH,-5, RevisionStamp) 'EDAte -5'
  ,[Ca4kdb]
    --,[TableName]
    --,[ChangedColumns]
    ,[OldData]
    ,[NewData]

FROM CombinedData
  WHERE [OperatorName] <> 'cic'
  ORDER BY RevisionStamp ASC, [Deviceid];
/*
WITH CombinedData2 AS (
  -- Collect Data from each table and combine it.
    SELECT
      dbaudit.[RevisionStamp]
      ,dbaudit.[TableName]
      ,dbaudit.[OperatorName]
      ,dbaudit.[StationName]
      ,dbaudit.[Actions]
      ,devicevw.[Deviceid]
      ,dbaudit.[Description]
      --,[ChangedColumns]
      ,CONVERT(VARCHAR(MAX), dbaudit.[OldData]) AS OldData
      ,CONVERT(VARCHAR(MAX), dbaudit.[NewData]) AS NewData
      FROM [CardAccessliveeventsPH].[dbo].[DBAudit] dbaudit
        LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[ca_vw_DeviceList] AS devicevw ON dbaudit.[caObjectID] = devicevw.[caObjectID]
        WHERE dbaudit.[Actions] IN ('U','D','I')
        AND dbaudit.[TableName] IN ('Reader')
        AND (@DeviceFilter <> 'True' OR dbaudit.[Description] LIKE '%' + @Device + '%')
        --AND OperatorName NOT IN ('cic','admin','BLOOMINGTON\SQLPROXYENT')
        AND [RevisionStamp] BETWEEN @Start2 and @End2
  UNION ALL
    SELECT
      dbaudit.[RevisionStamp]
      ,dbaudit.[TableName]
      ,dbaudit.[OperatorName]
      ,dbaudit.[StationName]
      ,dbaudit.[Actions]
      ,devicevw.[Deviceid]
      ,dbaudit.[Description]
      --,[ChangedColumns]
      ,CONVERT(VARCHAR(MAX), dbaudit.[OldData]) AS OldData
      ,CONVERT(VARCHAR(MAX), dbaudit.[NewData]) AS NewData
      FROM [CardAccessliveConfigurationPH].[dbo].[DBAudit] dbaudit
        LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[ca_vw_DeviceList] AS devicevw ON dbaudit.[caObjectID] = devicevw.[caObjectID]
        WHERE dbaudit.[Actions] IN ('U','D','I')
        AND dbaudit.[TableName] IN ('Reader')
        AND (@DeviceFilter <> 'True' OR dbaudit.[Description] LIKE '%' + @Device + '%')
        --AND OperatorName NOT IN ('cic','admin','BLOOMINGTON\SQLPROXYENT')
        AND dbaudit.[RevisionStamp] BETWEEN @Start2 and @End2
  UNION ALL
    SELECT
      dbaudit.[RevisionStamp]
      ,dbaudit.[TableName]
      ,dbaudit.[OperatorName]
      ,dbaudit.[StationName]
      ,dbaudit.[Actions]
      ,devicevw.[Deviceid]
      ,dbaudit.[Description]
      --,[ChangedColumns]
      ,CONVERT(VARCHAR(MAX), dbaudit.[OldData]) AS OldData
      ,CONVERT(VARCHAR(MAX), dbaudit.[NewData]) AS NewData
      FROM [CardAccessarchiveeventsPH].[dbo].[DBAudit] dbaudit
        LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[ca_vw_DeviceList] AS devicevw ON dbaudit.[caObjectID] = devicevw.[caObjectID]
        WHERE [Actions] IN ('U','D','I')
        AND dbaudit.[TableName] IN ('Reader')
        AND (@DeviceFilter <> 'True' OR dbaudit.[Description] LIKE '%' + @Device + '%')
        --AND OperatorName NOT IN ('cic','admin','BLOOMINGTON\SQLPROXYENT')
        AND dbaudit.[RevisionStamp] BETWEEN @Start2 and @End2
  UNION ALL
    SELECT
      dbaudit.[RevisionStamp]
      ,dbaudit.[TableName]
      ,dbaudit.[OperatorName]
      ,dbaudit.[StationName]
      ,dbaudit.[Actions]
      ,devicevw.[Deviceid]
      ,dbaudit.[Description]
      --,[ChangedColumns]
      ,CONVERT(VARCHAR(MAX), dbaudit.[OldData]) AS OldData
      ,CONVERT(VARCHAR(MAX), dbaudit.[NewData]) AS NewData
      FROM [CardAccessarchiveConfigurationPH].[dbo].[DBAudit] dbaudit
        LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[ca_vw_DeviceList] AS devicevw ON dbaudit.[caObjectID] = devicevw.[caObjectID]
        WHERE dbaudit.[Actions] IN ('U','D','I')
        AND dbaudit.[TableName] IN ('Reader')
        AND (@DeviceFilter <> 'True' OR dbaudit.[Description] LIKE '%' + @Device + '%')
        --AND OperatorName NOT IN ('cic','admin','BLOOMINGTON\SQLPROXYENT')
        AND dbaudit.[RevisionStamp] BETWEEN @Start2 and @End2
  UNION ALL
    SELECT
      dbaudit.[RevisionStamp]
      ,dbaudit.[TableName]
      ,dbaudit.[OperatorName]
      ,dbaudit.[StationName]
      ,dbaudit.[Actions]
      ,devicevw.[Deviceid]
      ,dbaudit.[Description]
      --,[ChangedColumns]
      ,CONVERT(VARCHAR(MAX), dbaudit.[OldData]) AS OldData
      ,CONVERT(VARCHAR(MAX), dbaudit.[NewData]) AS NewData
      FROM [CardAccessarchiveeventsPH_2].[dbo].[DBAudit] dbaudit
      LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[ca_vw_DeviceList] AS devicevw ON dbaudit.[caObjectID] = devicevw.[caObjectID]
        WHERE [Actions] IN ('U','D','I')
        AND dbaudit.[TableName] IN ('Reader')
        AND (@DeviceFilter <> 'True' OR dbaudit.[Description] LIKE '%' + @Device + '%')
        --AND OperatorName NOT IN ('cic','admin','BLOOMINGTON\SQLPROXYENT')
        AND dbaudit.[RevisionStamp] BETWEEN @Start2 and @End2
)

SELECT TOP (4)
  CASE
    WHEN [Actions] = 'U' THEN 'Update'
    WHEN [Actions] = 'D' THEN 'Delete'
    WHEN [Actions] = 'I' THEN 'Insert'
    Else [Actions]
  END 'Action'
  ,[Description]
  ,[Deviceid]
  ,[OperatorName]
   -- Original Format Get the Old Data and format it as 00-00-00 for 'Old Inp-Byp-Str'
      --SUBSTRING(OldData, CHARINDEX('Sensor="', OldData) + 8, 2) + '-' + SUBSTRING(OldData, CHARINDEX('Bypass="', OldData) + 8, 2) + '-' + SUBSTRING(OldData, CHARINDEX('Strike="', OldData) + 8, 2) 'Old Inp-Byp-Str',  
   -- Get the Old Data and format it as 00-00-00 for 'Old Inp-Byp-Str'
  ,RIGHT('00' + SUBSTRING(OldData, CHARINDEX('Sensor="', OldData) + 8, CHARINDEX('"', OldData, CHARINDEX('Sensor="', OldData) + 8) - (CHARINDEX('Sensor="', OldData) + 8)), 2) + '-' +
    RIGHT('00' + SUBSTRING(OldData, CHARINDEX('Bypass="', OldData) + 8, CHARINDEX('"', OldData, CHARINDEX('Bypass="', OldData) + 8) - (CHARINDEX('Bypass="', OldData) + 8)), 2) + '-' +
    RIGHT('00' + SUBSTRING(OldData, CHARINDEX('Strike="', OldData) + 8, CHARINDEX('"', OldData, CHARINDEX('Strike="', OldData) + 8) - (CHARINDEX('Strike="', OldData) + 8)), 2) 'Old Inp-Byp-Str'
   -- Original Format Get the New Data and format it as 00-00-00 for 'New Inp-Byp-Str'
      --SUBSTRING(NewData, CHARINDEX('Sensor="', NewData) + 8, 2) + '-' + SUBSTRING(NewData, CHARINDEX('Bypass="', NewData) + 8, 2) + '-' + SUBSTRING(NewData, CHARINDEX('Strike="', NewData) + 8, 2) 'New Inp-Byp-Str',
   -- Get the New Data and format it as 00-00-00 for 'New Inp-Byp-Str'
  ,RIGHT('00' + SUBSTRING(NewData, CHARINDEX('Sensor="', NewData) + 8, CHARINDEX('"', NewData, CHARINDEX('Sensor="', NewData) + 8) - (CHARINDEX('Sensor="', NewData) + 8)), 2) + '-' +
    RIGHT('00' + SUBSTRING(NewData, CHARINDEX('Bypass="', NewData) + 8, CHARINDEX('"', NewData, CHARINDEX('Bypass="', NewData) + 8) - (CHARINDEX('Bypass="', NewData) + 8)), 2) + '-' +
    RIGHT('00' + SUBSTRING(NewData, CHARINDEX('Strike="', NewData) + 8, CHARINDEX('"', NewData, CHARINDEX('Strike="', NewData) + 8) - (CHARINDEX('Strike="', NewData) + 8)), 2) 'New Inp-Byp-Str'
  ,[RevisionStamp]
  ,DATEADD(HH,-5, RevisionStamp) 'EDAte -5'
  --,[TableName]
  --,[ChangedColumns]
  --,[OldData]
  --,[NewData]

FROM CombinedData2
  --WHERE [OperatorName] = 'LoganElam'
  ORDER BY RevisionStamp DESC;*/
DECLARE @Databases TABLE (DBName VARCHAR(100));

-- Set the following variables
DECLARE 
  @Start DATETIME = '2026-06-18',
  @End DATETIME = '2026-06-19',
  @DeviceFilter varchar(10) = 'false',
  @Device varchar(10) = '83034',
  @liveConfig NVARCHAR(100) = 'ExampleLiveConfiguration';

-- Add your list of databases
INSERT INTO @Databases (DBName) VALUES
('ExampleLiveEventsDB'),
('ExampleArchiveEventsDB'),
('ExampleArchiveEventsDB_2');

-- Setup for dynamic SQL loop
DECLARE 
  @SQL NVARCHAR(MAX) = 'WITH CombinedData AS (' + CHAR(10),
  @First BIT = 1;

SELECT @SQL = @SQL +
CASE 
  WHEN @First = 1 THEN N'' 
  ELSE CHAR(10) + N'UNION ALL '
END +
'SELECT
  [RevisionStamp]
  ,[TableName]
  ,[OperatorName]
  ,[StationName]
  ,[Actions]
  ,[Description]
  ,[caObjectID]
  ,CONVERT(VARCHAR(MAX), [OldData]) AS OldData
  ,CONVERT(VARCHAR(MAX), [NewData]) AS NewData
  FROM ' + QUOTENAME(DBName) + '.[dbo].[DBAudit]
    WHERE [Actions] IN (''U'',''D'',''I'')
    AND [TableName] IN (''Reader'')
    AND (@DeviceFilter <> ''True'' OR [Description] LIKE ''%'' + @Device + ''%'')
    AND [RevisionStamp] BETWEEN @Start and @End',
@First = 0
FROM @Databases;

SET @SQL = @SQL + CHAR(10) + N')
SELECT
  CASE
    WHEN cd.[Actions] = ''U'' THEN ''Update''
    WHEN cd.[Actions] = ''D'' THEN ''Delete''
    WHEN cd.[Actions] = ''I'' THEN ''Insert''
    Else cd.[Actions]
  END ''Action''
  ,cd.[Description]
  ,devicevw.[Deviceid]
  ,cd.[OperatorName]
    ,RIGHT(''00'' + SUBSTRING(cd.[OldData], CHARINDEX(''Sensor="'', cd.[OldData]) + 8, CHARINDEX(''"'', cd.[OldData], CHARINDEX(''Sensor="'', cd.[OldData]) + 8) - (CHARINDEX(''Sensor="'', cd.[OldData]) + 8)), 2) + ''-'' +
    RIGHT(''00'' + SUBSTRING(cd.[OldData], CHARINDEX(''Bypass="'', cd.[OldData]) + 8, CHARINDEX(''"'', cd.[OldData], CHARINDEX(''Bypass="'', cd.[OldData]) + 8) - (CHARINDEX(''Bypass="'', cd.[OldData]) + 8)), 2) + ''-'' +
    RIGHT(''00'' + SUBSTRING(cd.[OldData], CHARINDEX(''Strike="'', cd.[OldData]) + 8, CHARINDEX(''"'', cd.[OldData], CHARINDEX(''Strike="'', cd.[OldData]) + 8) - (CHARINDEX(''Strike="'', cd.[OldData]) + 8)), 2) ''Old Inp-Byp-Str''
    ,RIGHT(''00'' + SUBSTRING(cd.[NewData], CHARINDEX(''Sensor="'', cd.[NewData]) + 8, CHARINDEX(''"'', cd.[NewData], CHARINDEX(''Sensor="'', cd.[NewData]) + 8) - (CHARINDEX(''Sensor="'', cd.[NewData]) + 8)), 2) + ''-'' +
    RIGHT(''00'' + SUBSTRING(cd.[NewData], CHARINDEX(''Bypass="'', cd.[NewData]) + 8, CHARINDEX(''"'', cd.[NewData], CHARINDEX(''Bypass="'', cd.[NewData]) + 8) - (CHARINDEX(''Bypass="'', cd.[NewData]) + 8)), 2) + ''-'' +
    RIGHT(''00'' + SUBSTRING(cd.[NewData], CHARINDEX(''Strike="'', cd.[NewData]) + 8, CHARINDEX(''"'', cd.[NewData], CHARINDEX(''Strike="'', cd.[NewData]) + 8) - (CHARINDEX(''Strike="'', cd.[NewData]) + 8)), 2) ''New Inp-Byp-Str''
  ,cd.[RevisionStamp]
  ,cd.[OldData]
  ,cd.[NewData]

FROM CombinedData cd
LEFT JOIN ' + QUOTENAME(@liveConfig) + N'.[dbo].[ca_vw_DeviceList] devicevw ON cd.[caObjectID] = devicevw.[caObjectID]
  WHERE cd.[OperatorName] <> ''cic''
  ORDER BY cd.[RevisionStamp] ASC, devicevw.[Deviceid];
';

EXEC sp_executesql
    @SQL,
    N'@Start DATETIME,
      @End DATETIME,
      @DeviceFilter VARCHAR(10),
      @Device VARCHAR(10)',
    @Start,
    @End,
    @DeviceFilter,
    @Device;

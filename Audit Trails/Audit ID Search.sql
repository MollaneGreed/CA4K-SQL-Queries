DECLARE @Databases TABLE (DBName VARCHAR(100));

-- Set the following variables
DECLARE 
  @Auditid varchar(10) = '61641597',
  @liveConfig NVARCHAR(100) = 'CardAccessLiveConfigurationDB';

-- Add your list of databases
INSERT INTO @Databases (DBName) VALUES
('CardAccessLiveEventsDB'),
('CardAccessArchiveEventsDB');

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
  ,[OldData]
  ,[NewData]
  FROM ' + QUOTENAME(DBName) + '.[dbo].[DBAudit]
    WHERE [Auditid] = @Auditid',
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
  ,cd.[TableName] ''Table Name''
  ,cd.[Description] ''Device Name''
  ,devicevw.[Deviceid] ''Device ID''
  ,cd.[OperatorName] ''Operator Name''
  ,cd.[RevisionStamp] ''Revision Stamp''
  ,cd.[OldData] ''Old Data''
  ,cd.[NewData] ''New Data''

FROM CombinedData cd
LEFT JOIN ' + QUOTENAME(@liveConfig) + N'.[dbo].[ca_vw_DeviceList] devicevw ON cd.[caObjectID] = devicevw.[caObjectID];';

EXEC sp_executesql
    @SQL,
    N'@Auditid varchar(10)',
    @Auditid;

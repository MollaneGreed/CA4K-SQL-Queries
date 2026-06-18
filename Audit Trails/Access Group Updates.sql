-- Set the start date
DECLARE @StartDate DATE = '2025-07-11',
        @DaysBack INT = 1,
        @SearchFilter varchar(10) = 'false',
        @DescriptionFilter VARCHAR(100) = '',
        @archiveConfig NVARCHAR(100) = 'Example ArchiveConfigDB',
        @liveConfig NVARCHAR(100) = 'Example LiveConfigDB';

-- Do not change the following values
DECLARE @Start DATETIMEOFFSET = CAST(@StartDate AS DATETIME) AT TIME ZONE 'Singapore Standard Time';
DECLARE @End DATETIMEOFFSET = DATEADD(SECOND, 86399, DATEADD(DAY, @DaysBack, @Start));

-- List of databases to query
DECLARE @Databases TABLE (DBName VARCHAR(100));

INSERT INTO @Databases (DBName) VALUES
('Example database1'),
('Example database2'),
('Example database3');

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
      [RevisionStamp],
      [TableName],
      [OperatorName],
      [StationName],
      [Actions],
      [Description],
      [AuditId],
      [ChangedColumns],
      [OldData],
      [NewData]
     FROM '+ QUOTENAME(DBName) + '.[dbo].[DBAudit]
     WHERE [Actions] IN (''U'',''D'',''I'')
      AND [RevisionStamp] BETWEEN @Start AND @End
      AND (@SearchFilter <> ''True'' OR [Description] LIKE ''%'' + @DescriptionFilter + ''%'') '
,
@First = 0
FROM @Databases;

SET @SQL = @SQL + CHAR(10) + N') 
SELECT TOP (10)
  cd.[RevisionStamp],
  cd.[TableName],
  cd.[OperatorName],
    CASE
      WHEN r.[RoleName] IS NULL THEN ''Service_Account''
      ELSE r.[RoleName]
    END RoleName,
  cd.[StationName],
    CASE
      WHEN cd.[Actions] = ''U'' THEN ''Update''
      WHEN cd.[Actions] = ''D'' THEN ''Delete''
      WHEN cd.[Actions] = ''I'' THEN ''Insert''
      Else cd.[Actions]
    END Actions,
  cd.[Description],
  cd.[AuditId],
  cd.[ChangedColumns],
  cd.[OldData],
  cd.[NewData]
 FROM CombinedData cd
 LEFT JOIN ' + QUOTENAME(@archiveConfig) + N'.[dbo].[Operators] o on cd.[OperatorName] = o.[OperLoginName]
 LEFT JOIN ' + QUOTENAME(@liveConfig) + N'.[dbo].[Roles] r on o.[RoleID] = r.[RoleID]
  WHERE (@SearchFilter <> ''True'' OR cd.[Description] LIKE ''%'' + @DescriptionFilter + ''%'')
  AND cd.[TableName] != ''UserFields''
 ORDER BY cd.[RevisionStamp] DESC;';

EXEC sp_executesql
    @SQL,
    N'@Start DATETIMEOFFSET,
      @End DATETIMEOFFSET,
      @SearchFilter VARCHAR(10),
      @DescriptionFilter VARCHAR(100)',
    @Start = @Start,
    @End = @End,
    @SearchFilter = @SearchFilter,
    @DescriptionFilter = @DescriptionFilter
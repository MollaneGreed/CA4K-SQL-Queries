DECLARE
  @Databases TABLE (DBName VARCHAR(100));

-- Set the following variables
DECLARE 
  @StartDate DATE = '2025-07-18',
  @DaysBack INT = 1,
  @DescriptionFilter varchar(5) = 'False',
  @OperatorFilter varchar(5) = 'False',
  @TableNameFilter varchar(5) = 'False',
  @DescriptionText VARCHAR(100) = '',
  @OperatorName VARCHAR(100) = '',
  @liveConfig NVARCHAR(100) = 'exampleLiveConfig',
  @archiveConfig NVARCHAR(100) = 'exampleArchiveConfig';

-- Add your list of databases
INSERT INTO @Databases (DBName) VALUES
('exampleDatabase');

---------------------------------------------------------------------------
-- Do not change the following values
DECLARE @Start DATETIMEOFFSET = CAST(@StartDate AS DATETIME) AT TIME ZONE 'Singapore Standard Time';
DECLARE @End DATETIMEOFFSET = DATEADD(SECOND, 86399, DATEADD(DAY, @DaysBack, @Start));

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
  FROM ' + QUOTENAME(DBName) + '.[dbo].[DBAudit]
      WHERE [Actions] IN (''U'',''D'',''I'')
      AND [RevisionStamp] BETWEEN @Start AND @End
      AND (@DescriptionFilter <> ''True'' OR [Description] LIKE ''%'' + @DescriptionText + ''%'')
      AND (@OperatorFilter <> ''True'' OR [OperatorName] LIKE ''%'' + @OperatorName + ''%'')
      AND (@TableNameFilter <> ''True'' OR [TableName] != ''UserFields'')',
@First = 0
FROM @Databases;

SET @SQL = @SQL + CHAR(10) + N')
SELECT
  cd.[RevisionStamp],
  cd.[TableName],
  cd.[OperatorName],
  CASE
    WHEN r.[RoleName] IS NULL THEN ''Service Account''
    ELSE r.[RoleName]
  END ''Role Name'',
  cd.[StationName],
  CASE
    WHEN cd.[Actions] = ''U'' THEN ''Update''
    WHEN cd.[Actions] = ''D'' THEN ''Delete''
    WHEN cd.[Actions] = ''I'' THEN ''Insert''
    ELSE cd.[Actions]
  END ''Action'',
  cd.[Description],
  cd.[AuditId],
  cd.[ChangedColumns],
  cd.[OldData],
  cd.[NewData]
FROM CombinedData AS cd
 LEFT JOIN ' + QUOTENAME(@archiveConfig) + N'.[dbo].[Operators] AS o on cd.[OperatorName] = o.[OperLoginName]
 LEFT JOIN ' + QUOTENAME(@liveConfig) + N'.[dbo].[Roles] as r on o.[RoleID] = r.[RoleID]
  -- WHERE (@DescriptionFilter <> ''True'' OR [Description] LIKE ''%'' + @DescriptionText + ''%'')
  -- AND [TableName] != ''UserFields''
  -- WHERE [TableName] != ''UserFields''
  -- AND [Actions] = ''U''
 ORDER BY cd.[RevisionStamp] DESC';

 EXEC sp_executesql
  @SQL,
  N'@Start DATETIMEOFFSET,
    @End DATETIMEOFFSET,
    @DescriptionFilter VARCHAR(5),
    @OperatorFilter VARCHAR(5),
    @TableNameFilter VARCHAR(5),
    @DescriptionText VARCHAR(100),
    @OperatorName VARCHAR(100)',
  @Start = @Start,
  @End = @End,
  @DescriptionFilter = @DescriptionFilter,
  @OperatorFilter = @OperatorFilter,
  @TableNameFilter = @TableNameFilter,
  @DescriptionText = @DescriptionText,
  @OperatorName = @OperatorName;
  
DECLARE 
    @Databases TABLE (DBName VARCHAR(100));

-- Set the following variables
DECLARE 
    @SQL NVARCHAR(MAX) = 'WITH CombinedData AS (' + CHAR(10),
    @First BIT = 1,
    @SearchFilter varchar(10) = 'true',
    @DescriptionFilter VARCHAR(100) = '',
    @PanelFilter varchar(10) = 'false',
    @Panel varchar(10) = '',
    @Start DATETIME = '2026-6-22',
    @End DATETIME = '2026-6-23';

-- Add your list of databases
INSERT INTO @Databases (DBName) VALUES
('CardAccessLiveEvents'),
('CardAccessArchiveEvents'),
('CardAccessArchiveEvents_2');

-- Setup for dynamic SQL loop
SELECT @SQL = @SQL +
CASE 
  WHEN @First = 1 THEN N'' 
  ELSE CHAR(10) + N'UNION ALL '
END +
'SELECT
    [EDate],
    [Priority],
    [Class],
    [Description],
    [Name],
    [UTCOffset],
    [AckTStamp],
    [Badge]
  FROM ' + QUOTENAME(DBName) + '.[dbo].[ca_vw_EventDisplayGrid]
  WHERE [EDate] BETWEEN @Start AND @End
  AND (@PanelFilter <> ''True'' OR ([Name] LIKE ''%'' + @Panel + ''%'' OR [Class] LIKE ''PANEL'' + ''%''))
  AND (@SearchFilter <> ''True'' OR ([Description] LIKE ''%'' + @DescriptionFilter + ''%'' OR [Name] LIKE ''%'' + @DescriptionFilter + ''%''))
  ',
@First = 0
FROM @Databases;

SET @SQL = @SQL + CHAR(10) + N')
  SELECT
    [EDate] ''          UTC   '',
    [Class] + '' - '' + convert(VARCHAR,[Priority]) ''Event Type [Class - Proirity]'',
    [Description] + '' ('' + convert(varchar, [Badge] )  + '')'' AS ''Event Source [Description]'',
    [Name] ''Event Location [Name]'',
    [AckTStamp] AS ''Acknowledged (UTC)''
  FROM CombinedData
  ORDER BY [EDate] DESC';

EXEC sp_executesql
  @SQL,
    N'@Start DATETIME,
      @End DATETIME,
      @PanelFilter varchar(10),
      @Panel varchar(10),
      @SearchFilter varchar(10),
      @DescriptionFilter VARCHAR(100)',
  @Start,
  @End,
  @PanelFilter,
  @Panel,
  @SearchFilter,
  @DescriptionFilter;
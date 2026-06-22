DECLARE @Databases TABLE (DBName VARCHAR(100));

DECLARE
    @SQL NVARCHAR(MAX),
    @Start DATE = DATEADD(DAY, -2, GETDATE()),
    @End DATE = DATEADD(DAY, 1, GETDATE()),
    @SearchFilter varchar(10) = 'false',
    @DescriptionFilter varchar(10) = '',
    @First BIT = 1
    ;

-- Add your list of databases
INSERT INTO @Databases (DBName) VALUES
('CardAccessLiveEvents'),
('CardAccessArchiveEvents'),
('CardAccessArchiveEvents_2')
;

SET @SQL = 'WITH CombinedData AS (' + CHAR(10);

SELECT @SQL = @SQL +
    CASE 
    WHEN @First = 1 THEN N'' 
    ELSE CHAR(10) + N'UNION ALL '
    END +
'SELECT
    [Class]
    ,[Description]
  FROM ' + QUOTENAME(DBName) + '.[dbo].[Event]
    WHERE [EDate] BETWEEN @Start AND @End
    AND [Class] = ''SCRIPT EXECUTED''
    AND (@SearchFilter <> ''True'' OR [Description] LIKE ''%'' + @DescriptionFilter + ''%'')
    AND [Description] NOT LIKE ''%Valid Badges''',
@First = 0
FROM @Databases;

SET @SQL = @SQL + CHAR(10) + N')
SELECT
    [Class]
    ,[Description]
    ,COUNT([Description]) AS ''Event Count''
    ,convert(varchar,(DATEDIFF(HOUR, @Start,@End )*60/10)) AS ''Max events''
  FROM CombinedData
    GROUP BY [Class], [Description]
    ORDER BY ''Event Count'' DESC';

EXEC sp_executesql
  @SQL,
    N'@Start DATE,
      @End DATE,
      @SearchFilter varchar(10),
      @DescriptionFilter varchar(10)',
    @Start = @Start,
    @End = @End,
    @SearchFilter = @SearchFilter,
    @DescriptionFilter = @DescriptionFilter;
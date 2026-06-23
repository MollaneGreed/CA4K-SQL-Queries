-- Set the following variables
DECLARE
  @SQL NVARCHAR(MAX),
  @SearchFilter varchar(10) = 'false',
  @DescriptionFilter VARCHAR(100) = '',
  @LiveConfigDB NVARCHAR(255) = 'CardAccessLiveConfiguration';

SET @SQL = '
SELECT
    WS.[WorkstationName]
    ,WS.[UsePrinting]
    ,WS.[EventPrn]
    ,WS.[BadgingPrn]
    ,WS.[UseBadging]
    ,WS.[Badgingoption]
    ,WS.[EventPrinter]
    ,O.[OperLoginName]
FROM ' + QUOTENAME(@LiveConfigDB) + '.[dbo].[WorkstationSettings] WS
LEFT JOIN ' + QUOTENAME(@LiveConfigDB) + '.[dbo].[Operators] O ON WS.[LastOperator] = O.[OperatorID]
    WHERE (@SearchFilter <> ''True'' OR [WorkstationName] LIKE ''%'' + @DescriptionFilter + ''%'')
ORDER BY WS.[LastUpdated] DESC';

EXEC sp_executesql
  @SQL,
  N'@SearchFilter VARCHAR(10),
    @DescriptionFilter VARCHAR(100)',
  @SearchFilter = @SearchFilter,
  @DescriptionFilter = @DescriptionFilter
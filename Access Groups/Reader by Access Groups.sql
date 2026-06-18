-- Set the following variables
DECLARE 
  @SQL NVARCHAR(MAX),
  @LiveConfigDB NVARCHAR(255) = 'ExampleLiveConfigDB',
  @AccessGroupFilter NVARCHAR(10) = 'True',
    @AccessGroup NVARCHAR(100) = 'ExampleAccessGroup',
  @ReaderFilter NVARCHAR(10) = 'False',
    @Reader NVARCHAR(100) = 'ExampleReader';

---------------------------------------------------------------------------

SET @SQL = '
Select
  mag.[AgrpNo],
  mag.[Description],
  p.[PnlNo],
  p.[PanelName],
  r.[RdrNo],
  r.[ReaderName]
FROM ' + QUOTENAME(@LiveConfigDB) + '.[dbo].[AccGrp] ag
  JOIN ' + QUOTENAME(@LiveConfigDB) + '.[dbo].[mAccGrp] mag ON mag.[AgrpNo] = ag.[Agno]
  JOIN ' + QUOTENAME(@LiveConfigDB) + '.[dbo].[Panel] p ON p.[pnlNo] = ag.[pnlref]
  JOIN ' + QUOTENAME(@LiveConfigDB) + '.[dbo].[Reader] r ON r.[PnlRef] = p.[PnlNo]

WHERE (@AccessGroupFilter <> ''True'' OR mag.[Description] LIKE ''%'' + @AccessGroup + ''%'')
    AND (@ReaderFilter <> ''True'' OR r.[ReaderName] LIKE ''%'' + @Reader + ''%'')';

EXEC sp_executesql
    @SQL,
    N'@AccessGroup NVARCHAR(100),
      @Reader NVARCHAR(100),
      @AccessGroupFilter NVARCHAR(10),
      @ReaderFilter NVARCHAR(10)',
    @AccessGroup = @AccessGroup,
    @Reader = @Reader,
    @AccessGroupFilter = @AccessGroupFilter,
    @ReaderFilter = @ReaderFilter;
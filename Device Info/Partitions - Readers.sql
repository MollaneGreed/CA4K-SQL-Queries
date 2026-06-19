-- Set the following variables
DECLARE
  @SQL NVARCHAR(MAX),
  @SearchFilter varchar(10) = 'False',
  @ReaderFilter VARCHAR(100) = '',
  @LiveConfigDB NVARCHAR(255) = 'CardAccessLiveConfiguration';

SET @SQL = '
WITH PartitionNamesCTE AS (
    SELECT dp.[caObjectID], 
        STRING_AGG(p.[PartitionName], CHAR(13) + CHAR(10))
        WITHIN GROUP (ORDER BY p.[PartitionName]) AS PartitionNames
    FROM ' + QUOTENAME(@LiveConfigDB) + '.[dbo].[DevicePartitions] AS dp
    LEFT JOIN ' + QUOTENAME(@LiveConfigDB) + '.[dbo].[Partition] as p ON dp.[PartitionID] = p.[PartitionID]
    GROUP BY dp.[caObjectID]
)
SELECT
    r.[PnlRef] AS ''Panel #'',
    r.[RdrNo] AS ''Reader # '',
    r.[ReaderName] AS ''Reader Name'',
    PNCTE.PartitionNames AS ''Assigned Partition'',
    r.[LastUpdated] AT TIME ZONE ''UTC'' AT TIME ZONE ''Central Standard Time'' AS ''CST_Time'',
    o.[OperLoginName] AS ''Last Mod By''
FROM ' + QUOTENAME(@LiveConfigDB) + '.[dbo].[Reader] AS r
    LEFT JOIN PartitionNamesCTE AS PNCTE ON PNCTE.caObjectID = r.[caObjectID]
    LEFT JOIN ' + QUOTENAME(@LiveConfigDB) + '.[dbo].[Operators] AS o ON o.[OperatorID] = r.[LastOperator]
WHERE r.[PnlRef] > 0
    AND (@SearchFilter <> ''True'' OR [Description] LIKE ''%'' + @ReaderFilter + ''%'')
ORDER BY r.[PnlRef], r.[RdrNo];';

EXEC sp_executesql
  @SQL,
  N'@SearchFilter varchar(10),
    @ReaderFilter VARCHAR(100)',
  @SearchFilter = @SearchFilter,
  @ReaderFilter = @ReaderFilter;
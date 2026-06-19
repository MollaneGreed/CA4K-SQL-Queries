-- Set the following variables
DECLARE
  @SQL NVARCHAR(MAX),
  @SearchFilter varchar(10) = 'False',
  @PanelFilter VARCHAR(100) = 'SMSR',
  @LiveConfigDB NVARCHAR(255) = 'CardAccessLiveConfiguration';

SET @SQL = '
WITH PartitionNamesCTE AS (
    SELECT dp.[caObjectID], 
        STRING_AGG(part.[PartitionName], CHAR(13) + CHAR(10))
        WITHIN GROUP (ORDER BY part.[PartitionName]) AS PartitionNames
    FROM ' + QUOTENAME(@LiveConfigDB) + '.[dbo].[DevicePartitions] AS dp
    LEFT JOIN ' + QUOTENAME(@LiveConfigDB) + '.[dbo].[Partition] part ON dp.[PartitionID] = part.[PartitionID]
    GROUP BY dp.[caObjectID]
)
SELECT
    p.[PnlNo] AS ''Panel #'',
    p.[PanelName] AS ''Panel Name'',
    PNCTE.PartitionNames AS ''Assigned Partition'',
    p.[LastUpdated] AT TIME ZONE ''UTC'' AT TIME ZONE ''Central Standard Time'' AS ''CST_Time'',
    o.[OperLoginName] AS ''Last Mod By''
FROM ' + QUOTENAME(@LiveConfigDB) + '.[dbo].[Panel] AS p
    LEFT JOIN PartitionNamesCTE AS PNCTE ON PNCTE.[caObjectID] = p.[caObjectID]
    LEFT JOIN ' + QUOTENAME(@LiveConfigDB) + '.[dbo].[Operators] o ON o.[OperatorID] = p.[LastOperator]
WHERE p.[PnlNo] > 0
    AND (@SearchFilter <> ''True'' OR [PanelName] LIKE ''%'' + @PanelFilter + ''%'')
ORDER BY p.[PnlNo];';

EXEC sp_executesql
  @SQL,
  N'@SearchFilter varchar(10),
    @PanelFilter VARCHAR(100)',
  @SearchFilter = @SearchFilter,
  @PanelFilter = @PanelFilter;
DECLARE 
  @SQL NVARCHAR(MAX),
  @LiveConfigDB NVARCHAR(255) = 'CardAccessLiveConfiguration',
  @ArchiveConfigDB NVARCHAR(255) = 'CardAccessArchiveConfiguration';
  
SET @SQL = 
'SELECT
  mag.[AgrpNo] ''Group#'',
  mag.[Description] ''Group Name'',
  o.[OperLoginName] ''Last modified by''
  FROM ' + QUOTENAME(@LiveConfigDB) + '.[dbo].[MAccGrp] AS mag
    LEFT JOIN ' + QUOTENAME(@ArchiveConfigDB) + '.[dbo].[Operators] AS o on mag.[LastOperator] = o.[OperatorID]
ORDER BY AgrpNo ASC';

EXEC sp_executesql @SQL;  
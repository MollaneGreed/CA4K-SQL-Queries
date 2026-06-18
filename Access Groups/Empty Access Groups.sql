DECLARE 
  @SQL NVARCHAR(MAX),
  @LiveConfigDB NVARCHAR(255) = 'Example LiveConfigDB';


SET @SQL = '
SELECT DISTINCT
  mag.[AccessGroupNo] AS "Group#",
  mag.[Description] AS "Group Name"
  FROM ' + QUOTENAME(@LiveConfigDB) + '.[dbo].[ca_vw_AccessGroupsGetForParam] AS mag
  WHERE mag.AccessGroupNo NOT IN
    (SELECT DISTINCT
       b.AGroupNo
		FROM ' + QUOTENAME(@LiveConfigDB) + '.[dbo].[ca_vw_BadgeAccessList] AS b)
ORDER BY AccessGroupNo ASC';

EXEC sp_executesql @SQL;
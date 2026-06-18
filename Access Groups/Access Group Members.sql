-- Set the variables
DECLARE
    @SQL NVARCHAR(MAX),
    @LiveConfigDB NVARCHAR(255) = 'ExampleLiveConfigDB',
    @AccessGroup NVARCHAR(100) = 'ExampleAccessGroup';

---------------------------------------------------------------------------

SET @SQL = '
    WITH AccessGroupNamesCTE AS (
        SELECT
            t1.[Badge],
            STRING_AGG(t2.[Description], '', '') WITHIN GROUP (ORDER BY t2.[Description]) "Access Groups"
        FROM ' + QUOTENAME(@LiveConfigDB) + '.[dbo].[BadgeAccess] t1
        LEFT JOIN ' + QUOTENAME(@LiveConfigDB) + '.[dbo].[MAccGrp] t2 ON t1.[AGroupNo] = t2.[AgrpNo]
        GROUP BY t1.[Badge])

    SELECT
        p.[FrstName] "First Name"
        ,p.[LastName] 
        ,b.[Badge]
        ,b.[Embossed] "Employee ID"
        ,ag.[Access Groups] "Access Groups"
        ,o.[OperLoginName] "Last Updated by"
        ,b.[LastUpdated]
	    ,p.[Remarks]
    FROM ' + QUOTENAME(@LiveConfigDB) + '.[dbo].[Badge] AS b
    LEFT JOIN ' + QUOTENAME(@LiveConfigDB) + '.[dbo].[Person] AS p ON b.PersonID = p.PersonID
    LEFT JOIN ' + QUOTENAME(@LiveConfigDB) + '.[dbo].[Operators] AS o ON b.LastOperator = o.operatorID
        LEFT JOIN AccessGroupNamesCTE AS ag ON b.Badge = ag.Badge
    WHERE b.[Enabled] = 1
        AND ag.[Access Groups] LIKE ''%'' + @AccessGroup + ''%''
    ORDER BY b.[Embossed] ASC';

EXEC sp_executesql
    @SQL,
    N'@AccessGroup NVARCHAR(100)',
    @AccessGroup = @AccessGroup;
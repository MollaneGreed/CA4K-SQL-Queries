-- Access Group Member list

    -- Set the Access Group variable
    DECLARE @AccessGroup NVARCHAR(100) = 'AG-CAPHI-VZ-CX';

---------------------------------------------------------------------------

--Get all access group that a single user is a member of.
    WITH AccessGroupNamesCTE AS (
        SELECT
            t1.[Badge],
            STRING_AGG(t2.[Description], ', ') WITHIN GROUP (ORDER BY t2.[Description]) AS 'Access Groups'
        FROM [CardAccessLiveConfigurationPH].[dbo].[BadgeAccess] AS t1
        LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[MAccGrp] as t2 ON t1.[AGroupNo] = t2.[AgrpNo]
        GROUP BY t1.[Badge]
    )
--Display the user information.
    SELECT
        p.FrstName 'First Name'
        ,p.[LastName]
        ,b.[Badge]
        ,b.[Embossed] 'Employee ID'
        ,ag.[Access Groups] 'Access Groups'
        ,o.[OperLoginName] 'Last Updated by'
        ,b.[LastUpdated] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time' AS [CST_Time]
	    ,p.[Remarks]
    FROM [CardAccessLiveConfigurationPH].[dbo].[Badge] AS b
    LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Person] AS p ON b.PersonID = p.PersonID
    LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Operators] AS o ON b.LastOperator = o.operatorID
        LEFT JOIN AccessGroupNamesCTE AS ag ON b.Badge = ag.Badge
    WHERE b.[Enabled] = 1
        AND ag.[Access Groups] LIKE '%' + @AccessGroup + '%'
    ORDER BY b.[Embossed] ASC
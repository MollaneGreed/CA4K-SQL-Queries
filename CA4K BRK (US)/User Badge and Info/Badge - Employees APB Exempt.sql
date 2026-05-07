WITH AccessGroupNamesCTE AS (
    SELECT
        t1.[Badge],
        STRING_AGG(t2.[Description], ', ') WITHIN GROUP (ORDER BY t2.[Description]) AS 'Access Groups'
    FROM [CardAccessLiveConfigurationUS].[dbo].[BadgeAccess] AS t1
    LEFT JOIN [CardAccessLiveConfigurationUS].[dbo].[MAccGrp] as t2 ON t1.[AGroupNo] = t2.[AgrpNo]
    GROUP BY t1.[Badge]
)
SELECT
      p.FrstName
      ,p.[LastName]
      ,b.[Badge]
      ,b.[Enabled]
      ,b.[Embossed]
      ,b.[MApbExempt] 'APB Exempt'
      --,b.[SiteNo]
      ,ag.[Access Groups] 'Access Groups'
      ,o.[OperLoginName] 'Last Updated by'
      ,b.[LastUpdated] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time' AS [CST_Time]
  FROM [CardAccessLiveConfigurationUS].[dbo].[Badge] AS b
  LEFT JOIN [CardAccessLiveConfigurationUS].[dbo].[Person] AS p ON b.PersonID = p.PersonID
  LEFT JOIN [CardAccessLiveConfigurationUS].[dbo].[Operators] AS o ON b.LastOperator = o.operatorID
    LEFT JOIN AccessGroupNamesCTE AS ag ON b.Badge = ag.Badge
  WHERE b.[MApbExempt] = 1 and b.[Enabled] = 1 and b.[Embossed] > 0 AND ag.[Access Groups] NOT LIKE '%VIP%' and ag.[Access Groups] NOT LIKE '%FACILITIES%'
  ORDER BY b.[Embossed] ASC
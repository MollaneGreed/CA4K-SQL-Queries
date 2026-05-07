WITH JoinedBadges AS (
  SELECT
    [LastUpdated],
    [Badge],
    [Enabled],
    [ActvDate],
    [ExprDate],
    [personID],
    [LastOperator]
  FROM [CardAccessLiveConfigurationUS].[dbo].[Badge]
UNION ALL
	SELECT
    [LastUpdated],
    [Badge],
    [Enabled],
    [ActvDate],
    [ExprDate],
    [personID],
    [LastOperator]
  FROM [CardAccessArchiveConfigurationUS].[dbo].[Badge]
)
SELECT
      o.[OperLoginName] AS 'Updated/Created By',
      b.[LastUpdated],
      p.[FrstName],
      p.[LastName],
      b.[Badge],
      CASE
        WHEN b.[Enabled] = '0' THEN 'No'
        WHEN b.[Enabled] = '1' THEN 'Yes'
      END 'Enabled',
      b.[ActvDate],
      b.[ExprDate]
  FROM [CardAccessLiveConfigurationUS].[dbo].[Badge] AS b
  LEFT JOIN [CardAccessLiveConfigurationUS].[dbo].[Person] AS p ON b.PersonID = p.PersonID 
  LEFT JOIN [CardAccessLiveConfigurationUS].[dbo].[Operators] AS o ON b.[LastOperator] = o.[operatorID]
  WHERE p.[FrstName]  '*TEMPORARY*' and o.[OperLoginName] NOT Like 'admin'
    ORDER BY [LastUpdated] Desc

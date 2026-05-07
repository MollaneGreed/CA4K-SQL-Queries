WITH JoinedBadges AS (
  SELECT
    [LastUpdated],
    [Badge],
    [Enabled],
    [ActvDate],
    [ExprDate],
    [personID],
    [LastOperator]
  FROM [CardAccessLiveConfigurationPH].[dbo].[Badge]
UNION ALL
	SELECT
    [LastUpdated],
    [Badge],
    [Enabled],
    [ActvDate],
    [ExprDate],
    [personID],
    [LastOperator]
  FROM [CardAccessArchiveConfigurationPH].[dbo].[Badge]
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
  FROM JoinedBadges AS b
  LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Person] AS p ON b.PersonID = p.PersonID 
  LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Operators] AS o ON b.[LastOperator] = o.[operatorID]
  WHERE p.[FrstName] = '*TEMPORARY*' and o.[OperLoginName] NOT Like 'admin'
    ORDER BY [LastUpdated] Desc

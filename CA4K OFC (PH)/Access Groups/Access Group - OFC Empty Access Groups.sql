-- Run on the SQL Server
-- Once complete Export as 'EmptyAccessGroups.csv' to 'C:\temp'. 
-- There is a PowerShell Script that can be run to verify the group existance and members in AD.
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT DISTINCT
  mag.[AgrpNo] AS 'Group#',
  mag.[Description] AS 'Group Name'
  --,ag.[LastUpdated] AS 'Last Updated'
  FROM [CardAccessLiveConfigurationPH].[dbo].[MAccGrp] AS mag
  --LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[AccGrp] AS ag ON ag.Agno = mag.AgrpNo
  WHERE AgrpNo NOT IN
    (SELECT DISTINCT
       b.AGroupNo
		FROM [CardAccessLiveConfigurationPH].[dbo].[BadgeAccess] AS b
    )
ORDER BY AgrpNo ASC
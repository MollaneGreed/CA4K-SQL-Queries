-- Run on the SQL Server
-- Once complete Export as 'EmptyAccessGroups.csv' to 'C:\temp'. This can be updated to align with the PowerShell script.
-- There is also a PowerShell Script that can be run to verify the group existence and members in AD.
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT DISTINCT
  mag.[AgrpNo] AS 'Group#',
  mag.[Description] AS 'Group Name'
  FROM [CardAccessLiveConfigurationUS].[dbo].[MAccGrp] AS mag
  WHERE AgrpNo NOT IN
    (SELECT DISTINCT
       b.AGroupNo
		FROM [CardAccessLiveConfigurationUS].[dbo].[BadgeAccess] AS b
    )
ORDER BY AgrpNo ASC
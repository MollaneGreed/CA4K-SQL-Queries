-- Run on the SQL Server
-- Once complete Export as 'EmptyAccessGroups.csv' to '\\afnbrkca4kapp2\temp\AccessGroupVerification'. 
-- There is a PowerShell Script that can be run to verify the group existance and members in AD.
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT DISTINCT
  mag.[AccessGroupNo] AS 'Group#',
  mag.[Description] AS 'Group Name'
  FROM [CardAccessLiveConfigurationPH].[dbo].[ca_vw_AccessGroupsGetForParam] AS mag
  WHERE mag.AccessGroupNo NOT IN
    (SELECT DISTINCT
       b.AGroupNo
		FROM [CardAccessLiveConfigurationPH].[dbo].[ca_vw_BadgeAccessList] AS b
    )
ORDER BY AccessGroupNo ASC
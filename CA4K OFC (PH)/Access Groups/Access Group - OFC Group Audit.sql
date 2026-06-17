-- Run on the SQL Server
-- Once complete Export as 'EmptyAccessGroups.csv' to 'C:\temp'. 
-- There is a PowerShell Script that can be run to verify the group existance and members in AD.
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT
  mag.[AgrpNo] AS 'Group#',
  mag.[Description] AS 'Group Name',
  mag.[LastOperator],
  o.[OperLoginName]
  --,ag.[LastUpdated] AS 'Last Updated'
  FROM [CardAccessLiveConfigurationPH].[dbo].[MAccGrp] AS mag
    LEFT JOIN [CardAccessarchiveConfigurationPH].[dbo].[Operators] AS o on mag.[LastOperator] = o.[OperatorID]
  --LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[AccGrp] AS ag ON ag.Agno = mag.AgrpNo
  --WHERE mag.Description = 'AG-CAPHI-WPE'
ORDER BY AgrpNo ASC
  
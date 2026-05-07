-- Run on the SQL Server
-- Once complete Export as 'EmptyAccessGroups.csv' to 'C:\temp'. This can be updated to align with the PowerShell script.
-- There is also a PowerShell Script that can be run to verify the group existence and members in AD.
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT DISTINCT
  mag.[AgrpNo] AS 'Group#',
  mag.[Description] AS 'Group Name',
  mag.[LastUpdated],
  op.OperLoginName
  FROM [CardAccessLiveConfigurationUS].[dbo].[MAccGrp] AS mag
  JOIN [CardAccessLiveConfigurationUS].[dbo].Operators OP on op.OperatorID = mag.LastOperator
ORDER BY LastUpdated Desc
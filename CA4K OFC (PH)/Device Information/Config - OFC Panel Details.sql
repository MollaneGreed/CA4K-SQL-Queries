-- This needs to be run from the SQL server and CardAccessLiveConfiguration database
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT 
    S.[Panel],
    P.[PanelName],
    S.[Type],
    S.[HCSNo],
    S.[Status],
    S.[SDate] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time' AS [Last Sync (CST)],
    S.[SDate] 'Last Sync',
    S.[State],
    S.[Xact]
  FROM [CardAccessLiveEventsPH].[dbo].[Status] S
  JOIN [CardAccessLiveConfigurationPH].[dbo].[Panel] P ON S.Panel = P.PnlNo
  Where [state] = 0
  ORDER BY [Panel] ASC
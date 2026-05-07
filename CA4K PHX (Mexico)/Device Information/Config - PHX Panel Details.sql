-- This needs to be run from the SQL server and CardAccessLiveConfiguration database
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT 
    [Panel],
    [Type],
    [HCSNo],
    [Status],
    [SDate] 'Last Sync',
    [SDate] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time' AS [Last Sync (CST)],
    [State],
    [Xact]
  FROM [CardAccessLiveEventsMX].[dbo].[Status]
  Where [state] = 0


--This Query is able to check for all events that occur between the specified times on multiple days.

-- Set the Employee ID variable
DECLARE @LastName NVARCHAR(100) = '3000620';

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT 
    [PnlNo] 'Panel Number'
    ,[DeviceNo] 'Reader Numer'
    ,[Badge]
    ,[Class] 'Event Type'
    ,[Description] 'Event Source'
    ,[Name] 'Event Location'
    ,[AckTStamp] 'Event received by server'
    ,[EDate] 'Event saved to DB'
    ,[EDate] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time' AS 'CST_Time'
FROM [CardAccessLiveEventsMX].[dbo].[Event]
WHERE [EDate] BETWEEN DATEADD(DAY, -10, CAST(GETDATE() AS DATE)) AND DATEADD(DAY, 1, CAST(GETDATE() AS DATE))
    AND [Description] LIKE '%' + @LastName + '%'
ORDER BY [EDate] DESC
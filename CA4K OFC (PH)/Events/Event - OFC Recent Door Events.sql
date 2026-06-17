--This Query is able to check for all events that occur between the specified times on multiple days.

-- Set the Employee ID variable
DECLARE @Door NVARCHAR(100) = 'SMT4 01F 85105 TR BATANES';

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
    ,DATEADD(HH,-5, [EDate]) 'EDate -5'
FROM [CardAccessLiveEventsPH].[dbo].[Event]
WHERE [EDate] BETWEEN DATEADD(DAY, -1, CAST(GETDATE() AS DATE)) AND DATEADD(DAY, 1, CAST(GETDATE() AS DATE))
    AND [PnlNo] = '12'
    AND [DeviceNo] IN (7,8,11,12)
    --AND [Description] LIKE '%' + @Door + '%'
    --OR [Name] LIKE '%' + @Door + '%'
ORDER BY [EDate] DESC
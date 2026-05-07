--This Query is able to check for all events that occur between the specified times on multiple days.

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT 
    [Name] 'Event Location',
    COUNT(Distinct [AckTStamp]) AS 'Unique Events',
    MIN([EDate] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time') AS 'First Event CST',
    MAX([EDate] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time') AS 'Last Event CST'
FROM [CardAccessLiveEventsPH].[dbo].[Event]
WHERE [EDate] BETWEEN DATEADD(DAY, -10, CAST(GETDATE() AS DATE)) AND DATEADD(DAY, 1, CAST(GETDATE() AS DATE))
    AND [Class] LIKE 'BADGE Violate Void at Panel%'
GROUP BY [Name]
ORDER BY 'Unique Events' DESC

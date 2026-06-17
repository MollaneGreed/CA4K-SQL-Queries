--This Query is able to check for all events that occur between the specified times on multiple days.

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT 
    [Name] 'Event Location',
    COUNT(Distinct [AckTStamp]) AS 'Unique Events',
    MIN([EDate] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time') AS 'First Event CST',
    MAX([EDate] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time') AS 'Last Event CST'
FROM [CardAccessLiveEventsUS].[dbo].[Event]
WHERE [EDate] BETWEEN DATEADD(DAY, -10, CAST(GETDATE() AS DATE)) AND DATEADD(DAY, 1, CAST(GETDATE() AS DATE))
    AND [Class] LIKE 'BADGE Violate Void at Panel%'
GROUP BY [Name]
ORDER BY 'Unique Events' DESC;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT TOP 10
    [EDATE],
    [CLASS],
    [Name] 'Event Location',
    [Description]
FROM [CardAccessLiveEventsUS].[dbo].[Event]
WHERE [EDate] BETWEEN DATEADD(DAY, -10, CAST(GETDATE() AS DATE)) AND DATEADD(DAY, 1, CAST(GETDATE() AS DATE))
    AND [Class] LIKE 'BADGE Violate Void at Panel%'
ORDER BY [EDATE] DESC


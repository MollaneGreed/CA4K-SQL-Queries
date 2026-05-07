--This Query is able to check for all events that occur between the specified times on multiple days.
DECLARE
    @Start DATE = DATEADD(DAY, -1, GETDATE())
    --@Start DATE = '2026-04-02'
    ,@End DATE = DATEADD(DAY, 1, GETDATE())
    ;

WITH ArchiveEvents AS (
    SELECT
    [EDate],
    [Class],
    [Description],
    [Name],
    [AckTStamp],
    [Ca4kdb] = '01-Live'
    FROM [CardAccessliveEventsMX].[dbo].[Event]
    WHERE [EDate] BETWEEN @Start AND @End
/*UNION ALL
    SELECT
    [EDate],
    [Class],
    [Description],
    [Name],
    [AckTStamp],
    [Ca4kdb] = '02-Archive'
    FROM [CardAccessArchiveEventsMX].[dbo].[Event]
    WHERE [EDate] BETWEEN @Start AND @End
UNION ALL
	SELECT
    [EDate],
    [Class],
    [Description],
    [Name],
    [AckTStamp]
    FROM [CardAccessArchiveEventsMX_2].[dbo].[Event]
    WHERE [EDate] BETWEEN @Start AND @End*/
    )
SELECT 
    ([EDate] AT TIME ZONE 'UTC') AT TIME ZONE 'Central Standard Time' AS [CST_Time],
    --[EDate] AS [UTC_Time],
    [Class] 'Event Type',
    [Description] 'Event Source',
    [Name] 'Event Location',
    [AckTStamp] 'Acknowledged Time',
    [Ca4kdb]
FROM ArchiveEvents
WHERE [Description] LIKE '2-%' OR [Name] LIKE '2-%'
ORDER BY [EDate] DESC

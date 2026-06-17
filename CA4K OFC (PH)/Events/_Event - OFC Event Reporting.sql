--This Query is able to check for all events that occur between the specified times on multiple days.
DECLARE 
    @Start DATETIME = '2026-5-19',
    @End DATETIME = '2026-5-23';

WITH ArchiveEvents AS (
    SELECT
    [EDate],
    [Class],
    [Description],
    [Name],
    [Badge],
    [AckTStamp]
    FROM [CardAccessliveEventsPH].[dbo].[Event]
    WHERE [EDate] BETWEEN @Start AND @End
UNION ALL
    SELECT
    [EDate],
    [Class],
    [Description],
    [Name],
    [Badge],
    [AckTStamp]
    FROM [CardAccessArchiveEventsPH].[dbo].[Event]
    WHERE [EDate] BETWEEN @Start AND @End
UNION ALL
	SELECT
    [EDate],
    [Class],
    [Description],
    [Name],
    [Badge],
    [AckTStamp]
    FROM [CardAccessArchiveEventsPH_2].[dbo].[Event]
    WHERE [EDate] BETWEEN @Start AND @End
    )
SELECT 
    --([EDate] AT TIME ZONE 'UTC') AT TIME ZONE 'Central Standard Time' AS [CST_Time],
    [EDate] AS [UTC_Time],
    --([EDate] AT TIME ZONE 'UTC') AT TIME ZONE 'Singapore Standard Time' AS [Manila_Time],
    [Class] 'Event Type',
    [Description] 'Event Source',
    [Name] 'Event Location',
    [Badge],
    [AckTStamp] 'Acknowledged Time'
FROM ArchiveEvents
WHERE [Description] LIKE '%86052%'
ORDER BY [EDate] ASC

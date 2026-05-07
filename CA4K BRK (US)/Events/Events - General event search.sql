--This Query is able to check for all events that occur between the specified times on multiple days.
WITH ArchiveEvents AS (
    SELECT
    [EDate],
    [Class],
    [Description],
    [Name]
    FROM [CardAccessLiveEventsUS].[dbo].[Event]
UNION ALL
    SELECT
    [EDate],
    [Class],
    [Description],
    [Name]
    FROM [CardAccessArchiveEventsUS].[dbo].[Event]
UNION ALL
	SELECT
    [EDate],
    [Class],
    [Description],
    [Name]
    FROM [CardAccessArchiveEventsUS_2].[dbo].[Event]
    )
SELECT 
    [EDate] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time' AS [CST_Time],
    [Class] 'Event Type',
    [Description] 'Event Source',
    [Name] 'Event Location'
FROM ArchiveEvents
WHERE [EDate] BETWEEN '2026-03-24 00:00:00' AND '2026-03-26 00:00:00'
    AND [Description] LIKE '%70384%'
    --and [CLASS] != 'Badge Valid'
ORDER BY [EDate] ASC

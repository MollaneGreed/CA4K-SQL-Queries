--This Query is able to check for all events that occur between the specified times on multiple days.
DECLARE 
    @Start DATETIME = '2025-12-11 20:06:00',
    @End DATETIME = '2025-12-12 10:00:00';

WITH ArchiveEvents AS (
    SELECT
    [EDate],
    [Class],
    [Description],
    [Name],
    [AckTStamp]
    FROM [CardAccessliveEventsPH].[dbo].[Event]
    WHERE [EDate] BETWEEN @Start AND @End
UNION ALL
    SELECT
    [EDate],
    [Class],
    [Description],
    [Name],
    [AckTStamp]
    FROM [CardAccessArchiveEventsPH].[dbo].[Event]
    WHERE [EDate] BETWEEN @Start AND @End
UNION ALL
	SELECT
    [EDate],
    [Class],
    [Description],
    [Name],
    [AckTStamp]
    FROM [CardAccessArchiveEventsPH_2].[dbo].[Event]
    WHERE [EDate] BETWEEN @Start AND @End
    )
SELECT 
    ([EDate] AT TIME ZONE 'UTC') AT TIME ZONE 'Central Standard Time' AS [CST_Time],
    [EDate] AS [UTC_Time],
    ([EDate] AT TIME ZONE 'UTC') AT TIME ZONE 'Singapore Standard Time' AS [Manila_Time],
    [Class] 'Event Type',
    [Description] 'Event Source',
    [Name] 'Event Location',
    [AckTStamp] 'Acknowledged Time'
FROM ArchiveEvents
ORDER BY [EDate] ASC

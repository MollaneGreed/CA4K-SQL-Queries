--This Query is able to check for all events that occur between the specified times on multiple days.
-- Set the Access Group variable
    DECLARE @Start NVARCHAR(100) = '2024-12-31 16:00:00';
    DECLARE @End NVARCHAR(100) = '2025-01-31 16:00:00';

WITH Events AS (
    SELECT
    [EDate],
    [Class],
    [Description],
    [Name]
    FROM [CardAccessliveEventsPH].[dbo].[Event]
    WHERE [EDate] BETWEEN @Start AND @End
UNION ALL
    SELECT
    [EDate],
    [Class],
    [Description],
    [Name]
    FROM [CardAccessArchiveEventsPH].[dbo].[Event]
    WHERE [EDate] BETWEEN @Start AND @End
UNION ALL
	SELECT
    [EDate],
    [Class],
    [Description],
    [Name]
    FROM [CardAccessArchiveEventsPH_2].[dbo].[Event]
    WHERE [EDate] BETWEEN @Start AND @End
    )
SELECT 
    [EDate] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time' AS [CST_Time],
    [EDate] AT TIME ZONE 'UTC' AT TIME ZONE 'Singapore Standard Time' AS [Manila_Time],
    [Class] 'Event Type',
    [Description] 'Event Source',
    [Name] 'Event Location'
FROM Events
ORDER BY [EDate] ASC

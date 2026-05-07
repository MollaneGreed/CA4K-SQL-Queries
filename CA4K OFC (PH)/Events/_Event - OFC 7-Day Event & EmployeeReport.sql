--This query collects non-badge events over a 7day period.

DECLARE @DateRange INT = '1';
-- Pick Variables and comment out the unused ones
    -- Start Date Options
        --DECLARE @StartDate DATE = '2025-04-08'; -- Uses Specified Date
        DECLARE @StartDate DATE = DATEADD(HOUR, -@DateRange, GETDATE()); -- Start x Days Ago.
    -- Readers
        DECLARE @Readers NVARCHAR(100) = 'OFC 04F 83024 PROD 1';

-- Do not change the following values
DECLARE @Start DATETIMEOFFSET = CAST(@StartDate AS DATETIME) AT TIME ZONE 'Singapore Standard Time';
DECLARE @End DATETIMEOFFSET = DATEADD(SECOND, 86399, DATEADD(DAY, @DateRange, @Start)); -- Gets 7 Days after Start



-- Collects data from the 3 Event databases and stores tham as "ArchiveEvents"
WITH ArchiveEvents AS (
    SELECT
        [EDate],
        [Class],
        [Description],
        [Name],
        [UTCOffset],
        [AckTStamp],
        [Badge]
    FROM [CardAccessliveEventsPH].[dbo].[Event]
        WHERE [EDate] BETWEEN @Start AND @End
UNION ALL
    SELECT
        [EDate],
        [Class],
        [Description],
        [Name],
        [UTCOffset],
        [AckTStamp],
        [Badge]
    FROM [CardAccessArchiveEventsPH].[dbo].[Event]
        WHERE [EDate] BETWEEN @Start AND @End
UNION ALL
	SELECT
        [EDate],
        [Class],
        [Description],
        [Name],
        [UTCOffset],
        [AckTStamp],
        [Badge]
    FROM [CardAccessArchiveEventsPH_2].[dbo].[Event]
        WHERE [EDate] BETWEEN @Start AND @End
    )

-- Create a view of all the data collected from the Event tables that were stored in "ArchiveEvents"
SELECT 
    DATEADD(MINUTE, [UTCOffset], [EDate]) AS 'Date (UTC -7hrs)',
    [Class] 'Event Type',
    [Description] + ' (' + convert(varchar, [Badge] )  + ')' AS 'Event Source',
    [Name] 'Event Location',
    DATEADD(MINUTE, [UTCOffset], [AckTStamp]) AS 'Acknowledged (UTC -7hrs)'
FROM ArchiveEvents
WHERE [EDate] BETWEEN @Start AND @End
    AND [Name] LIKE '%' + @Readers + '%'
ORDER BY [EDate] desc
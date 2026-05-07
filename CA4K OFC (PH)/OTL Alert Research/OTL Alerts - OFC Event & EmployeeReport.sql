--This query collects non-badge events over a 7day period.

DECLARE @DateRange INT = '2';
-- Pick Variables and comment out the unused ones
  -- Start Date Options
     -- Uses Specified Date
      --DECLARE @StartDate DATE = '2025-04-08';
     -- Start x Days Ago.
      DECLARE @StartDate DATE = DATEADD(HOUR, -@DateRange, GETDATE());
  -- Readers
      DECLARE @Readers NVARCHAR(100) = '83023';

-- Do not change the following values
  DECLARE @Start DATETIMEOFFSET = CAST(@StartDate AS DATETIME) AT TIME ZONE 'Singapore Standard Time';
  -- Gets 7 Days after Start
    DECLARE @End DATETIMEOFFSET = DATEADD(SECOND, 86399, DATEADD(DAY, @DateRange, @Start)); 

-- Collects data from the 3 Event databases and stores tham as "ArchiveEvents"
WITH EventTables AS (
SELECT
        [EDate],
        [Class],
        [Description],
        [Name],
        [PnlNo],
        [DeviceNo],
        [Badge],
        [UTCOffset]
    FROM [CardAccessliveEventsPH].[dbo].[ca_vw_HistEventDisplayGrid]
        WHERE [EDate] BETWEEN @Start AND @End
    UNION ALL
SELECT
        [EDate],
        [Class],
        [Description],
        [Name],
        [PnlNo],
        [DeviceNo],
        [Badge],
        [UTCOffset]
    FROM [CardAccessArchiveEventsPH].[dbo].[ca_vw_HistEventDisplayGrid]
        WHERE [EDate] BETWEEN @Start AND @End
    UNION ALL
SELECT
        [EDate],
        [Class],
        [Description],
        [Name],
        [PnlNo],
        [DeviceNo],
        [Badge],
        [UTCOffset]
    FROM [CardAccessArchiveEventsPH_2].[dbo].[ca_vw_HistEventDisplayGrid]
        WHERE [EDate] BETWEEN @Start AND @End
)

SELECT
    [PnlNo] 'Panel',
    [DeviceNo] 'Device/Reader',
    DATEADD(MINUTE, [UTCOffset], [EDate]) AS 'Date (UTC -7hrs)',
    [Class] ' Event Type ',
    [Description] + ' (' + convert(varchar, [Badge] )  + ')' AS 'Event Source',
    [Name] 'Event Location'
FROM EventTables
WHERE [EDate] BETWEEN @Start AND @End
    AND [Name] LIKE '%' + @Readers + '%' OR [Description] LIKE '%' + @Readers + '%'
ORDER BY 'Date (UTC -7hrs)' desc
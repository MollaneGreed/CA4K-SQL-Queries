DECLARE @Start NVARCHAR(100) = '2025-05-22 16:00:00';
    -- Alternative Start Option
    -- DECLARE @Start NVARCHAR(100) = 'DATEADD(DAY, -1, CAST(GETDATE() AS DATE))'
DECLARE @End NVARCHAR(100) = '2025-05-25 16:00:00';
    -- Alternative End Option
    -- DECLARE @End NVARCHAR(100) = DATEADD(DAY, 1, CAST(GETDATE() AS DATE))

WITH ArchiveEvents AS (
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
FROM ArchiveEvents
WHERE [EDate] BETWEEN @Start AND @End
AND [Description] IN ('Download Operator Request','Download Started','Download Complete')
ORDER BY [EDate] ASC



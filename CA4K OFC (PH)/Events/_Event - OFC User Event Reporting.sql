--This Query is able to check for all events that occur between the specified times on multiple days.
--DECLARE @Start NVARCHAR(100) = '2025-03-14 16:00:00';
--DECLARE @End NVARCHAR(100) = '2025-03-21 16:00:00';
DECLARE @EmployeeID NVARCHAR(100) = '9000001';

DECLARE @StartDate NVARCHAR(100) = '2025-03-14';
DECLARE @EndDate NVARCHAR(100) = '2025-03-22';

DECLARE @Start DATETIMEOFFSET = CAST(@StartDate + ' 00:00:00' AS DATETIME) AT TIME ZONE 'Singapore Standard Time';
DECLARE @End DATETIMEOFFSET = CAST(@EndDate + ' 00:00:00' AS DATETIME) AT TIME ZONE 'Singapore Standard Time';



WITH ArchiveEvents AS (
    SELECT
    [EDate],
    [Class],
    [Description],
    [Name],
    [Badge]
    FROM [CardAccessliveEventsPH].[dbo].[Event]
    WHERE [EDate] BETWEEN @Start AND @End
    AND [Description] LIKE '%' + @EmployeeID + '%'
UNION ALL
    SELECT
    [EDate],
    [Class],
    [Description],
    [Name],
    [Badge]
    FROM [CardAccessArchiveEventsPH].[dbo].[Event]
    WHERE [EDate] BETWEEN @Start AND @End
    AND [Description] LIKE '%' + @EmployeeID + '%'
UNION ALL
	SELECT
    [EDate],
    [Class],
    [Description],
    [Name],
    [Badge]
    FROM [CardAccessArchiveEventsPH_2].[dbo].[Event]
    WHERE [EDate] BETWEEN @Start AND @End
    AND [Description] LIKE '%' + @EmployeeID + '%'
    )
SELECT 
    Format([EDate] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time', 'MM/dd/yyyy HH:mm:ss') AS [CST_Time],
    Format([EDate] AT TIME ZONE 'UTC' AT TIME ZONE 'Singapore Standard Time', 'MM/dd/yyyy HH:mm:ss') AS [Manila_Time],
    [Class] 'Event Type',
    [Description] 'Event Source',
    [Name] 'Event Location',
    [Badge]
FROM ArchiveEvents
WHERE [EDate] BETWEEN @Start AND @End
ORDER BY [Manila_Time] ASC

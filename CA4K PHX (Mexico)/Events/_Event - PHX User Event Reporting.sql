--This Query is able to check for all events that occur between the specified times on multiple days.
--DECLARE @Start NVARCHAR(100) = '2025-03-14 16:00:00';
--DECLARE @End NVARCHAR(100) = '2025-03-21 16:00:00';
DECLARE @EmployeeID NVARCHAR(100) = '3000620';

DECLARE @StartDate NVARCHAR(100) = '2025-03-01';
DECLARE @EndDate NVARCHAR(100) = '2026-05-19';

DECLARE @Start DATETIMEOFFSET = CAST(@StartDate + ' 00:00:00' AS DATETIME) AT TIME ZONE 'Central Standard Time';
DECLARE @End DATETIMEOFFSET = CAST(@EndDate + ' 00:00:00' AS DATETIME) AT TIME ZONE 'Central Standard Time';



WITH ArchiveEvents AS (
    SELECT
    [EDate],
    [Class],
    [Description],
    [Name],
    [Badge],
    [Ca4kdb] = '01-Live'
    FROM [CardAccessliveEventsMX].[dbo].[Event]
    WHERE [EDate] BETWEEN @Start AND @End
    AND [Description] LIKE '%' + @EmployeeID + '%'
UNION ALL
    SELECT
    [EDate],
    [Class],
    [Description],
    [Name],
    [Badge],
    [Ca4kdb] = '02-Archive'
    FROM [CardAccessArchiveEventsMX].[dbo].[Event]
    WHERE [EDate] BETWEEN @Start AND @End
    AND [Description] LIKE '%' + @EmployeeID + '%'
UNION ALL
	SELECT
    [EDate],
    [Class],
    [Description],
    [Name],
    [Badge],
    [Ca4kdb] = '03-archive_2'
    FROM [CardAccessArchiveEventsMX_2].[dbo].[Event]
    WHERE [EDate] BETWEEN @Start AND @End
    AND [Description] LIKE '%' + @EmployeeID + '%'
    )
SELECT 
    [EDate],
    [Class] 'Event Type',
    [Description] 'Event Source',
    [Name] 'Event Location',
    [Badge],
    [Ca4kdb]
FROM ArchiveEvents
WHERE [EDate] BETWEEN @Start AND @End
ORDER BY [EDate] DESC

--This Query is able to check for all events that occur between the specified times on multiple days.
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE
    @Start DATE = DATEADD(DAY, -1, GETDATE())
    ,@End DATE = DATEADD(DAY, 1, GETDATE())
    ,@EmployeeID varchar(10) = '70384'
    ;
SELECT
*
FROM [CardAccessLiveEventsUS].[dbo].[Event]
WHERE ([Description] LIKE '%' + @EmployeeID + '%' OR [Name] LIKE '%' + @EmployeeID + '%')
AND [EDate] BETWEEN @Start AND @End
ORDER BY [EDate] DESC
;
WITH ArchiveEvents AS (
    SELECT
    [EDate],
    [Class],
    [Description],
    [Name],
    'Live' as SourceTable
    FROM [CardAccessLiveEventsUS].[dbo].[Event]
    WHERE [EDate] BETWEEN @Start AND @End
    AND ([Description] LIKE '%' + @EmployeeID + '%' OR [Name] LIKE '%' + @EmployeeID + '%')
UNION ALL
    SELECT
    [EDate],
    [Class],
    [Description],
    [Name],
    'Archive' as SourceTable
    FROM [CardAccessArchiveEventsUS].[dbo].[Event]
    WHERE [EDate] BETWEEN @Start AND @End
    AND ([Description] LIKE '%' + @EmployeeID + '%' OR [Name] LIKE '%' + @EmployeeID + '%')
UNION ALL
	SELECT
    [EDate],
    [Class],
    [Description],
    [Name],
    'Archive_2' as SourceTable
    FROM [CardAccessArchiveEventsUS_2].[dbo].[Event]
    WHERE [EDate] BETWEEN @Start AND @End
    AND ([Description] LIKE '%' + @EmployeeID + '%' OR [Name] LIKE '%' + @EmployeeID + '%')
    )
SELECT 
    [EDate] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time' AS [CST_Time],
    [Class] 'Event Type',
    [Description] 'Event Source',
    [Name] 'Event Location',
    SourceTable
FROM ArchiveEvents
ORDER BY [EDate] DESC

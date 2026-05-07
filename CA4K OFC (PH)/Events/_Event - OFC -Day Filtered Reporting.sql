--This Query is able to check for badge events over a 7day period. 

DECLARE 
    @EmployeeIDFilter varchar(10) = 'True',
    @EmployeeID VARCHAR(10)= '9021048',
    @DeviceFilter varchar(10) = 'False',
    @Device varchar(10) = 'Pnl52',
    @EventStart DATETIME = '2026-4-15',
    @EventEnd DATETIME = '2026-4-16';
DECLARE -- Set the start date
    @Start DATETIME = (@EventStart AT TIME ZONE 'Singapore Standard Time') AT TIME ZONE 'UTC',
    @End DATETIME = (@EventEnd AT TIME ZONE 'Singapore Standard Time') AT TIME ZONE 'UTC';

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
    --AND [Badge] != '0'
    AND (@DeviceFilter <> 'True' OR [Name] LIKE '%' + @Device + '%')
    AND (@EmployeeIDFilter <> 'True' OR [Description] LIKE '%' + @EmployeeID + '%') OR [Class] LIKE 'PANEL' + '%'
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
    --AND [Badge] != '0'
    AND (@DeviceFilter <> 'True' OR [Name] LIKE '%' + @Device + '%')
    AND (@EmployeeIDFilter <> 'True' OR [Description] LIKE '%' + @EmployeeID + '%') OR [Class] LIKE 'PANEL' + '%'
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
    --AND [Badge] != '0'
    AND (@DeviceFilter <> 'True' OR [Name] LIKE '%' + @Device + '%')
    AND (@EmployeeIDFilter <> 'True' OR [Description] LIKE '%' + @EmployeeID + '%') OR [Class] LIKE 'PANEL' + '%'
    )
-- Create a view of all the data collected from the Event tables that were stored in "ArchiveEvents"
SELECT 
    [EDate] UTC,
    ([EDate] AT TIME ZONE 'UTC') AT TIME ZONE 'Central Standard Time' AS 'EDate as CST',
    ([EDate] AT TIME ZONE 'UTC') AT TIME ZONE 'Singapore Standard Time' AS 'EDate as SST',
    --DATEADD(MINUTE, [UTCOffset], [EDate]) AS 'Date CST (UTC -7hrs )',
    [Class] 'Event Type',
    [Description] + ' (' + convert(varchar, [Badge] )  + ')' AS 'Event Source',
    [Name] 'Event Location',
    [AckTStamp] AS 'Acknowledged (UTC)'
FROM ArchiveEvents
WHERE [EDate] BETWEEN @Start AND @End
ORDER BY [EDate] ASC
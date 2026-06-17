--This Query is able to check for badge events over a 7day period. 

DECLARE 
    @EmployeeIDFilter varchar(10) = 'True',
    @EmployeeID VARCHAR(10)= '9047976',
    @DeviceFilter varchar(10) = 'False',
    @Device varchar(10) = '85088';
DECLARE -- Set the start date
    @StartDate DATE = '2026-5-7';
DECLARE -- Do not change the following values they must be setup as individual declares in order to be referenced
    @Start DATETIMEOFFSET = CAST(@StartDate AS DATETIME) AT TIME ZONE 'Singapore Standard Time';
DECLARE -- Do not change the following values they must be setup as an isolated declare
    @End DATETIMEOFFSET = DATEADD(SECOND, 86399, DATEADD(DAY, 7, @Start));

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
    AND [Badge] != '0'
    AND (@DeviceFilter <> 'True' OR [Name] LIKE '%' + @Device + '%')
    AND (@EmployeeIDFilter <> 'True' OR [Description] LIKE '%' + @EmployeeID + '%')
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
    AND [Badge] != '0'
    AND (@DeviceFilter <> 'True' OR [Name] LIKE '%' + @Device + '%')
    AND (@EmployeeIDFilter <> 'True' OR [Description] LIKE '%' + @EmployeeID + '%')
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
    AND [Badge] != '0'
    AND (@DeviceFilter <> 'True' OR [Name] LIKE '%' + @Device + '%')
    AND (@EmployeeIDFilter <> 'True' OR [Description] LIKE '%' + @EmployeeID + '%')
    )

-- Create a view of all the data collected from the Event tables that were stored in "ArchiveEvents"
SELECT 
    --[EDate] UTC,
    --([EDate] AT TIME ZONE 'UTC') AT TIME ZONE 'Central Standard Time' AS 'EDate as CST',
    --([EDate] AT TIME ZONE 'UTC') AT TIME ZONE 'Singapore Standard Time' AS 'EDate as SST',
    --DATEADD(MINUTE, [UTCOffset], [EDate]) AS 'Date CST (UTC -7hrs )',
    [Class] 'Event Type',
    [Description] + ' (' + convert(varchar, [Badge] )  + ')' AS 'Event Source',
    [Name] 'Event Location',
    DATEADD(HOUR, -7, [AckTStamp]) AS 'Acknowledged (UTC -7hrs)'
FROM ArchiveEvents
WHERE [EDate] BETWEEN @Start AND @End
ORDER BY [EDate] DESC
--This Query is able to check for badge events over a 7day period. 

DECLARE 
    @EmployeeOrReaderFilter varchar(10) = 'true',
    @EmployeeOrReader VARCHAR(10)= '86052% OUT',
    @PanelFilter varchar(10) = 'false',
    @Panel varchar(10) = '',
    @EventStart DATETIME = '2026-5-22',
    @EventEnd DATETIME = '2026-5-23';
DECLARE -- Set the start date
    @Start DATETIME = (@EventStart AT TIME ZONE 'Singapore Standard Time') AT TIME ZONE 'UTC',
    @End DATETIME = (@EventEnd AT TIME ZONE 'Singapore Standard Time') AT TIME ZONE 'UTC';

-- Collects data from the 3 Event databases and stores tham as "ArchiveEvents"
WITH ArchiveEvents AS (
    SELECT
    [EDate],
    [Priority],
    [Class],
    [Description],
    [Name],
    [UTCOffset],
    [AckTStamp],
    [Badge],
    [Ca4kdb] ='01 - Live Events'
    FROM [CardAccessliveEventsPH].[dbo].[Event]
    WHERE [EDate] BETWEEN @Start AND @End
    --AND [Badge] != '0'
    --AND (@PanelFilter <> 'True' OR [Name] LIKE '%' + @Panel + '%')
    --AND (@PanelFilter <> 'True' OR [Class] LIKE 'PANEL' + '%')
    AND (@PanelFilter <> 'True' OR ([Name] LIKE '%' + @Panel + '%' OR [Class] LIKE 'PANEL' + '%'))
    AND (@EmployeeOrReaderFilter <> 'True' OR ([Description] LIKE '%' + @EmployeeOrReader + '%' OR [Name] LIKE '%' + @EmployeeOrReader + '%'))
UNION ALL
    SELECT
    [EDate],
    [Priority],
    [Class],
    [Description],
    [Name],
    [UTCOffset],
    [AckTStamp],
    [Badge],
    [Ca4kdb] ='02 - Archive Events'
    FROM [CardAccessArchiveEventsPH].[dbo].[Event]
    WHERE [EDate] BETWEEN @Start AND @End
    --AND [Badge] != '0'
    --AND (@PanelFilter <> 'True' OR [Name] LIKE '%' + @Panel + '%')
    --AND (@PanelFilter <> 'True' OR [Class] LIKE 'PANEL' + '%')
    AND (@PanelFilter <> 'True' OR ([Name] LIKE '%' + @Panel + '%' OR [Class] LIKE 'PANEL' + '%'))
    AND (@EmployeeOrReaderFilter <> 'True' OR ([Description] LIKE '%' + @EmployeeOrReader + '%' OR [Name] LIKE '%' + @EmployeeOrReader + '%'))
UNION ALL
	SELECT
    [EDate],
    [Priority],
    [Class],
    [Description],
    [Name],
    [UTCOffset],
    [AckTStamp],
    [Badge],
    [Ca4kdb] ='03 - Archive Events 2'
    FROM [CardAccessArchiveEventsPH_2].[dbo].[Event]
    WHERE [EDate] BETWEEN @Start AND @End
    --AND [Badge] != '0'
    --AND (@PanelFilter <> 'True' OR [Name] LIKE '%' + @Panel + '%')
    --AND (@PanelFilter <> 'True' OR [Class] LIKE 'PANEL' + '%')
    AND (@PanelFilter <> 'True' OR ([Name] LIKE '%' + @Panel + '%' OR [Class] LIKE 'PANEL' + '%'))
    AND (@EmployeeOrReaderFilter <> 'True' OR ([Description] LIKE '%' + @EmployeeOrReader + '%' OR [Name] LIKE '%' + @EmployeeOrReader + '%'))
    )
-- Create a view of all the data collected from the Event tables that were stored in "ArchiveEvents"
SELECT
    [EDate] '          UTC   ',
    ([EDate] AT TIME ZONE 'UTC') AT TIME ZONE 'Central Standard Time' AS 'EDate as CST',
    --([EDate] AT TIME ZONE 'UTC') AT TIME ZONE 'Singapore Standard Time' AS 'EDate as SST',
    --DATEADD(MINUTE, [UTCOffset], [EDate]) AS 'Date CST (UTC -7hrs )',
    [Class] + ' - ' + convert(VARCHAR,[Priority]) 'Event Type [Class - Proirity]',
    [Description] + ' (' + convert(varchar, [Badge] )  + ')' AS 'Event Source [Description]',
    [Name] 'Event Location [Name]',
    [AckTStamp] AS 'Acknowledged (UTC)',
    [Ca4kdb]
FROM ArchiveEvents
ORDER BY [EDate] DESC
DECLARE
    @Start DATE = DATEADD(DAY, -7, GETDATE())
    --@Start DATE = '2026-04-02'
    ,@End DATE = DATEADD(DAY, 0, GETDATE())
    --,@End DATE = '2026-03-18'
    ,@DeviceFilter varchar(10) = 'false'
    ,@Device varchar(10) = '86019'
    ;

-- Collects data from the 3 Event databases and stores tham as "ArchiveEvents"
WITH ArchiveEvents AS (
    SELECT
    [Class]
    ,[Description]
    FROM [CardAccessliveEventsPH].[dbo].[Event]
    WHERE [EDate] BETWEEN @Start AND @End
    AND [Class] = 'SCRIPT EXECUTED'
    AND (@DeviceFilter <> 'True' OR [Description] LIKE '%' + @Device + '%')
    AND [Description] NOT LIKE '%alid Badges'
UNION ALL
    SELECT
    [Class]
    ,[Description]
    FROM [CardAccessArchiveEventsPH].[dbo].[Event]
    WHERE [EDate] BETWEEN @Start AND @End
    AND [Class] = 'SCRIPT EXECUTED'
    AND (@DeviceFilter <> 'True' OR [Description] LIKE '%' + @Device + '%')
    AND [Description] NOT LIKE '%alid Badges'
UNION ALL
	SELECT
    [Class]
    ,[Description]
    FROM [CardAccessArchiveEventsPH_2].[dbo].[Event]
    WHERE [EDate] BETWEEN @Start AND @End
    AND [Class] = 'SCRIPT EXECUTED'
    AND (@DeviceFilter <> 'True' OR [Description] LIKE '%' + @Device + '%')
    AND [Description] NOT LIKE '%alid Badges'
    )

SELECT
    [Class]
    ,LEFT([Description],4) AS 'Script ID'
    ,RIGHT([Description],(LEN([Description])-16)) AS 'Door Name'
    ,COUNT([Description]) AS 'Event Count'
    ,convert(varchar,(DATEDIFF(HOUR, @Start,@End )*60/10)) AS 'Max events'
  FROM ArchiveEvents
    GROUP BY [Class], [Description]
    ORDER BY 'Event Count' DESC
DECLARE
    @Start DATE = DATEADD(DAY, -1, GETDATE())
    ,@End DATE = DATEADD(DAY, 1, GETDATE())
   --@Start DATE = '2026-03-11',
   --@End DATE = '2026-03-18'
    ,@DeviceFilter varchar(10) = 'False'
    ,@Device varchar(10) = '86019'
    ;
-- Collects data from the 3 Event databases and stores tham as "ArchiveEvents"
WITH ArchiveEvents AS (
    SELECT
    [Class]
    ,[Description]
    ,[Name]
    ,[EDate]
    FROM [CardAccessliveEventsPH].[dbo].[Event]
    WHERE [EDate] BETWEEN @Start AND @End
    --AND [Class] = 'SCRIPT EXECUTED'
    AND [Class] <> 'DOOR Forced Open'
    AND ((@DeviceFilter <> 'True' AND [Class] = 'DOOR Open too Long') OR ([Description] LIKE '%' + @Device + '%' OR [Name] LIKE '%' + @Device + '%'))
    AND [Description] NOT LIKE '%OUT%'
UNION ALL
    SELECT
    [Class]
    ,[Description]
    ,[Name]
    ,[EDate]
    FROM [CardAccessArchiveEventsPH].[dbo].[Event]
    WHERE [EDate] BETWEEN @Start AND @End
    --AND [Class] = 'SCRIPT EXECUTED'
    AND [Class] <> 'DOOR Forced Open'
    AND ((@DeviceFilter <> 'True' AND [Class] = 'DOOR Open too Long') OR ([Description] LIKE '%' + @Device + '%' OR [Name] LIKE '%' + @Device + '%'))
    AND [Description] NOT LIKE '%OUT%'
UNION ALL
	SELECT
    [Class]
    ,[Description]
    ,[Name]
    ,[EDate]
    FROM [CardAccessArchiveEventsPH_2].[dbo].[Event]
    WHERE [EDate] BETWEEN @Start AND @End
    --AND [Class] = 'SCRIPT EXECUTED'
    AND [Class] <> 'DOOR Forced Open'
    AND ((@DeviceFilter <> 'True' AND [Class] = 'DOOR Open too Long') OR ([Description] LIKE '%' + @Device + '%' OR [Name] LIKE '%' + @Device + '%'))
    --AND [Description] NOT LIKE '%OUT%'
    )

SELECT
    [Class]
    ,[Description]
    ,[Name]
    ,[EDate]
  FROM ArchiveEvents
  ORDER BY [EDate] DESC
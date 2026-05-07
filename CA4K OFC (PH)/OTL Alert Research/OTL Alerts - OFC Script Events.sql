DECLARE
     --@Start DATE = DATEADD(DAY, -1, GETDATE())
     @Start DATE = '2026-03-13'
    ,@End DATE = DATEADD(DAY, 1, GETDATE())
    --,@End DATE = '2026-03-18'
    ;
-- Collects data from the 3 Event databases and stores tham as "ArchiveEvents"
WITH ArchiveEvents AS (
    SELECT
    [Class]
    ,[Description]
    ,[EDate]
    FROM [CardAccessliveEventsPH].[dbo].[Event]
    WHERE [EDate] BETWEEN @Start AND @End
    AND [Class] = 'SCRIPT EXECUTED'
UNION ALL
    SELECT
    [Class]
    ,[Description]
    ,[EDate]
    FROM [CardAccessArchiveEventsPH].[dbo].[Event]
    WHERE [EDate] BETWEEN @Start AND @End
    AND [Class] = 'SCRIPT EXECUTED'
UNION ALL
	SELECT
    [Class]
    ,[Description]
    ,[EDate]
    FROM [CardAccessArchiveEventsPH_2].[dbo].[Event]
    WHERE [EDate] BETWEEN @Start AND @End
    AND [Class] = 'SCRIPT EXECUTED'
    )

SELECT
    [Class]
    ,[Description]
    ,[EDate]
  FROM ArchiveEvents
  ORDER BY [EDate] DESC
/*
-- Set your start date here
DECLARE @Start DATE = '2024-05-14 00:00:00.000',
        @End DATE = '2024-03-15 00:00:00.000';

-- Set the database name
DECLARE @Database NVARCHAR(128) = 'CardAccessLiveEventsPH';


-- Construct the dynamic SQL query
DECLARE @DynamicSQL NVARCHAR(MAX);
SET @DynamicSQL = N'
    USE ' + QUOTENAME(@Database) + N'; -- Switch to the specified database

    SELECT
        e.Description AS Reader,
        e.PnlNo AS Panel#,
        e.DeviceNo AS Reader#,
        SUM(CASE WHEN e.EDate BETWEEN ''' + CONVERT(NVARCHAR(10), @Start, 120) + N''' AND ''' + CONVERT(NVARCHAR(10), @End, 120) + N''' THEN 1 ELSE 0 END) AS [' + CONVERT(NVARCHAR(10), @Start, 120) + N']
    FROM
        [dbo].[Event] as e -- Assuming the table is in the specified database
    LEFT Join [CardAccessLiveConfigurationPH].dbo.Reader as r ON r.RdrNo = e.DeviceNo AND r.PnlNo = e.Pnlno
    WHERE
        [Class] = ''DOOR Open too Long''
    GROUP BY
        e.PnlNo, e.DeviceNo, e.ReaderName
    ORDER BY
        e.PnlNo, e.DeviceNo; -- Order by Reader
';

-- Execute the dynamic SQL query
EXEC sp_executesql @DynamicSQL;
*/

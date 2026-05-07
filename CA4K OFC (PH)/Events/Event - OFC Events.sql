DECLARE @Start DATE = DATEADD(DAY, -1, GETUTCDATE());
DECLARE @End DATE = GETUTCDATE();

WITH EventsDB AS (
    -- Get data from Desired Tables and join them
        SELECT
            [Edate],
            [PnlNo],
            [DeviceNo],
            [Class],
            [Description],
            [Name]
            FROM [CardAccessLiveEventsPH].[dbo].[Event]
    UNION ALL
        SELECT
            [Edate],
            [PnlNo],
            [DeviceNo],
            [Class],
            [Description],
            [Name]
            FROM [CardAccessArchiveEventsPH].[dbo].[Event]
                WHERE Edate BETWEEN @Start AND @End
    UNION ALL
        SELECT
            [Edate],
            [PnlNo],
            [DeviceNo],
            [Class],
            [Description],
            [Name]
            FROM [CardAccessArchiveEventsPH_2].[dbo].[Event]
                WHERE Edate BETWEEN @Start AND @End
    )
    
SELECT
    DATEADD(HH,-6, e.EDATE) 'EDAte -6',
    --e.[Edate] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time' 'CST -6',
    convert(varchar, e.[PnlNo]) + '-' + convert(varchar, e.[DeviceNo]) 'Pnl - Rdr',
    e.[Class],
    e.[Description],
    e.[Name]
--FROM [CardAccessLiveEventsPH].[dbo].[EventClassCategoryDefs] ECat
FROM EventsDB e
 --LEFT JOIN [CardAccessLiveEventsPH].[dbo].[EventClassCategoryDefs] ECat ON ECat.[EventClassCatID] = e.[Cat]
--WHERE e.[EDate] >= GETUTCDATE()
WHERE e.[Description] LIKE '9000004, Gojo, Rodel'
--    AND e.[Name] LIKE '%83024%'
ORDER BY e.[Edate] DESC;
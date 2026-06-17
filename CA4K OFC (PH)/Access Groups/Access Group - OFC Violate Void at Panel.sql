DECLARE
    @start DATE = DATEADD(DAY, 0, CAST(GETDATE() AS DATE)),
    @end DATE = DATEADD(DAY, 1, CAST(GETDATE() AS DATE));


WITH ViolateVoidEvents AS (
    SELECT
        [EDATE],
        [Class],
        [PnlNo],
        [DeviceNo],
        [Name]
    FROM [CardAccessLiveEventsPH].[dbo].[Event]
    WHERE [EDate] BETWEEN @start AND @end
    AND [CLASS] LIKE 'BADGE Violate Void at Panel%'
UNION ALL
    SELECT
        [EDATE],
        [Class],
        [PnlNo],
        [DeviceNo],
        [Name]
    FROM [CardAccessArchiveEventsPH].[dbo].[Event]
    WHERE [EDate] BETWEEN @start AND @end
    AND [CLASS] LIKE 'BADGE Violate Void at Panel%'
UNION ALL
    SELECT
        [EDATE],
        [Class],
        [PnlNo],
        [DeviceNo],
        [Name]
    FROM [CardAccessArchiveEventsPH_2].[dbo].[Event]
    WHERE [EDate] BETWEEN @start AND @end
    AND [CLASS] LIKE 'BADGE Violate Void at Panel%'
)
SELECT
*
FROM ViolateVoidEvents
ORDER BY [EDATE] DESC
DECLARE @Panel INT = 2;
DECLARE @Device INT = 6;
DECLARE @Start DATE = DATEADD(DAY, -14, GETUTCDATE());
DECLARE @End DATE = GETUTCDATE();
        

WITH RankedEvents AS (
  SELECT
    [PnlNo],
    [DeviceNo],
    [Description],
    [Class],
    [AckTStamp],
    ROW_NUMBER() OVER (PARTITION BY [Description] ORDER BY [AckTStamp] DESC) AS rn
  FROM [CardAccessLiveEventsPH].[dbo].[Event]
    WHERE [Badge] = 0
    and [Class] != 'SYSTEM'
    AND [AckTStamp] BETWEEN @Start and @End
    --AND [CAT] not in ('10','1','3')
    --AND [PnlNo] not in ('1')
    UNION ALL
  SELECT
    [PnlNo],
    [DeviceNo],
    [Description],
    [Class],
    [AckTStamp],
    ROW_NUMBER() OVER (PARTITION BY [Description] ORDER BY [AckTStamp] DESC) AS rn
  FROM [CardAccessarchiveEventsPH].[dbo].[Event]
    WHERE [Badge] = 0
    and [Class] != 'SYSTEM'
    AND [AckTStamp] BETWEEN @Start and @End
    UNION ALL
  SELECT
    [PnlNo],
    [DeviceNo],
    [Description],
    [Class],
    [AckTStamp],
    ROW_NUMBER() OVER (PARTITION BY [Description] ORDER BY [AckTStamp] DESC) AS rn
  FROM [CardAccessarchiveEventsPH_2].[dbo].[Event]
    WHERE [Badge] = 0
    and [Class] != 'SYSTEM'
    AND [AckTStamp] BETWEEN @Start and @End
)
SELECT
    *
FROM RankedEvents re
    WHERE rn <= 2
    AND [Description] LIKE '%' + '83016' + '%'
ORDER BY re.[PnlNo], re.[DeviceNo];

/*
-- Next query
WITH DeviceEvents AS (
    SELECT
        [PnlNo],
        [DeviceNo],
        [Description],
        [Class],
        [AckTStamp]
    FROM [CardAccessLiveEventsPH].[dbo].[Event]
    WHERE [Badge] = 0
    AND [PnlNo] = @Panel
    AND [DeviceNo] = @Device
)
SELECT
    *
FROM DeviceEvents de
ORDER BY de.[PnlNo], de.[DeviceNo];
*/
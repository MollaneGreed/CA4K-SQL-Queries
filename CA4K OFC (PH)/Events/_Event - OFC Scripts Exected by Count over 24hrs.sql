-- Run from the OFC SQL Server.
DECLARE @Start NVARCHAR(100) = DATEADD(DAY, -2, GETDATE());
DECLARE @End NVARCHAR(100) = GETDATE();

WITH ScriptEvents AS (
  SELECT
    [DESCRIPTION],
    [class],
    [EDate]
  FROM [CardAccessliveEventsPH].[dbo].[Event]
    WHERE [EDate] BETWEEN @Start AND @End
    AND [Class] = 'SCRIPT EXECUTED'
UNION ALL
  SELECT
    [DESCRIPTION],
    [class],
    [EDate]
  FROM [CardAccessArchiveEventsPH].[dbo].[Event]
  WHERE [EDate] BETWEEN @Start AND @End
    AND [Class] = 'SCRIPT EXECUTED'
UNION ALL
	SELECT
    [DESCRIPTION],
    [class],
    [EDate]
  FROM [CardAccessArchiveEventsPH_2].[dbo].[Event]
  WHERE [EDate] BETWEEN @Start AND @End
    AND [Class] = 'SCRIPT EXECUTED'
    )
SELECT
    LEFT([DESCRIPTION],4) 'Script #',
    SUBSTRING([Description], 17,40) AS 'Door Name',
    [class] 'Event Type',
    COUNT([Description]) AS 'Event Count'
FROM ScriptEvents
  --WHERE [Description] LIKE '%SD OFFICE IN%'
GROUP BY [DESCRIPTION], [Class]
ORDER BY 'Event Count' DESC;
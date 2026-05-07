DECLARE
     --@Start DATE = DATEADD(DAY, -1, GETDATE())
     @Start DATE = '2026-04-16'
    ,@End DATE = '2026-04-17'
    ,@EmployeeID VARCHAR(10)= '9062127'
    ,@EmployeeID2 VARCHAR(10)= '9065227'
    ,@EmployeeID3 VARCHAR(10)= '9047442'
    --,@End DATE = '2026-03-18'
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
    AND ([Class] = 'SCRIPT EXECUTED' 
    OR [Description] LIKE '%' + @EmployeeID + '%'
    OR [Description] LIKE '%' + @EmployeeID2 + '%'
    OR [Description] LIKE '%' + @EmployeeID3 + '%'
    ))

SELECT
    --[Class]
    [Description] AS '------------------- Alert / User ----------------------'
    ,[Name] AS '------------- Door / Source ----------'
    ,[EDate]
    --,GETDATE() AT TIME ZONE 'UTC' AS 'Current Time'
  FROM ArchiveEvents
  ORDER BY [EDate] DESC

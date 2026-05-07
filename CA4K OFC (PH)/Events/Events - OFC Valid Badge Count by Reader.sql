--Count of Badge Event Types by Day on Specified Panel and Readers
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT
    CONVERT(Date, e.[edate]) 'Event Date',
    e.Class 'Event Type',
    COUNT(e.class) 'Event Count',
    e.PnlNo 'Panel Number',
    e.DeviceNo 'Reader Number'    
FROM [CardAccessLiveEventsPH].[dbo].[Event] e
INNER JOIN [CardAccessArchiveEventsPH].[dbo].[Event] e2 ON (CONVERT(Date, e.edate) = CONVERT(Date, e2.edate) AND e.Class = e2.class AND e.PnlNo = e2.PnlNo AND e.DeviceNo = e2.DeviceNo)
WHERE 
   CONVERT(Date,e.EDate)
--Starting Date Range
    BETWEEN '2023-12-1' 
--Ending Date Range
    AND '2023-12-15'
--Specify Panel Number
    AND e.PnlNo = 1
--Specify Reader Number
    AND e.DeviceNo = 3
-- Group returned values from left to right
GROUP BY  CONVERT(Date,e.EDate),e.Class,e.PnlNo,e.DeviceNo;
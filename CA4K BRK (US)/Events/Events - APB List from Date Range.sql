-- Run against the SQL Database
-- All Events within a specific date range.
SELECT TOP (2000) 
       [PnlNo]
      ,[DeviceNo]
      ,[EDate]
      ,[Badge]
      ,[Class]
      ,[Description]
      ,[Name]
      
  FROM [CardAccessArchiveEventsUS].[dbo].[Event]
  WHERE [Class] = 'BADGE Violate APB'
  and EDate BETWEEN '2022-11-14 07:02:02' and '2022-11-17'
  
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
      
  FROM [CardAccessArchiveEventsMX].[dbo].[Event]
  WHERE [Class] = 'BADGE Violate APB'
  and EDate BETWEEN '2022-11-14 00:00:00.000' and '2022-11-17 00:00:00.000';
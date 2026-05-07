SELECT TOP (200) 
      [PnlNo]
      ,[DeviceNo]
      ,[EDate]
      ,[Badge]
      ,[Class]
      ,[Description]
      ,[Name]
      
  FROM [CardAccessArchiveEventsUS].[dbo].[Event]
  WHERE [Class] = 'BADGE Violate APB'
  and EDate BETWEEN '2022-08-01' and '2022-10-25 20:49:20'
  --and PnlNo IN('3')
  --and DeviceNo IN ('3','4')
  and PnlNo IN('12')
  and DeviceNo IN ('1','2')
  --ORDER BY EDate DESC
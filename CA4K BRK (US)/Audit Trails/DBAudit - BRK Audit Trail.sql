-- Run on SQL server
WITH CombinedData AS (
  SELECT *
    FROM [CardAccessliveeventsUS].[dbo].[DBAudit]
	  WHERE [Actions] != ('L')
	  AND TableName NOT IN ('ArchiveSettings', 'UserFields')
    --AND OperatorName NOT IN ('cic','admin','BLOOMINGTON\SQLPROXYENT')
UNION ALL
  SELECT *
    FROM [CardAccessliveConfigurationUS].[dbo].[DBAudit]
  	  WHERE [Actions] != ('L')
      AND TableName NOT IN ('ArchiveSettings', 'UserFields')
    --AND OperatorName NOT IN ('cic','admin','BLOOMINGTON\SQLPROXYENT')
UNION ALL
  SELECT *
    FROM [CardAccessarchiveeventsUS].[dbo].[DBAudit]
  	  WHERE [Actions] != ('L')
      AND TableName NOT IN ('ArchiveSettings', 'UserFields')
    --AND OperatorName NOT IN ('cic','admin','BLOOMINGTON\SQLPROXYENT')
UNION ALL
  SELECT *
    FROM [CardAccessarchiveConfigurationUS].[dbo].[DBAudit]
	  WHERE [Actions] != ('L')
	  AND TableName NOT IN ('ArchiveSettings', 'UserFields')
    --AND OperatorName NOT IN ('cic','admin','BLOOMINGTON\SQLPROXYENT')
    )
SELECT
      [RevisionStamp] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time' AS [CST_Time]
      ,[TableName]
      ,[OperatorName]
      ,[StationName]
	,CASE
        WHEN [Actions] = 'U' THEN 'Update'
        WHEN [Actions] = 'D' THEN 'Delete'
        WHEN [Actions] = 'I' THEN 'Insert'
        Else [Actions]
      END 'Action'	  
      ,[Description]
      ,[ChangedColumns]
      ,[OldData]
      ,[NewData]
FROM CombinedData
    --Where [Actions] = 'D' AND [OperatorName] = 'LoganElam'
    WHERE [Description] LIKE '%70384%'
    ORDER BY CST_Time DESC 



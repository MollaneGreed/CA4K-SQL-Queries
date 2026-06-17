-- Run on SQL server
DECLARE @Start DATE = DATEADD(DAY, -90, GETUTCDATE()),
        @End DATE = DATEADD(DAY, +1, GETUTCDATE()),
        @DeviceFilter varchar(10) = 'false',
        @Device varchar(10) = '8601%';
        
WITH CombinedData AS (
  -- Collect Data from each table and combine it.
    SELECT
      [RevisionStamp],
      [TableName],
      [OperatorName],
      [StationName],
      [Actions],
      [Description],
      [ChangedColumns],
      CONVERT(VARCHAR(MAX), [OldData]) AS OldData,
      CONVERT(VARCHAR(MAX), [NewData]) AS NewData,
      [CA4KDB] ='01 - Live Events'
      FROM [CardAccessliveeventsUS].[dbo].[DBAudit]
        WHERE [Actions] IN ('U','D','I')
        AND TableName IN ('Reader')
        AND (@DeviceFilter <> 'True' OR [Description] LIKE '%' + @Device + '%')
        --AND OperatorName NOT IN ('cic','admin','BLOOMINGTON\SQLPROXYENT')
        AND [RevisionStamp] BETWEEN @Start and @End
  UNION ALL
    SELECT
      [RevisionStamp],
      [TableName],
      [OperatorName],
      [StationName],
      [Actions],
      [Description],
      [ChangedColumns],
      CONVERT(VARCHAR(MAX), [OldData]) AS OldData,
      CONVERT(VARCHAR(MAX), [NewData]) AS NewData,
     [CA4KDB] = '02 - Live Config'
      FROM [CardAccessliveConfigurationUS].[dbo].[DBAudit]
        WHERE [Actions] IN ('U','D','I')
        AND TableName IN ('Reader')
        AND (@DeviceFilter <> 'True' OR [Description] LIKE '%' + @Device + '%')
        --AND OperatorName NOT IN ('cic','admin','BLOOMINGTON\SQLPROXYENT')
        AND [RevisionStamp] BETWEEN @Start and @End
  UNION ALL
    SELECT
      [RevisionStamp],
      [TableName],
      [OperatorName],
      [StationName],
      [Actions],
      [Description],
      [ChangedColumns],
      CONVERT(VARCHAR(MAX), [OldData]) AS OldData,
      CONVERT(VARCHAR(MAX), [NewData]) AS NewData,
      [CA4KDB] ='03 - Archive Events'
      FROM [CardAccessarchiveeventsUS].[dbo].[DBAudit]
        WHERE [Actions] IN ('U','D','I')
        AND TableName IN ('Reader')
        AND (@DeviceFilter <> 'True' OR [Description] LIKE '%' + @Device + '%')
        --AND OperatorName NOT IN ('cic','admin','BLOOMINGTON\SQLPROXYENT')
        AND [RevisionStamp] BETWEEN @Start and @End
  UNION ALL
    SELECT
      [RevisionStamp],
      [TableName],
      [OperatorName],
      [StationName],
      [Actions],
      [Description],
      [ChangedColumns],
      CONVERT(VARCHAR(MAX), [OldData]) AS OldData,
      CONVERT(VARCHAR(MAX), [NewData]) AS NewData,
      [CA4KDB] ='04 - Archive Config'
      FROM [CardAccessarchiveConfigurationUS].[dbo].[DBAudit]
        WHERE [Actions] IN ('U','D','I')
        AND TableName IN ('Reader')
        AND (@DeviceFilter <> 'True' OR [Description] LIKE '%' + @Device + '%')
        --AND OperatorName NOT IN ('cic','admin','BLOOMINGTON\SQLPROXYENT')
        AND [RevisionStamp] BETWEEN @Start and @End
  UNION ALL
    SELECT
      [RevisionStamp],
      [TableName],
      [OperatorName],
      [StationName],
      [Actions],
      [Description],
      [ChangedColumns],
      CONVERT(VARCHAR(MAX), [OldData]) AS OldData,
      CONVERT(VARCHAR(MAX), [NewData]) AS NewData,
      [CA4KDB] ='05 - Archive Events 2'
      FROM [CardAccessarchiveeventsUS_2].[dbo].[DBAudit]
        WHERE [Actions] IN ('U','D','I')
        AND TableName IN ('Reader')
        AND (@DeviceFilter <> 'True' OR [Description] LIKE '%' + @Device + '%')
        --AND OperatorName NOT IN ('cic','admin','BLOOMINGTON\SQLPROXYENT')
        AND [RevisionStamp] BETWEEN @Start and @End
)
SELECT
  CASE
    WHEN [Actions] = 'U' THEN 'Update'
    WHEN [Actions] = 'D' THEN 'Delete'
    WHEN [Actions] = 'I' THEN 'Insert'
    Else [Actions]
  END 'Action',
  [Description],
  [OperatorName],
   -- Original Format Get the Old Data and format it as 00-00-00 for 'Old Inp-Byp-Str'
      --SUBSTRING(OldData, CHARINDEX('Sensor="', OldData) + 8, 2) + '-' + SUBSTRING(OldData, CHARINDEX('Bypass="', OldData) + 8, 2) + '-' + SUBSTRING(OldData, CHARINDEX('Strike="', OldData) + 8, 2) 'Old Inp-Byp-Str',
   -- Get the Old Data and format it as 00-00-00 for 'Old Inp-Byp-Str'
    RIGHT('00' + SUBSTRING(OldData, CHARINDEX('Sensor="', OldData) + 8, CHARINDEX('"', OldData, CHARINDEX('Sensor="', OldData) + 8) - (CHARINDEX('Sensor="', OldData) + 8)), 2) + '-' +
    RIGHT('00' + SUBSTRING(OldData, CHARINDEX('Bypass="', OldData) + 8, CHARINDEX('"', OldData, CHARINDEX('Bypass="', OldData) + 8) - (CHARINDEX('Bypass="', OldData) + 8)), 2) + '-' +
    RIGHT('00' + SUBSTRING(OldData, CHARINDEX('Strike="', OldData) + 8, CHARINDEX('"', OldData, CHARINDEX('Strike="', OldData) + 8) - (CHARINDEX('Strike="', OldData) + 8)), 2) 'Old Inp-Byp-Str',
   -- Original Format Get the New Data and format it as 00-00-00 for 'New Inp-Byp-Str'
      --SUBSTRING(NewData, CHARINDEX('Sensor="', NewData) + 8, 2) + '-' + SUBSTRING(NewData, CHARINDEX('Bypass="', NewData) + 8, 2) + '-' + SUBSTRING(NewData, CHARINDEX('Strike="', NewData) + 8, 2) 'New Inp-Byp-Str',
   -- Get the New Data and format it as 00-00-00 for 'New Inp-Byp-Str'
    RIGHT('00' + SUBSTRING(NewData, CHARINDEX('Sensor="', NewData) + 8, CHARINDEX('"', NewData, CHARINDEX('Sensor="', NewData) + 8) - (CHARINDEX('Sensor="', NewData) + 8)), 2) + '-' +
    RIGHT('00' + SUBSTRING(NewData, CHARINDEX('Bypass="', NewData) + 8, CHARINDEX('"', NewData, CHARINDEX('Bypass="', NewData) + 8) - (CHARINDEX('Bypass="', NewData) + 8)), 2) + '-' +
    RIGHT('00' + SUBSTRING(NewData, CHARINDEX('Strike="', NewData) + 8, CHARINDEX('"', NewData, CHARINDEX('Strike="', NewData) + 8) - (CHARINDEX('Strike="', NewData) + 8)), 2) 'New Inp-Byp-Str',
  [RevisionStamp],
  DATEADD(HH,-5, RevisionStamp) 'EDAte -5',
  --[TableName],
  [ChangedColumns]
  -- [OldData],
  -- [NewData]
FROM CombinedData
  WHERE [OperatorName] = 'LoganElam'
    OR [OperatorName] = 'JBGarcia'
  ORDER BY RevisionStamp DESC;
  
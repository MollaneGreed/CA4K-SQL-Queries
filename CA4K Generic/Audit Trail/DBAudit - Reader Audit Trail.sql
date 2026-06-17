DECLARE @Start DATE = '2026-03-01',
        @Device varchar(10) = '83176';
        
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
      FROM [CardAccessLiveEventsPH].[dbo].[DBAudit]
        WHERE [Actions] IN ('U','D','I')
        AND TableName IN ('Reader')
        AND [Description] LIKE '%' + @Device + '%'
        AND [RevisionStamp] BETWEEN @Start and GETUTCDATE()
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
      FROM [CardAccessLiveConfigurationPH].[dbo].[DBAudit]
        WHERE [Actions] IN ('U','D','I')
        AND TableName IN ('Reader')
        AND [Description] LIKE '%' + @Device + '%'
        AND [RevisionStamp] BETWEEN @Start and GETUTCDATE()
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
      FROM [CardAccessArchiveEventsPH].[dbo].[DBAudit]
        WHERE [Actions] IN ('U','D','I')
        AND TableName IN ('Reader')
        AND [Description] LIKE '%' + @Device + '%'
        AND [RevisionStamp] BETWEEN @Start and GETUTCDATE()
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
      FROM [CardAccessarchiveConfigurationPH].[dbo].[DBAudit]
        WHERE [Actions] IN ('U','D','I')
        AND TableName IN ('Reader')
        AND [Description] LIKE '%' + @Device + '%'
        AND [RevisionStamp] BETWEEN @Start and GETUTCDATE()
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
      FROM [CardAccessarchiveeventsPH_2].[dbo].[DBAudit]
        WHERE [Actions] IN ('U','D','I')
        AND TableName IN ('Reader')
        AND [Description] LIKE '%' + @Device + '%'
        AND [RevisionStamp] BETWEEN @Start and GETUTCDATE()
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
    RIGHT('00' + SUBSTRING(OldData, CHARINDEX('Sensor="', OldData) + 8, CHARINDEX('"', OldData, CHARINDEX('Sensor="', OldData) + 8) - (CHARINDEX('Sensor="', OldData) + 8)), 2) + '-' +
    RIGHT('00' + SUBSTRING(OldData, CHARINDEX('Bypass="', OldData) + 8, CHARINDEX('"', OldData, CHARINDEX('Bypass="', OldData) + 8) - (CHARINDEX('Bypass="', OldData) + 8)), 2) + '-' +
    RIGHT('00' + SUBSTRING(OldData, CHARINDEX('Strike="', OldData) + 8, CHARINDEX('"', OldData, CHARINDEX('Strike="', OldData) + 8) - (CHARINDEX('Strike="', OldData) + 8)), 2) 'Old Inp-Byp-Str',
    RIGHT('00' + SUBSTRING(NewData, CHARINDEX('Sensor="', NewData) + 8, CHARINDEX('"', NewData, CHARINDEX('Sensor="', NewData) + 8) - (CHARINDEX('Sensor="', NewData) + 8)), 2) + '-' +
    RIGHT('00' + SUBSTRING(NewData, CHARINDEX('Bypass="', NewData) + 8, CHARINDEX('"', NewData, CHARINDEX('Bypass="', NewData) + 8) - (CHARINDEX('Bypass="', NewData) + 8)), 2) + '-' +
    RIGHT('00' + SUBSTRING(NewData, CHARINDEX('Strike="', NewData) + 8, CHARINDEX('"', NewData, CHARINDEX('Strike="', NewData) + 8) - (CHARINDEX('Strike="', NewData) + 8)), 2) 'New Inp-Byp-Str',
  [RevisionStamp],
  DATEADD(HH,-5, RevisionStamp) 'EDAte -5',
  [ChangedColumns],
  [CA4KDB]
FROM CombinedData
ORDER BY RevisionStamp DESC;
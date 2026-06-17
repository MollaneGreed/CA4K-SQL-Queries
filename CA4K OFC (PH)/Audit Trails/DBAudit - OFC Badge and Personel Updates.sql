-- Date Filters
  -- Set the target date
    DECLARE 
      @TargetDate DATE = '2025-07-18',
      @DaysBack INT = -14

-- Enable Content Filters
    DECLARE 
      @DescriptionFilter varchar(5) = 'False',
      @OperatorFilter varchar(5) = 'False',
      @TableNameFilter varchar(5) = 'False';

-- Details Filter 
    DECLARE 
      @DescriptionText VARCHAR(100) = '',
      @OperatorName VARCHAR(100) = '';
        
-- Do not change the following variables for Start and End Dates.
    DECLARE 
      @Start DATETIMEOFFSET = CAST(DATEADD(DAY, @DaysBack, @TargetDate) AS DATETIME) AT TIME ZONE 'Singapore Standard Time',
      @End DATETIMEOFFSET = DATEADD(MINUTE, 1439, CAST(@TargetDate AS DATETIME)) AT TIME ZONE 'Singapore Standard Time';

WITH CombinedData AS (
-- Live Config  
  SELECT
    [RevisionStamp],
    [TableName],
    [OperatorName],
    [StationName],
    [Actions],
    [Description],
    [AuditId],
    [ChangedColumns],
    [OldData],
    [NewData]
    FROM [CardAccessliveConfigurationPH].[dbo].[DBAudit]
      WHERE [Actions] IN ('U','D','I')
      AND [RevisionStamp] BETWEEN @Start AND @End
      AND (@DescriptionFilter <> 'True' OR [Description] LIKE '%' + @DescriptionText + '%')
      AND (@OperatorFilter <> 'True' OR [OperatorName] LIKE '%' + @OperatorName + '%')
      AND (@TableNameFilter <> 'True' OR [TableName] != 'UserFields')
-- Archive Events
  UNION ALL
  SELECT
    [RevisionStamp],
    [TableName],
    [OperatorName],
    [StationName],
    [Actions],
    [Description],
    [AuditId],
    [ChangedColumns],
    [OldData],
    [NewData]
  FROM [CardAccessarchiveeventsPH].[dbo].[DBAudit]
    WHERE [Actions] IN ('U','D','I')
    AND [RevisionStamp] BETWEEN @Start AND @End
    AND (@DescriptionFilter <> 'True' OR [Description] LIKE '%' + @DescriptionText + '%')
    AND (@OperatorFilter <> 'True' OR [OperatorName] LIKE '%' + @OperatorName + '%')
      AND (@TableNameFilter <> 'True' OR [TableName] != 'UserFields')
-- Archive Config
  UNION ALL
  SELECT
    [RevisionStamp],
    [TableName],
    [OperatorName],
    [StationName],
    [Actions],
    [Description],
    [AuditId],
    [ChangedColumns],
    [OldData],
    [NewData]
  FROM [CardAccessarchiveConfigurationPH].[dbo].[DBAudit]
    WHERE [Actions] IN ('U','D','I')
    AND [RevisionStamp] BETWEEN @Start AND @End
    AND (@DescriptionFilter <> 'True' OR [Description] LIKE '%' + @DescriptionText + '%')
    AND (@OperatorFilter <> 'True' OR [OperatorName] LIKE '%' + @OperatorName + '%')
    AND (@TableNameFilter <> 'True' OR [TableName] != 'UserFields')
-- Archive Events_2
  UNION ALL
  SELECT
    [RevisionStamp],
    [TableName],
    [OperatorName],
    [StationName],
        [Actions],
    [Description],
    [AuditId],
    [ChangedColumns],
    [OldData],
    [NewData]
  FROM [CardAccessarchiveeventsPH_2].[dbo].[DBAudit]
    WHERE [Actions] IN ('U','D','I')
    AND [RevisionStamp] BETWEEN @Start AND @End
    AND (@DescriptionFilter <> 'True' OR [Description] LIKE '%' + @DescriptionText + '%')
    AND (@OperatorFilter <> 'True' OR [OperatorName] LIKE '%' + @OperatorName + '%')
    AND (@TableNameFilter <> 'True' OR [TableName] != 'UserFields')
)
SELECT
  --cd.[RevisionStamp] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time' AS [CST_Time],
  --cd.[RevisionStamp] AT TIME ZONE 'UTC' AT TIME ZONE 'Singapore Standard Time' AS [Manila_Time],
  DATEADD(HH,-5, cd.[RevisionStamp]) 'CST_Time',
  DATEADD(HH,+8, cd.[RevisionStamp]) 'Manila_Time',
  cd.[TableName],
  cd.[OperatorName],
  CASE
    WHEN r.[RoleName] IS NULL THEN 'Service Account'
    ELSE r.[RoleName]
  END 'Role Name',
  cd.[StationName],
  --cd.[Actions],
  CASE
    WHEN cd.[Actions] = 'U' THEN 'Update'
    WHEN cd.[Actions] = 'D' THEN 'Delete'
    WHEN cd.[Actions] = 'I' THEN 'Insert'
    Else cd.[Actions]
  END 'Action',
  cd.[Description],
  cd.[AuditId],
  cd.[ChangedColumns],
  cd.[OldData],
  cd.[NewData]
FROM CombinedData AS cd
 LEFT JOIN [CardAccessarchiveConfigurationPH].[dbo].[Operators] AS o on cd.[OperatorName] = o.[OperLoginName]
 LEFT JOIN [CardAccessliveConfigurationPH].[dbo].[Roles] as r on o.[RoleID] = r.[RoleID]
  -- WHERE (@DescriptionFilter <> 'True' OR [Description] LIKE '%' + @DescriptionText + '%')
  -- AND [TableName] != 'UserFields'
  -- WHERE [TableName] != 'UserFields'
  -- AND [Actions] = 'U'
 ORDER BY cd.[RevisionStamp] DESC
-- Date Filters
  -- Set the target date
    DECLARE @TargetDate DATE = '2025-07-18';
  -- Set how far back or forward to search. Add or remove the (-) to search forward or backwards from the Target Date.
    DECLARE @DaysBack INT = -14

-- Enable Content Filters
  -- Discription filter True'/'False'
    DECLARE @DescriptionFilter varchar(5) = 'True';
  -- Operator filter True'/'False'
    DECLARE @OperatorFilter varchar(5) = 'False';
  -- Filter out UserField changes 'True'/'False'
    DECLARE @TableNameFilter varchar(5) = 'True';

-- Filter Details
  -- Set Description Filter
    DECLARE @Description VARCHAR(100) = '9000047';
  -- Set Operator Filter
    DECLARE @Operator VARCHAR(100) = 'AndieButac';
        
-- Do not change the following variables for Start and End Dates.
  -- Start at 00:00:00 on the target day minus days back, in Singapore time
    DECLARE @Start DATETIMEOFFSET = 
        CAST(DATEADD(DAY, @DaysBack, @TargetDate) AS DATETIME) 
        AT TIME ZONE 'Singapore Standard Time';
  -- End at 23:59:00 on the same day, using MINUTES for clarity
    DECLARE @End DATETIMEOFFSET = 
        DATEADD(MINUTE, 1439, CAST(@TargetDate AS DATETIME)) 
        AT TIME ZONE 'Singapore Standard Time';

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
      AND (@DescriptionFilter <> 'True' OR [Description] LIKE '%' + @Description + '%')
      AND (@OperatorFilter <> 'True' OR [OperatorName] LIKE '%' + @Operator + '%')
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
    AND (@DescriptionFilter <> 'True' OR [Description] LIKE '%' + @Description + '%')
    AND (@OperatorFilter <> 'True' OR [OperatorName] LIKE '%' + @Operator + '%')
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
    AND (@DescriptionFilter <> 'True' OR [Description] LIKE '%' + @Description + '%')
    AND (@OperatorFilter <> 'True' OR [OperatorName] LIKE '%' + @Operator + '%')
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
    AND (@DescriptionFilter <> 'True' OR [Description] LIKE '%' + @Description + '%')
    AND (@OperatorFilter <> 'True' OR [OperatorName] LIKE '%' + @Operator + '%')
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
  -- WHERE (@DescriptionFilter <> 'True' OR [Description] LIKE '%' + @Description + '%')
  -- AND [TableName] != 'UserFields'
  -- WHERE [TableName] != 'UserFields'
  -- AND [Actions] = 'U'
 ORDER BY cd.[RevisionStamp] DESC
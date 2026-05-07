
-- Run on SQL server

-- Set the start date
DECLARE @StartDate DATE = '2025-07-11',
        @DaysBack INT = 20,
        @SearchFilter varchar(10) = 'true',
        @Search VARCHAR(100) = 'AG-CAPHI-WPE';


-- Do not change the following values
DECLARE @Start DATETIMEOFFSET = CAST(@StartDate AS DATETIME) AT TIME ZONE 'Singapore Standard Time';
DECLARE @End DATETIMEOFFSET = DATEADD(SECOND, 86399, DATEADD(DAY, @DaysBack, @Start));

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
      AND (@SearchFilter <> 'True' OR [Description] LIKE '%' + @Search + '%')
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
        AND (@SearchFilter <> 'True' OR [Description] LIKE '%' + @Search + '%')
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
        AND (@SearchFilter <> 'True' OR [Description] LIKE '%' + @Search + '%')
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
        AND (@SearchFilter <> 'True' OR [Description] LIKE '%' + @Search + '%')
)
SELECT
  --cd.[RevisionStamp] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time' AS [CST_Time],
  DATEADD(HH,-5, cd.[RevisionStamp]) 'CST_Time',
  DATEADD(HH,+8, cd.[RevisionStamp]) 'Manila_Time',
  --cd.[RevisionStamp] AT TIME ZONE 'UTC' AT TIME ZONE 'Singapore Standard Time' AS [Manila_Time],
  cd.[TableName],
  cd.[OperatorName],
  -- Display 'Service Account if Role is Empty
    CASE
      WHEN r.[RoleName] IS NULL THEN 'Service Account'
      ELSE r.[RoleName]
    END 'Role Name',
  cd.[StationName],
  --cd.[Actions],
  -- Display Actions as Words
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
  WHERE (@SearchFilter <> 'True' OR [Description] LIKE '%' + @Search + '%')
  AND [TableName] != 'UserFields'
  --WHERE [TableName] != 'UserFields'
  --AND [Actions] = 'U'
 ORDER BY cd.[RevisionStamp] DESC
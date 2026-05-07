-- Run on SQL server
---- Live Events contains no information

-- Set the variable
DECLARE @LastName NVARCHAR(100) = '9050677';

-- Live Config
-- Add/Remove the -- below to comment out the whole section.
--/*
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT
      db.[TableName]
      ,db.[OperatorName]
    ,CASE
        WHEN r.[RoleName] IS NULL THEN 'Service Account'
        ELSE r.[RoleName]
    END 'Role Name'
	  ,CASE
        WHEN db.[Actions] = 'U' THEN 'Update'
        WHEN db.[Actions] = 'D' THEN 'Delete'
        WHEN db.[Actions] = 'I' THEN 'Insert'
        Else db.[Actions]
      END 'Action'	  
      ,db.[Description]
      ,[RevisionStamp] 'UTC'
      ,db.[RevisionStamp] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time' AS [CST_Time]
      ,db.[RevisionStamp] AT TIME ZONE 'UTC' AT TIME ZONE 'Singapore Standard Time' AS [Manila_Time]
      ,db.[ChangedColumns]
      ,db.[OldData]
      ,db.[NewData]
    FROM [CardAccessliveConfigurationPH].[dbo].[DBAudit] AS db
    LEFT JOIN [CardAccessarchiveConfigurationPH].[dbo].[Operators] AS o on o.[OperLoginName] = db.[OperatorName]
    LEFT JOIN [CardAccessliveConfigurationPH].[dbo].[Roles] as r on o.[RoleID] = r.[RoleID]
    WHERE [RevisionStamp] BETWEEN DATEADD(DAY, -1, CAST(GETDATE() AS DATE)) AND DATEADD(DAY, 1, CAST(GETDATE() AS DATE))
	    AND [Actions] IN ('U','D','I')
      AND [OperatorName] NOT IN ('cic','Admin','BLOOMINGTON\SQLPROXYENT')
      AND [TableName] != 'UserFields'
      AND [Description] LIKE '%' + @LastName + '%'
      ORDER BY CST_Time Desc;
--*/

-- Archive Events
-- Remove the -- below to comment out the whole section.
--/*
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT
      db.[TableName]
      ,db.[OperatorName]
    ,CASE
        WHEN r.[RoleName] IS NULL THEN 'Service Account'
        ELSE r.[RoleName]
    END 'Role Name'
      ,db.[StationName]
	  ,CASE
        WHEN db.[Actions] = 'U' THEN 'Update'
        WHEN db.[Actions] = 'D' THEN 'Delete'
        WHEN db.[Actions] = 'I' THEN 'Insert'
        Else db.[Actions]
      END 'Action'	  
      ,db.[Description]
      ,[RevisionStamp] 'UTC'
      ,db.[RevisionStamp] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time' AS [CST_Time]
      ,db.[RevisionStamp] AT TIME ZONE 'UTC' AT TIME ZONE 'Singapore Standard Time' AS [Manila_Time]
      ,db.[ChangedColumns]
      ,db.[OldData]
      ,db.[NewData]
    FROM [CardAccessarchiveeventsPH].[dbo].[DBAudit] AS db
    LEFT JOIN [CardAccessarchiveConfigurationPH].[dbo].[Operators] AS o on o.[OperLoginName] = db.[OperatorName]
    LEFT JOIN [CardAccessliveConfigurationPH].[dbo].[Roles] as r on o.[RoleID] = r.[RoleID]
    WHERE [RevisionStamp] BETWEEN DATEADD(DAY, -1, CAST(GETDATE() AS DATE)) AND DATEADD(DAY, 1, CAST(GETDATE() AS DATE))
	    AND [Actions] IN ('U','D','I')
      AND [OperatorName] NOT IN ('cic','Admin','BLOOMINGTON\SQLPROXYENT')
      AND [TableName] != 'UserFields'
      AND [Description] LIKE '%' + @LastName + '%'
      ORDER BY CST_Time Desc;
--*/


-- Archive Events 2
-- Remove the -- below to comment out the whole section.
--/*
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT Top (30)
      db.[TableName]
      ,db.[OperatorName]
    ,CASE
        WHEN r.[RoleName] IS NULL THEN 'Service Account'
        ELSE r.[RoleName]
    END 'Role Name'
      ,db.[StationName]
	  ,CASE
        WHEN db.[Actions] = 'U' THEN 'Update'
        WHEN db.[Actions] = 'D' THEN 'Delete'
        WHEN db.[Actions] = 'I' THEN 'Insert'
        Else db.[Actions]
      END 'Action'	  
      ,db.[Description]
      ,[RevisionStamp] 'UTC'
      ,db.[RevisionStamp] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time' AS [CST_Time]
      ,db.[RevisionStamp] AT TIME ZONE 'UTC' AT TIME ZONE 'Singapore Standard Time' AS [Manila_Time]
      ,db.[ChangedColumns]
      ,db.[OldData]
      ,db.[NewData]
    FROM [CardAccessarchiveeventsPH_2].[dbo].[DBAudit] AS db
    LEFT JOIN [CardAccessarchiveConfigurationPH].[dbo].[Operators] AS o on o.[OperLoginName] = db.[OperatorName]
    LEFT JOIN [CardAccessliveConfigurationPH].[dbo].[Roles] as r on o.[RoleID] = r.[RoleID]
    WHERE [RevisionStamp] BETWEEN DATEADD(DAY, -1, CAST(GETDATE() AS DATE)) AND DATEADD(DAY, 1, CAST(GETDATE() AS DATE))
	    AND [Actions] IN ('U','D','I')
      AND [OperatorName] NOT IN ('cic','Admin','BLOOMINGTON\SQLPROXYENT')
      AND [TableName] != 'UserFields'
      AND [Description] LIKE '%' + @LastName + '%'
      ORDER BY CST_Time Desc;
--*/

-- Archive Config (Empty) 
-- Remove the -- below to comment out the whole section.
--/*
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT
      db.[TableName]
      ,db.[OperatorName]
    ,CASE
        WHEN r.[RoleName] IS NULL THEN 'Service Account'
        ELSE r.[RoleName]
    END 'Role Name'
      ,db.[StationName]
	  ,CASE
        WHEN db.[Actions] = 'U' THEN 'Update'
        WHEN db.[Actions] = 'D' THEN 'Delete'
        WHEN db.[Actions] = 'I' THEN 'Insert'
        Else db.[Actions]
      END 'Action'	  
      ,db.[Description]
      ,[RevisionStamp] 'UTC'
      ,db.[RevisionStamp] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time' AS [CST_Time]
      ,db.[RevisionStamp] AT TIME ZONE 'UTC' AT TIME ZONE 'Singapore Standard Time' AS [Manila_Time]
      ,db.[ChangedColumns]
      ,db.[OldData]
      ,db.[NewData]
    FROM [CardAccessarchiveConfigurationPH].[dbo].[DBAudit] AS db
    LEFT JOIN [CardAccessarchiveConfigurationPH].[dbo].[Operators] AS o on o.[OperLoginName] = db.[OperatorName]
    LEFT JOIN [CardAccessliveConfigurationPH].[dbo].[Roles] as r on o.[RoleID] = r.[RoleID]
    WHERE [RevisionStamp] BETWEEN DATEADD(DAY, -1, CAST(GETDATE() AS DATE)) AND DATEADD(DAY, 1, CAST(GETDATE() AS DATE))
	    AND [Actions] IN ('U','D','I')
      AND [OperatorName] NOT IN ('cic','Admin','BLOOMINGTON\SQLPROXYENT')
      AND db.[TableName] != 'UserFields'
        AND db.[Description] LIKE '%' + @LastName + '%'
        ORDER BY CST_Time Desc;
--*/
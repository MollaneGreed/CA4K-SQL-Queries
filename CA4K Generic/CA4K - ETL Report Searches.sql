-- Searches are designed to be run on the CardAccessCustom database
--multiple ssn
SELECT 
	1,
	[bdg].[Badge] AS 'Badge',
	[bdg].[Facility],
	TRY_CONVERT(INT, [per].[SSN]),
	[per].[FrstName],
	[per].[LastName],
	[bdg].[LastUpdated] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time' AS [Last Updated CST],
	--'',
	--'',
	'Duplicate Personnel on SSN. Badges have been disabled.' AS [Reason],
	'Not allow. Delete the incorrect personnel and badge record, ensure UMS employeeID is correct and re-enable badge.' AS [Action],
	-- logic to check who the last non-admin was to update the account or return last operator if or NULL
	COALESCE(
		(
			SELECT TOP 1 
				[dbaopr].[OperLoginName]
			FROM [CardAccessArchiveEventsPH].dbo.[DBAudit] [dba]
			LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Operators] [dbaopr] ON [dbaopr].[OperatorID] = [dba].[LastOperator]
			CROSS APPLY
				(SELECT 
					TRY_CAST(
						SUBSTRING([dba].[Description], 1, 
							CASE 
								WHEN CHARINDEX(' ', [dba].[Description]) > 0 
								THEN CHARINDEX(' ', [dba].[Description]) - 1 
								ELSE 0 
							END
						) AS INT
					) AS FirstNumber
				) AS Extracted
			WHERE Extracted.FirstNumber = [bdg].[Badge]
				AND [dbaopr].[OperLoginName] != 'admin'
			ORDER BY [dba].[RevisionStamp] DESC
		),
		(
			SELECT TOP 1 
				[dbaopr].[OperLoginName]
			FROM [CardAccessArchiveEventsPH].dbo.[DBAudit] [dba]
			LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Operators] [dbaopr] ON [dbaopr].[OperatorID] = [dba].[LastOperator]
			CROSS APPLY
				(SELECT 
					TRY_CAST(
						SUBSTRING([dba].[Description], 1, 
							CASE 
								WHEN CHARINDEX(' ', [dba].[Description]) > 0 
								THEN CHARINDEX(' ', [dba].[Description]) - 1 
								ELSE 0 
							END
						) AS INT
					) AS FirstNumber
				) AS Extracted
			WHERE Extracted.FirstNumber = [bdg].[Badge]
			ORDER BY [dba].[RevisionStamp] DESC
		)
	) AS 'Last Updated By'
FROM 
	[stg].[caPerson] [per]
	INNER JOIN 
		[stg].[caBadge] [bdg] ON [bdg].[PersonID] = [per].[PersonID]
	INNER JOIN 
		[CardAccessLiveConfigurationPH].[dbo].[Operators] [opr] ON [opr].[OperatorID] = [bdg].[LastOperator]
	WHERE[per].[SSN] IN 
		(
		SELECT
			[per].[SSN]
			FROM [stg].[caPerson] [per]
				INNER JOIN [stg].[caBadge] [bdg] ON [bdg].[PersonID] = [per].[PersonID]
			WHERE [per].[SSN] IS NOT NULL
			GROUP BY [per].[SSN]
			HAVING COUNT(*) > 1
		)
	ORDER BY [per].[SSN], [bdg].[LastUpdated] Desc ;

--Multiple employeeid
SELECT 
	2,
	[bdg].[Badge],
	TRY_CONVERT(INT, [udf].[UserFieldValue]),
	[per].[FrstName],
	[per].[LastName],
	[per].[LastUpdated] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time' AS [Last Updated CST],
	'',
	'',
	'Duplicate personnel on EmployeeID.' AS [Reason],
	'Delete the incorrect personnel and badge record' AS [Action],
	COALESCE(
		(
			SELECT TOP 1 
				[dbaopr].[OperLoginName]
			FROM [CardAccessArchiveEventsPH].dbo.[DBAudit] [dba]
			LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Operators] [dbaopr] ON [dbaopr].[OperatorID] = [dba].[LastOperator]
			CROSS APPLY
				(SELECT 
					TRY_CAST(
						SUBSTRING([dba].[Description], 1, 
							CASE 
								WHEN CHARINDEX(' ', [dba].[Description]) > 0 
								THEN CHARINDEX(' ', [dba].[Description]) - 1 
								ELSE 0 
							END
						) AS INT
					) AS FirstNumber
				) AS Extracted
			WHERE Extracted.FirstNumber = [bdg].[Badge]
				AND [dbaopr].[OperLoginName] != 'admin'
			ORDER BY [dba].[RevisionStamp] DESC
		),
		(
			SELECT TOP 1 
				[dbaopr].[OperLoginName]
			FROM [CardAccessArchiveEventsPH].dbo.[DBAudit] [dba]
			LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Operators] [dbaopr] ON [dbaopr].[OperatorID] = [dba].[LastOperator]
			CROSS APPLY
				(SELECT 
					TRY_CAST(
						SUBSTRING([dba].[Description], 1, 
							CASE 
								WHEN CHARINDEX(' ', [dba].[Description]) > 0 
								THEN CHARINDEX(' ', [dba].[Description]) - 1 
								ELSE 0 
							END
						) AS INT
					) AS FirstNumber
				) AS Extracted
			WHERE Extracted.FirstNumber = [bdg].[Badge]
			ORDER BY [dba].[RevisionStamp] DESC
		)
	) AS 'Last Updated By'
	FROM [stg].[caPerson] [per]
		INNER JOIN [stg].[caBadge] [bdg] ON [bdg].[PersonID] = [per].[PersonID]
		INNER JOIN [stg].[caUserFields] [udf] ON [udf].[Badge] = [bdg].[Badge]
		INNER JOIN [CardAccessLiveConfigurationPH].[dbo].[Operators] [opr] ON [opr].[OperatorID] = [per].[LastOperator]
	AND [udf].[Facility] = [bdg].[Facility]
	AND [udf].[PersonID] = [bdg].[PersonID]
	AND [udf].[UserFieldID] = 
		(
		SELECT [UserFieldID]
		FROM [stg].[caUserFieldDef]
		WHERE [UserFieldName] = 'EmployeeID:'
		)
	WHERE [udf].[UserFieldValue] IN 
	(	
	SELECT [udf].[UserFieldValue]
		FROM [stg].[caBadge] [bdg]
			INNER JOIN [stg].[caUserFields] [udf] ON [udf].[Badge] = [bdg].[Badge]
				AND [udf].[Facility] = [bdg].[Facility]
				AND [udf].[PersonID] = [bdg].[PersonID]
				AND [udf].[UserFieldID] = 
					(
					SELECT [UserFieldID]
					FROM [stg].[caUserFieldDef]
					WHERE [UserFieldName] = 'EmployeeID:'
					)
		WHERE [udf].[UserFieldValue] <> 'N/A'
		GROUP BY [udf].[UserFieldValue]
		HAVING COUNT(*) > 1
	) ORDER BY [per].[LastUpdated] desc;

--Invalid Account
SELECT 
	3,
	[bdg].[Badge],
	[bdg].[Facility],
	0,
	[per].[FrstName],
	[per].[LastName],
	COALESCE([emp].[HRSiteCode], ''),
	COALESCE([emp].[HRSiteName], ''),
	'Invalid Account.' [Reason],
	'Delete the badge records or ensure correct setup if non-employee.' [Action],
	COALESCE(
		(
			SELECT TOP 1 
				[dbaopr].[OperLoginName]
			FROM [CardAccessArchiveEventsPH].dbo.[DBAudit] [dba]
			LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Operators] [dbaopr] ON [dbaopr].[OperatorID] = [dba].[LastOperator]
			CROSS APPLY
				(SELECT 
					TRY_CAST(
						SUBSTRING([dba].[Description], 1, 
							CASE 
								WHEN CHARINDEX(' ', [dba].[Description]) > 0 
								THEN CHARINDEX(' ', [dba].[Description]) - 1 
								ELSE 0 
							END
						) AS INT
					) AS FirstNumber
				) AS Extracted
			WHERE Extracted.FirstNumber = [bdg].[Badge]
				AND [dbaopr].[OperLoginName] != 'admin'
			ORDER BY [dba].[RevisionStamp] DESC
		),
		(
			SELECT TOP 1 
				[dbaopr].[OperLoginName]
			FROM [CardAccessArchiveEventsPH].dbo.[DBAudit] [dba]
			LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Operators] [dbaopr] ON [dbaopr].[OperatorID] = [dba].[LastOperator]
			CROSS APPLY
				(SELECT 
					TRY_CAST(
						SUBSTRING([dba].[Description], 1, 
							CASE 
								WHEN CHARINDEX(' ', [dba].[Description]) > 0 
								THEN CHARINDEX(' ', [dba].[Description]) - 1 
								ELSE 0 
							END
						) AS INT
					) AS FirstNumber
				) AS Extracted
			WHERE Extracted.FirstNumber = [bdg].[Badge]
			ORDER BY [dba].[RevisionStamp] DESC
		)
	) AS 'Last Updated By'
	FROM [stg].[caPerson] [per]
		INNER JOIN [stg].[caBadge] [bdg] ON [bdg].[PersonID] = [per].[PersonID]
	LEFT OUTER JOIN [dbo].[dimEmployeeAllFutureHireTermV2] [emp] ON [emp].[EmployeeID] = TRY_CONVERT(INT, [per].[SSN])
	WHERE [per].[LastName] LIKE '%invalid%' 
		AND COALESCE([per].[CompanyID], 0) = 0;

--Invalid Temp/Exec Badge
SELECT 
	4,
	[bdg].[Badge],
	[bdg].[Facility],
	0,
	[per].[FrstName],
	[per].[LastName],
	[emp].[HRSiteCode],
	[emp].[HRSiteName],
	'Invalid Temp/Exec Badge.' [Reason],
	'Update Last Name to be employee id followed by a comma, Example: "0000000, Name"' [Action],
	COALESCE(
		(
			SELECT TOP 1 
				[dbaopr].[OperLoginName]
			FROM [CardAccessArchiveEventsPH].dbo.[DBAudit] [dba]
			LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Operators] [dbaopr] ON [dbaopr].[OperatorID] = [dba].[LastOperator]
			CROSS APPLY
				(SELECT 
					TRY_CAST(
						SUBSTRING([dba].[Description], 1, 
							CASE 
								WHEN CHARINDEX(' ', [dba].[Description]) > 0 
								THEN CHARINDEX(' ', [dba].[Description]) - 1 
								ELSE 0 
							END
						) AS INT
					) AS FirstNumber
				) AS Extracted
			WHERE Extracted.FirstNumber = [bdg].[Badge]
				AND [dbaopr].[OperLoginName] != 'admin'
			ORDER BY [dba].[RevisionStamp] DESC
		),
		(
			SELECT TOP 1 
				[dbaopr].[OperLoginName]
			FROM [CardAccessArchiveEventsPH].dbo.[DBAudit] [dba]
			LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Operators] [dbaopr] ON [dbaopr].[OperatorID] = [dba].[LastOperator]
			CROSS APPLY
				(SELECT 
					TRY_CAST(
						SUBSTRING([dba].[Description], 1, 
							CASE 
								WHEN CHARINDEX(' ', [dba].[Description]) > 0 
								THEN CHARINDEX(' ', [dba].[Description]) - 1 
								ELSE 0 
							END
						) AS INT
					) AS FirstNumber
				) AS Extracted
			WHERE Extracted.FirstNumber = [bdg].[Badge]
			ORDER BY [dba].[RevisionStamp] DESC
		)
	) AS 'Last Updated By'
	FROM [stg].[caPerson] [per]
		INNER JOIN [stg].[caBadge] [bdg] ON [bdg].[PersonID] = [per].[PersonID]
		INNER JOIN [map].[AutomationExternalExclusion] [ext] ON [ext].[ID] = [per].[CompanyID]
			AND [ext].[IsEmployee] = 1
		LEFT OUTER JOIN [dbo].[dimEmployeeAllFutureHireTermV2] [emp] ON [emp].[EmployeeID] = TRY_CONVERT(INT, REPLACE(SUBSTRING([per].[LastName], 1, CHARINDEX(',', [per].[LastName])), ',', ''))
	WHERE [emp].[EmployeeID] IS NULL
		AND [bdg].[Enabled] <> 0;

--Terminated Employee
SELECT 
	5,
	[bdg].[Badge],
	[bdg].[Facility],
	TRY_CONVERT(INT, REPLACE(SUBSTRING([per].[LastName], 1, CHARINDEX(',', [per].[LastName])), ',', '')),
	[per].[FrstName],
	[per].[LastName],
	[emp].[HRSiteCode],
	[emp].[HRSiteName],
	'Terminated employee. Access removed and badge disabled' [Reason],
	'Remove employee Id from last name on personnel record or delete from the system' [Action],
	COALESCE(
		(
			SELECT TOP 1 
				[dbaopr].[OperLoginName]
			FROM [CardAccessArchiveEventsPH].dbo.[DBAudit] [dba]
			LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Operators] [dbaopr] ON [dbaopr].[OperatorID] = [dba].[LastOperator]
			CROSS APPLY
				(SELECT 
					TRY_CAST(
						SUBSTRING([dba].[Description], 1, 
							CASE 
								WHEN CHARINDEX(' ', [dba].[Description]) > 0 
								THEN CHARINDEX(' ', [dba].[Description]) - 1 
								ELSE 0 
							END
						) AS INT
					) AS FirstNumber
				) AS Extracted
			WHERE Extracted.FirstNumber = [bdg].[Badge]
				AND [dbaopr].[OperLoginName] != 'admin'
			ORDER BY [dba].[RevisionStamp] DESC
		),
		(
			SELECT TOP 1 
				[dbaopr].[OperLoginName]
			FROM [CardAccessArchiveEventsPH].dbo.[DBAudit] [dba]
			LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Operators] [dbaopr] ON [dbaopr].[OperatorID] = [dba].[LastOperator]
			CROSS APPLY
				(SELECT 
					TRY_CAST(
						SUBSTRING([dba].[Description], 1, 
							CASE 
								WHEN CHARINDEX(' ', [dba].[Description]) > 0 
								THEN CHARINDEX(' ', [dba].[Description]) - 1 
								ELSE 0 
							END
						) AS INT
					) AS FirstNumber
				) AS Extracted
			WHERE Extracted.FirstNumber = [bdg].[Badge]
			ORDER BY [dba].[RevisionStamp] DESC
		)
	) AS 'Last Updated By'
	FROM [stg].[caPerson] [per]
		INNER JOIN [stg].[caBadge] [bdg] ON [bdg].[PersonID] = [per].[PersonID]
		INNER JOIN [map].[AutomationExternalExclusion] [ext] ON [ext].[ID] = [per].[CompanyID] 
			AND [ext].[IsEmployee] = 1
		INNER JOIN [dbo].[dimEmployeeAllFutureHireTermV2] [emp] ON [emp].[EmployeeID] = TRY_CONVERT(INT, REPLACE(SUBSTRING([per].[LastName], 1, CHARINDEX(',', [per].[LastName])), ',', '')) AND [emp].[TerminationDate] IS NOT NULL;

--Active no access groups
SELECT 
	6,
	[bdg].[Badge],
	[bdg].[Facility],
	[emp].[EmployeeID],
	[per].[FrstName],
	[per].[LastName],
	[emp].[HRSiteCode],
	[emp].[HRSiteName],
	'Active Employee and badge has no access groups.' [Reason],
	'Check with ID Team and IMAC role and ensure correctly setup. Role: ' + [emprl].[RoleName] AS [Action],
	COALESCE(
		(
			SELECT TOP 1 
				[dbaopr].[OperLoginName]
			FROM [CardAccessArchiveEventsPH].dbo.[DBAudit] [dba]
			LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Operators] [dbaopr] ON [dbaopr].[OperatorID] = [dba].[LastOperator]
			CROSS APPLY
				(SELECT 
					TRY_CAST(
						SUBSTRING([dba].[Description], 1, 
							CASE 
								WHEN CHARINDEX(' ', [dba].[Description]) > 0 
								THEN CHARINDEX(' ', [dba].[Description]) - 1 
								ELSE 0 
							END
						) AS INT
					) AS FirstNumber
				) AS Extracted
			WHERE Extracted.FirstNumber = [bdg].[Badge]
				AND [dbaopr].[OperLoginName] != 'admin'
			ORDER BY [dba].[RevisionStamp] DESC
		),
		(
			SELECT TOP 1 
				[dbaopr].[OperLoginName]
			FROM [CardAccessArchiveEventsPH].dbo.[DBAudit] [dba]
			LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Operators] [dbaopr] ON [dbaopr].[OperatorID] = [dba].[LastOperator]
			CROSS APPLY
				(SELECT 
					TRY_CAST(
						SUBSTRING([dba].[Description], 1, 
							CASE 
								WHEN CHARINDEX(' ', [dba].[Description]) > 0 
								THEN CHARINDEX(' ', [dba].[Description]) - 1 
								ELSE 0 
							END
						) AS INT
					) AS FirstNumber
				) AS Extracted
			WHERE Extracted.FirstNumber = [bdg].[Badge]
			ORDER BY [dba].[RevisionStamp] DESC
		)
	) AS 'Last Updated By'
	FROM [stg].[caPerson] [per]
		INNER JOIN [stg].[ValidEmployee] [ve]
		INNER JOIN [stg].[rbacEmployeeRole] [emprl] ON [emprl].[EmployeeID] = [ve].[EmployeeID]
		INNER JOIN [dbo].[dimEmployeeAllFutureHireTermV2] [emp] ON [emp].[EmployeeID] = [ve].[EmployeeID] ON [emp].[EmployeeID] = TRY_CONVERT(INT, [per].[SSN]) 
			AND [emp].[TerminationDate] IS NULL
		INNER JOIN [stg].[caBadge] [bdg] ON [bdg].[PersonID] = [per].[PersonID]
		LEFT OUTER JOIN [CardAccessLiveConfigurationPH].[dbo].[BadgeAccess] [bdgacc] ON [bdgacc].[Badge] = [bdg].[Badge]
			AND [bdgacc].[Facility] = [bdg].[Facility]
	WHERE [bdgacc].[Badge] IS NULL
		AND [bdg].[Badge] < 1000000000
		AND emp.EmployeeStatusCode <> 'L';

--Too many Access Groups				
SELECT 
	7,
	[bdg].[Badge],
	[bdg].[Facility],
	TRY_CONVERT(INT, [per].[SSN]),
	[per].[FrstName],
	[per].[LastName],
	[emp].[HRSiteCode],
	[emp].[HRSiteName],
	'Employee is part of more that 16 access groups. System Limit, only first 16 applied' [Reason],
	'Check with ID team and role setup in IMAC as employees can not be part of more than 16 continental access groups' [Action],
	COALESCE(
		(
			SELECT TOP 1 
				[dbaopr].[OperLoginName]
			FROM [CardAccessArchiveEventsPH].dbo.[DBAudit] [dba]
			LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Operators] [dbaopr] ON [dbaopr].[OperatorID] = [dba].[LastOperator]
			CROSS APPLY
				(SELECT 
					TRY_CAST(
						SUBSTRING([dba].[Description], 1, 
							CASE 
								WHEN CHARINDEX(' ', [dba].[Description]) > 0 
								THEN CHARINDEX(' ', [dba].[Description]) - 1 
								ELSE 0 
							END
						) AS INT
					) AS FirstNumber
				) AS Extracted
			WHERE Extracted.FirstNumber = [bdg].[Badge]
				AND [dbaopr].[OperLoginName] != 'admin'
			ORDER BY [dba].[RevisionStamp] DESC
		),
		(
			SELECT TOP 1 
				[dbaopr].[OperLoginName]
			FROM [CardAccessArchiveEventsPH].dbo.[DBAudit] [dba]
			LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Operators] [dbaopr] ON [dbaopr].[OperatorID] = [dba].[LastOperator]
			CROSS APPLY
				(SELECT 
					TRY_CAST(
						SUBSTRING([dba].[Description], 1, 
							CASE 
								WHEN CHARINDEX(' ', [dba].[Description]) > 0 
								THEN CHARINDEX(' ', [dba].[Description]) - 1 
								ELSE 0 
							END
						) AS INT
					) AS FirstNumber
				) AS Extracted
			WHERE Extracted.FirstNumber = [bdg].[Badge]
			ORDER BY [dba].[RevisionStamp] DESC
		)
	) AS 'Last Updated By'
	FROM [stg].[caPerson] [per]
		INNER JOIN [stg].[caBadge] [bdg] ON [bdg].[PersonID] = [per].[PersonID]
		INNER JOIN [dbo].[dimEmployeeAllFutureHireTermV2] [emp] ON [emp].[EmployeeID] = TRY_CONVERT(INT, [per].[SSN])
	WHERE TRY_CONVERT(INT, [per].[SSN])
		IN ( 
			SELECT [grp].[employeeid]
			FROM [stg].[ADUserGroup] [grp]
			WHERE [grp].[name] LIKE 'AG-CAPHI-%'
			GROUP BY [grp].[employeeid]
			HAVING COUNT(*) > 16
			);

--Empty Access Groups
SELECT 
	8,
	[bdg].[Badge],
	[bdg].[Facility],
	[emp].[EmployeeID],
	[per].[FrstName],
	[per].[LastName],
	[emp].[HRSiteCode],
	[emp].[HRSiteName],
	'Active employee badge assigned access group(s) that have no access defined.' [Reason],
	'Setup the access group(s) in Continental. Groups: ' + STRING_AGG([magrp].[Description], ', ') AS [Action],
	COALESCE(
		(
			SELECT TOP 1 
				[dbaopr].[OperLoginName]
			FROM [CardAccessArchiveEventsPH].dbo.[DBAudit] [dba]
			LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Operators] [dbaopr] ON [dbaopr].[OperatorID] = [dba].[LastOperator]
			CROSS APPLY
				(SELECT 
					TRY_CAST(
						SUBSTRING([dba].[Description], 1, 
							CASE 
								WHEN CHARINDEX(' ', [dba].[Description]) > 0 
								THEN CHARINDEX(' ', [dba].[Description]) - 1 
								ELSE 0 
							END
						) AS INT
					) AS FirstNumber
				) AS Extracted
			WHERE Extracted.FirstNumber = [bdg].[Badge]
				AND [dbaopr].[OperLoginName] != 'admin'
			ORDER BY [dba].[RevisionStamp] DESC
		),
		(
			SELECT TOP 1 
				[dbaopr].[OperLoginName]
			FROM [CardAccessArchiveEventsPH].dbo.[DBAudit] [dba]
			LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Operators] [dbaopr] ON [dbaopr].[OperatorID] = [dba].[LastOperator]
			CROSS APPLY
				(SELECT 
					TRY_CAST(
						SUBSTRING([dba].[Description], 1, 
							CASE 
								WHEN CHARINDEX(' ', [dba].[Description]) > 0 
								THEN CHARINDEX(' ', [dba].[Description]) - 1 
								ELSE 0 
							END
						) AS INT
					) AS FirstNumber
				) AS Extracted
			WHERE Extracted.FirstNumber = [bdg].[Badge]
			ORDER BY [dba].[RevisionStamp] DESC
		)
	) AS 'Last Updated By'
	FROM [stg].[caPerson] [per]
		INNER JOIN [dbo].[dimEmployeeAllFutureHireTermV2] [emp] ON [emp].[EmployeeID] = TRY_CONVERT(INT, [per].[SSN])
			AND [emp].[TerminationDate] IS NULL
		INNER JOIN [stg].[caBadge] [bdg] ON [bdg].[PersonID] = [per].[PersonID]
		INNER JOIN [CardAccessLiveConfigurationPH].[dbo].[BadgeAccess] [bdgacc] ON [bdgacc].[Badge] = [bdg].[Badge]
			AND [bdgacc].[Facility] = [bdg].[Facility]
		INNER JOIN [CardAccessLiveConfigurationPH].[dbo].[MAccGrp] [magrp] ON [magrp].[AgrpNo] = [bdgacc].[AGroupNo]
			AND [magrp].[Description] NOT LIKE 'AG-CA%-NoAccess'
		LEFT OUTER JOIN [CardAccessLiveConfigurationPH].[dbo].[AccGrp] [agrp] ON [agrp].[Agno] = [magrp].[AgrpNo]
		WHERE [bdg].[Badge] < 1000000000
			AND [agrp].[Agno] IS NULL
		GROUP BY 
		[bdg].[Badge],
		[bdg].[Facility],
		[emp].[EmployeeID],
		[per].[FrstName],
		[per].[LastName],
		[emp].[HRSiteCode],
		[emp].[HRSiteName];
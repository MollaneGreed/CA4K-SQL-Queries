-- Searches are designed to be run on the CardAccessCustom database
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
Use [CardAccessCustomPH]
Go
--multiple ssn
SELECT 
	'1' AS 'Run Order',
	[bdg].[Badge] AS 'Badge',
	[bdg].[Facility]  AS 'Facility Number',
	--TRY_CONVERT(INT, [per].[SSN]) AS 'SSN',
    TRY_CONVERT(VARCHAR(10), REPLACE(SUBSTRING([per].[LastName], 1, CHARINDEX(',', [per].[LastName])), ',', '')) AS 'Employee ID',
	[per].[FrstName] AS 'First Name',
	[per].[LastName] AS 'Last Name',
	'N/A' AS 'HR Site Code',
	'N/A' AS 'HR Site Name',
	'Duplicate Personnel on SSN. Badges have been disabled.' AS 'Reason',
	'Not allow. Delete the incorrect personnel and badge record, ensure UMS employeeID is correct and re-enable badge.' AS 'Action',
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
	) AS 'Last Updated By',
	[bdg].[LastUpdated] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time' AS 'Last Updated CST'
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

--Multiple employeeid
Union ALL
SELECT 
	'2' AS 'Run Order',
	[bdg].[Badge] AS 'Badge',
    [bdg].[Facility]  AS 'Facility Number',
    --AS 'SSN',
	TRY_CONVERT(VARCHAR(10), [usr].[UserFieldValue]) AS 'Employee ID',
	[per].[FrstName] AS 'First Name',
	[per].[LastName] AS 'Last Name',
	'N/A' AS 'HR Site Code',
	'N/A' AS 'HR Site Name',
	'Duplicate personnel on EmployeeID.' AS 'Reason',
	'Delete the incorrect personnel and badge record' AS 'Action',
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
	) AS 'Last Updated By',
	[bdg].[LastUpdated] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time' AS 'Last Updated CST'
	FROM [stg].[caPerson] [per]
		INNER JOIN [stg].[caBadge] [bdg] ON [bdg].[PersonID] = [per].[PersonID]
		INNER JOIN [stg].[caUserFields] [usr] ON [usr].[Badge] = [bdg].[Badge]
		INNER JOIN [CardAccessLiveConfigurationPH].[dbo].[Operators] [opr] ON [opr].[OperatorID] = [per].[LastOperator]
	        AND [usr].[Facility] = [bdg].[Facility]
	        AND [usr].[PersonID] = [bdg].[PersonID]
	        AND [usr].[UserFieldID] = 
		        (
		        SELECT [UserFieldID]
		        FROM [stg].[caUserFieldDef]
		        WHERE [UserFieldName] = 'EmployeeID:'
		        )
	WHERE [usr].[UserFieldValue] IN 
	(	
	SELECT [usr].[UserFieldValue]
		FROM [stg].[caBadge] [bdg]
			INNER JOIN [stg].[caUserFields] [usr] ON [usr].[Badge] = [bdg].[Badge]
				AND [usr].[Facility] = [bdg].[Facility]
				AND [usr].[PersonID] = [bdg].[PersonID]
				AND [usr].[UserFieldID] = 
					(
					SELECT [UserFieldID]
					FROM [stg].[caUserFieldDef]
					WHERE [UserFieldName] = 'EmployeeID:'
					)
		WHERE [usr].[UserFieldValue] <> 'N/A'
		GROUP BY [usr].[UserFieldValue]
		HAVING COUNT(*) > 1
	)

--Invalid Account
Union ALL
SELECT 
	'3' AS 'Run Order',
	[bdg].[Badge] AS 'Badge',
	[bdg].[Facility] AS 'Facility Number',
	--0,
    TRY_CONVERT(VARCHAR(10), REPLACE(SUBSTRING([per].[LastName], 1, CHARINDEX(',', [per].[LastName])), ',', '')) AS 'Employee ID',
	[per].[FrstName] AS 'First Name',
	[per].[LastName] AS 'Last Name',
	COALESCE([emp].[HRSiteCode], '') AS 'HR Site Code',
	COALESCE([emp].[HRSiteName], '') AS 'HR Site Name',
	'Invalid Account.' AS 'Reason',
	'Delete the badge records or ensure correct setup if non-employee.' AS 'Action',
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
	) AS 'Last Updated By',
	[bdg].[LastUpdated] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time' AS 'Last Updated CST'
	FROM [stg].[caPerson] [per]
		INNER JOIN [stg].[caBadge] [bdg] ON [bdg].[PersonID] = [per].[PersonID]
	LEFT OUTER JOIN [dbo].[dimEmployeeAllFutureHireTermV2] [emp] ON [emp].[EmployeeID] = TRY_CONVERT(INT, [per].[SSN])
	WHERE [per].[LastName] LIKE '%invalid%' 
		AND COALESCE([per].[CompanyID], 0) = 0

--Invalid Temp/Exec Badge
Union ALL
SELECT 
	'4' AS 'Run Order',
	[bdg].[Badge] AS 'Badge',
	[bdg].[Facility] AS 'Facility Number',
	--0 AS 'SSN',
	CASE
        WHEN [emp].[EmployeeID] IS NOT NULL THEN TRY_CONVERT(VARCHAR(10), [emp].[EmployeeID])
        ELSE 'none'
    END AS 'Employee ID',
	[per].[FrstName] AS 'First Name',
	[per].[LastName] AS 'Last Name',
	CASE
        WHEN [emp].[HRSiteCode] IS NULL THEN 'None'
        ELSE [emp].[HRSiteCode]
    END AS 'HR Site Code',
	CASE
        WHEN [emp].[HRSiteName] IS NULL THEN 'None'
        ELSE [emp].[HRSiteName]
    END AS 'HR Site Name',
	'Invalid Temp/Exec Badge.' AS 'Reason',
	'Update Last Name to be employee id followed by a comma, Example: "0000000, Name"' AS 'Action',
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
	) AS 'Last Updated By',
	[bdg].[LastUpdated] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time' AS 'Last Updated CST'
	FROM [stg].[caPerson] [per]
		INNER JOIN [stg].[caBadge] [bdg] ON [bdg].[PersonID] = [per].[PersonID]
		INNER JOIN [map].[AutomationExternalExclusion] [ext] ON [ext].[ID] = [per].[CompanyID]
			AND [ext].[IsEmployee] = 1
		LEFT OUTER JOIN [dbo].[dimEmployeeAllFutureHireTermV2] [emp] ON [emp].[EmployeeID] = TRY_CONVERT(INT, REPLACE(SUBSTRING([per].[LastName], 1, CHARINDEX(',', [per].[LastName])), ',', ''))
	WHERE [emp].[EmployeeID] IS NULL
		AND [bdg].[Enabled] <> 0

--Terminated Employee
Union ALL
SELECT 
	'5' AS 'Run Order',
	[bdg].[Badge] AS 'Badge',
	[bdg].[Facility] AS 'Facility Number',
	--'' AS 'SSN',
    TRY_CONVERT(VARCHAR(10), REPLACE(SUBSTRING([per].[LastName], 1, CHARINDEX(',', [per].[LastName])), ',', '')) AS 'Employee ID',
	[per].[FrstName] AS 'First Name',
	[per].[LastName] AS 'Last Name',
	[emp].[HRSiteCode] AS 'HR Site Code',
	[emp].[HRSiteName] AS 'HR Site Name',
	'Terminated employee. Access removed and badge disabled' AS 'Reason',
	'Remove employee Id from last name on personnel record or delete from the system' AS 'Action',
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
        FROM [CardAccessArchiveEventsPH_2].dbo.[DBAudit] [dba]
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
    ),
    (
        SELECT TOP 1 
            [dbaopr].[OperLoginName]
        FROM [CardAccessArchiveEventsPH_2].dbo.[DBAudit] [dba]
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
) AS 'Last Updated By',
	[per].[LastUpdated] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time' AS 'Last Updated CST'
	FROM [stg].[caPerson] [per]
		INNER JOIN [stg].[caBadge] [bdg] ON [bdg].[PersonID] = [per].[PersonID]
		INNER JOIN [map].[AutomationExternalExclusion] [ext] ON [ext].[ID] = [per].[CompanyID] 
			AND [ext].[IsEmployee] = 1
		INNER JOIN [dbo].[dimEmployeeAllFutureHireTermV2] [emp] ON [emp].[EmployeeID] = TRY_CONVERT(INT, REPLACE(SUBSTRING([per].[LastName], 1, CHARINDEX(',', [per].[LastName])), ',', '')) 
            AND [emp].[TerminationDate] IS NOT NULL

--Active no access groups
Union ALL
SELECT 
	'6' AS 'Run Order',
	[bdg].[Badge] AS 'Badge',
	[bdg].[Facility] AS 'Facility Number',
	--'' AS 'SSN',
    TRY_CONVERT(VARCHAR(10), [emp].[EmployeeID])AS 'Employee ID',
	[per].[FrstName] AS 'First Name',
	[per].[LastName] AS 'Last Name',
	[emp].[HRSiteCode] AS 'HR Site Code',
	[emp].[HRSiteName] AS 'HR Site Name',
	'Active Employee and badge has no access groups.' AS 'Reason',
	'Check with ID Team and IMAC role and ensure correctly setup. Role: ' + [emprl].[RoleName] AS 'Action',
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
	) AS 'Last Updated By',
	[bdg].[LastUpdated] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time' AS 'Last Updated CST'
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
		AND emp.EmployeeStatusCode <> 'L'

--Too many Access Groups				
Union ALL
SELECT 
	'7' AS 'Run Order',
	[bdg].[Badge] AS 'Badge',
	[bdg].[Facility] AS 'Facility Number',
	--TRY_CONVERT(INT, [per].[SSN]),
    TRY_CONVERT(VARCHAR(10), [emp].[EmployeeID]) AS 'Employee ID',
	[per].[FrstName] AS 'First Name',
	[per].[LastName] AS 'Last Name',
	[emp].[HRSiteCode] AS 'HR Site Code',
	[emp].[HRSiteName] AS 'HR Site Name',
	'Employee is part of more that 16 access groups. System Limit, only first 16 applied' AS 'Reason',
	'Check with ID team and role setup in IMAC as employees can not be part of more than 16 continental access groups' AS 'Action',
	'N/A' AS 'Last Updated By',
    '' AS 'Last Updated CST'
	FROM [stg].[caPerson] [per]
		INNER JOIN [stg].[caBadge] [bdg] ON [bdg].[PersonID] = [per].[PersonID]
		INNER JOIN [dbo].[dimEmployeeAllFutureHireTermV2] [emp] ON [emp].[EmployeeID] = TRY_CONVERT(INT, [per].[SSN])
	WHERE TRY_CONVERT(INT, [per].[SSN]) IN 
    ( 
	SELECT [grp].[employeeid]
    FROM [stg].[ADUserGroup] [grp]
    WHERE [grp].[name] LIKE 'AG-CAPHI-%'
    GROUP BY [grp].[employeeid] HAVING COUNT(*) > 16
    )

--Empty Access Groups
Union ALL
SELECT 
	'8' AS 'Run Order',
	[bdg].[Badge] AS 'Badge',
	[bdg].[Facility] AS 'Facility Number',
	--'' AS 'SSN',
    TRY_CONVERT(VARCHAR(10), [emp].[EmployeeID]) AS 'Employee ID',
	[per].[FrstName] AS 'First Name',
	[per].[LastName] AS 'Last Name',
    [emp].[HRSiteCode] AS 'HR Site Code',
	[emp].[HRSiteName] AS 'HR Site Name',
	'Active employee badge assigned access group(s) that have no access defined.' AS 'Reason',
	'Setup the access group(s) in Continental. Groups: ' + STRING_AGG([magrp].[Description], ', ') AS 'Action',
	'N/A' AS 'Last Updated By',
    '' AS 'Last Updated CST'
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
		    [emp].[HRSiteName]
        ORDER BY 'Run Order' ASC,'Employee ID', 'Last Updated CST' desc
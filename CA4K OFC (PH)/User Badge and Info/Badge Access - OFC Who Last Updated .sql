Select TOP (100)
MAG.AgrpNo 'Access Group #',
MAG.[Description] 'Access Group NAme',
P.[LastName] 'Last Name',
BA.AGSeq 'Order Access was Provided',
BA.[LastUpdated] 'Badge Access Last Updated CST',
BA.[LastUpdated] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time' AS 'Badge Access Last Updated CST',
OP.[OperLoginName] 'Badge Access Last Updated By',
R.[RoleName],
'-' 'Spacer',
BA.*
FROM [CardAccessLiveConfigurationPH].[dbo].[BadgeAccess] BA
Join [CardAccessLiveConfigurationPH].[dbo].[Badge] B on B.[Badge] = BA.[Badge]
JOIN [CardAccessLiveConfigurationPH].[dbo].[Person] P ON P.[PersonID] = B.[PersonID]
JOIN [CardAccessLiveConfigurationPH].[dbo].MAccGrp MAG ON MAG.AgrpNo = BA.AGroupNo
JOIN [CardAccessLiveConfigurationPH].[dbo].Operators OP on OP.OperatorID = BA.LastOperator
JOIN [CardAccessLiveConfigurationPH].[dbo].[Roles] R on OP.[RoleID] = R.[RoleID]
WHERE BA.[Badge] IN ('192086','158258')
--ORDER BY b.[badge] ASC, BA.AGSeq Asc


SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT
      O.[OperFName] AS 'Name'
      ,O.[OperLName] AS 'Last Name'
      ,O.[OperLoginName] AS ' User Name'
      --,O.[OperatorID]
      ,R.[RoleName] AS 'Role Name'
      ,O.[EmailID]
      ,O.[EventCount]
      ,O.[LastOperator]
      ,O.[LastLoginAttemptDt]
      ,O.[OperatorID]
  FROM [CardAccessLiveConfigurationsMX].[dbo].[Operators] AS O
  LEFT JOIN [CardAccessLiveConfigurationsMX].[dbo].[Roles] as R on O.[RoleID] = R.[RoleID]
  -- Use the following section to display return the operator based on the ID.
  --Where O.OperatorID = '3b0a2aac-9345-4cfb-8d87-3cde5056772f'
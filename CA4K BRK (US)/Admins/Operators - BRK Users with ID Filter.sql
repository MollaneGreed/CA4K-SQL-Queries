SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT
      O.[OperFName] AS 'Name'
      ,O.[OperLName] AS 'Last Name'
      ,O.[OperLoginName] AS ' User Name'
      --,O.[OperatorID]
      ,O.[EmailID]
      ,R.[RoleName] AS 'Role Name'
      ,O.[EmailID]
      ,O.[EventCount]
      ,O.[LastOperator]
      ,O.[LastLoginAttemptDt]
  FROM [CardAccessLiveConfigurationUS].[dbo].[Operators] AS O
  LEFT JOIN [CardAccessLiveConfigurationUS].[dbo].[Roles] as R on O.[RoleID] = R.[RoleID]
  -- Use the following section to display return the operator based on the ID.
  --Where O.OperatorID = 'b72771da-fa7a-4a21-b6ed-a2765576d54b'
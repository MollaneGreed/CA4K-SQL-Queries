DECLARE
  @SQL NVARCHAR(MAX),
  @SearchFilter varchar(10) = 'false',
  @OperatorID VARCHAR(100) = 'b72771da-fa7a-4a21-b6ed-a2765576d54b',
  @LiveConfigDB NVARCHAR(255) = 'CardAccessLiveConfiguration';

SET @SQL = 'SELECT
      O.[OperFName] AS ''Name''
      ,O.[OperLName] AS ''Last Name''
      ,O.[OperLoginName] AS ''User Name''
      --,O.[OperatorID]
      ,R.[RoleName] AS ''Role Name''
      ,O.[EmailID]
      ,O.[EventCount]
      ,O.[LastLoginAttemptDt]
      ,O.[OperatorID]
  FROM ' + QUOTENAME(@LiveConfigDB) + '.[dbo].[Operators] AS O
  LEFT JOIN ' + QUOTENAME(@LiveConfigDB) + '.[dbo].[Roles] as R on O.[RoleID] = R.[RoleID]
    Where (@SearchFilter <> ''True'' OR O.[OperatorID] LIKE ''%'' + @OperatorID + ''%'')';

EXEC sp_executesql
    @SQL,
    N'@SearchFilter varchar(10), @OperatorID VARCHAR(100)',
    @SearchFilter = @SearchFilter,
    @OperatorID = @OperatorID;
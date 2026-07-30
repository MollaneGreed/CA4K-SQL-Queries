DECLARE
  @SQL NVARCHAR(MAX),
  @SearchFilter varchar(10) = 'false',
  @APBFilter varchar(10) = 'True',
  @TrackFilter varchar(10) = 'false',
  @UserName VARCHAR(100) = '',
  @LiveConfigDB NVARCHAR(255) = 'CardAccessLiveConfiguration';

SET @SQL = 'SELECT
      CASE
        WHEN p.[Enabled] = 1 THEN ''Enabled''
        WHEN p.[Enabled] = 0 THEN ''Disabled''
      END AS ''Enabled'',
      p.[FrstName] ''First Name'',
      p.[LastName] ''Last Name'',
      p.[badge],
      CASE
        WHEN p.[mAPBExempt] = 1 THEN ''True''
        WHEN p.[mAPBExempt] = 0 THEN ''False''
      END AS ''APB Exempt'',
      CASE
        WHEN p.[Track] = 1 THEN ''True''
        WHEN p.[Track] = 0 THEN ''False''
      END AS ''Tracked'',
      p.[LastUpdated],
      o.[screenname] ''Last Updated by''
  FROM ' + QUOTENAME(@LiveConfigDB) + '.[dbo].[ca_vw_Personnel] p
  LEFT JOIN ' + QUOTENAME(@LiveConfigDB) + '.[dbo].[ca_vw_OperatorGetAll] AS o ON p.[LastOperator] = o.[pk]
  WHERE p.[enabled] = 1
  AND (@TrackFilter <> ''True'' OR p.[Track] = 1) 
  AND (@APBFilter <> ''True'' OR p.[mAPBExempt] = 1)
  ORDER BY p.[LastName] ASC, p.[FrstName] ASC';

EXEC sp_executesql
    @SQL,
    N'@SearchFilter varchar(10), @APBFilter varchar(10), @TrackFilter varchar(10), @UserName VARCHAR(100)',
    @SearchFilter = @SearchFilter,
    @APBFilter = @APBFilter,
    @TrackFilter = @TrackFilter,
    @UserName = @UserName;
DECLARE
  @SQL NVARCHAR(MAX),
  @LiveConfigDB NVARCHAR(255) = 'CardAccessLiveConfiguration';

SET @SQL = 'SELECT
    sl.[scriptID] AS ''Script ID''
    ,CASE
        WHEN sl.[scriptLinkEnabled] = 1 THEN ''(1) Enabled''
        WHEN sl.[scriptLinkEnabled] = 0 THEN ''(0) Disabled''
        ELSE CAST(sl.[scriptLinkEnabled] AS VARCHAR)
    END AS ''Script Status''
    ,sl.[pnlNo] AS ''Panel#''
    ,sl.[DeviceNo] AS ''Device#''
    ,sl.[scriptLinkName] AS ''Script Editor Name''
    ,s.[scriptName] AS ''Script Link Name''
    ,s.[scriptText] AS ''Script Text''
    ,O.[OperLoginName] AS ''Operator Name''
    ,sl.[lastUpdated] AS ''Last Update''
  FROM ' + QUOTENAME(@LiveConfigDB) + '.[dbo].[alarmLink_ScriptLinks] sl
    LEFT JOIN ' + QUOTENAME(@LiveConfigDB) + '.[dbo].[alarmLink_Scripts] s ON s.[scriptID] = sl.[scriptID]
    LEFT JOIN ' + QUOTENAME(@LiveConfigDB) + '.[dbo].[Operators] O ON O.[OperatorID] = sl.[lastoperator]';

  EXEC sp_executesql
  @SQL;
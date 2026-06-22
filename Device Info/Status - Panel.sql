-- Set the following variables
DECLARE
  @SQL NVARCHAR(MAX),
  @DeviceFilter NVARCHAR(10) = 'False',
  @DeviceName NVARCHAR(255) = '',
  @LiveConfigDB NVARCHAR(255) = 'CardAccessLiveConfiguration',
  @LiveEventsDB NVARCHAR(255) = 'CardAccessLiveEvents';

SET @SQL = '
  SELECT 
    S.[Panel] ''Panel #''
    ,P.[PanelName]
    ,convert(varchar, FORMAT(S.[Status], ''00'')) + '' - '' + convert(varchar, sd.[StatusDescription]) ''Status''
    ,S.[SDate] AT TIME ZONE ''UTC'' AT TIME ZONE ''Central Standard Time'' AS [Last Sync (CST)]
    ,S.[Xact] ''Pending Transactions (Xact)''
  FROM ' + QUOTENAME(@LiveEventsDB) + '.[dbo].[Status] S
  LEFT JOIN ' + QUOTENAME(@LiveConfigDB) + '.[dbo].[ca_vw_GetPanels] P ON S.[Panel] = P.[PanelNo]
  LEFT JOIN ' + QUOTENAME(@LiveEventsDB) + '.[dbo].[StatusDefs] sd ON sd.[StatusID] = S.[Status]
  Where [state] = 0
  AND (@DeviceFilter = ''FALSE'' OR P.[PanelName] LIKE ''%'' + @DeviceName + ''%'')
  ORDER BY [Panel] ASC';

EXEC sp_executesql @SQL,
    N'@DeviceFilter NVARCHAR(10),
      @DeviceName NVARCHAR(255)'
    ,@DeviceFilter = @DeviceFilter
    ,@DeviceName = @DeviceName;
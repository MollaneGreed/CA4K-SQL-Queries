DECLARE 
  @SQL NVARCHAR(MAX),
  @DeviceFilter NVARCHAR(10) = 'False',
  @DeviceName NVARCHAR(255) = '',
  @LiveConfigDB NVARCHAR(255) = 'CardAccessLiveConfiguration',
  @LiveEventsDB NVARCHAR(255) = 'CardAccessLiveEvents';

SET @SQL = '
Select
    vwdl.[PanelId] ''Panel #''
    ,vwdl.[DeviceId] ''Device #''
    ,vwdl.[Description]
    ,r.[Sensor] ''Input Sensor''
    ,convert(varchar, FORMAT(stat.[Status], ''00'')) + '' - '' + convert(varchar, sd.[StatusDescription]) ''Status''
FROM' + QUOTENAME(@LiveConfigDB) + '.[dbo].[ca_vw_DeviceList] vwdl
LEFT JOIN' + QUOTENAME(@LiveEventsDB) + '.[dbo].[Status] stat ON stat.[Panel] = vwdl.[PanelId] AND stat.[Device] = vwdl.[DeviceId]
LEFT JOIN' + QUOTENAME(@LiveEventsDB) + '.[dbo].[StatusDefs] sd ON sd.[StatusID] = stat.[Status]
LEFT JOIN' + QUOTENAME(@LiveConfigDB) + '.[dbo].[Reader] r ON r.[PnlRef] = vwdl.[PanelId] AND r.[RdrNo] = vwdl.[DeviceId] AND vwdl.[DeviceType] = ''Reader''
WHERE sd.[StatusDescription] NOT IN (''Disabled'', ''OFF'', ''ON'')
    AND vwdl.[DeviceType] IN (''Reader'')
    AND (@DeviceFilter = ''FALSE'' OR vwdl.[Description] LIKE ''%'' + @DeviceName + ''%'')
ORDER BY vwdl.[PanelId], vwdl.[DeviceId]';

EXEC sp_executesql @SQL,
    N'@DeviceFilter NVARCHAR(10),
      @DeviceName NVARCHAR(255)'
    ,@DeviceFilter = @DeviceFilter
    ,@DeviceName = @DeviceName;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
Select
    vwdl.[PanelId] 'Panel #'
    ,vwdl.[DeviceId] 'Device #'
    --,vwdl.[DeviceType]
    ,vwdl.[Description]
    ,r.[Sensor] 'Input Sensor'
    ,convert(varchar, FORMAT(stat.[Status], '00')) + ' - ' + convert(varchar, sd.[StatusDescription]) 'Status'
    --,DATEADD(HH,-5, stat.[SDate]) 'EDAte -5'
FROM [CardAccessLiveConfigurationPH].[dbo].[ca_vw_DeviceList] vwdl
LEFT JOIN [CardAccessLiveEventsPH].[dbo].[Status] stat ON stat.[Panel] = vwdl.[PanelId] AND stat.[Device] = vwdl.[DeviceId]
LEFT JOIN [CardAccessLiveEventsPH].[dbo].[StatusDefs] sd ON sd.[StatusID] = stat.[Status]
LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Reader] AS r ON r.[PnlRef] = vwdl.[PanelId] AND r.[RdrNo] = vwdl.[DeviceId] AND vwdl.[DeviceType] = 'Reader'
WHERE sd.[StatusDescription] NOT IN ('Disabled', 'OFF', 'ON')
    -- AND vwdl.[DeviceType] IN ('Reader')
    --AND vwdl.[Description] IS NOT NULL
    AND vwdl.[DeviceType] IN ('Reader')
    -- AND [Panel] NOT IN ('1')
    --AND stat.[Status] <> '2'
    --AND vwdl.[Description] LIKE 'SMSR%'
ORDER BY vwdl.[PanelId], vwdl.[DeviceId]
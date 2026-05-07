Select
convert(varchar, FORMAT([PanelId], '00')) + '-' + convert(varchar, FORMAT([DeviceId], '00')) 'Pnl - Rdr',
*
FROM [CardAccessLiveConfigurationPH].[dbo].[ca_vw_DeviceList]
WHERE [DeviceId] != 0
--WHERE [Description] NOT LIKE '%OUT%'
ORDER BY [Description] ASC
--ORDER BY [PanelId], [DeviceId]
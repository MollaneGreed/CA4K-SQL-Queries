-- The following query checkes if the tempdb #DeviceView exists and drops it if needed. Otherwise it creates a table that multiple queries run against.

IF OBJECT_ID('tempdb..#DeviceView') IS NOT NULL
    DROP TABLE #DeviceView;

Select
    convert(varchar, FORMAT([PanelId], '00')) 'Panel#'
    ,convert(varchar, FORMAT([DeviceId], '00')) 'Device#'
    ,[Description]
    ,[DeviceType]
INTO #DeviceView
FROM [CardAccessLiveConfigurationUS].[dbo].[ca_vw_DeviceList];

Select
    [Panel#]
    ,[Description] 'Name'
FROM #DeviceView
WHERE [DeviceType] = 'Panel'
ORDER BY 'Name';

Select
    [Panel#] + ' - ' + [Device#] 'Pnl-Rdr'
    ,[Description] 'Name'
FROM #DeviceView
WHERE [DeviceType] = 'Reader'
ORDER BY 'Pnl-Rdr';

Select
    [Panel#] + ' - ' + [Device#] 'Pnl-Rly'
    ,[Description] 'Name'
FROM #DeviceView
WHERE [DeviceType] = 'Relay'
ORDER BY 'Pnl-Rly';

Select
    [Panel#] + ' - ' + [Device#] 'Pnl-Inp'
    ,[Description] 'Name'
FROM #DeviceView
WHERE [DeviceType] = 'Input'
ORDER BY 'Pnl-Inp';

Select
    [Panel#] + ' - ' + [Device#] 'Pnl-prog'
    ,[Description] 'Name'
FROM #DeviceView
WHERE [DeviceType] = 'Link'
ORDER BY 'Pnl-prog';
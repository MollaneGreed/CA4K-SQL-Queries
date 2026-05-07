-- Set the variables
    DECLARE @AccessGroup NVARCHAR(100) = 'AG-CAPHI-IT-DTS';
    DECLARE @Reader NVARCHAR(100) = 'Zambales';

--Search
Select
mag.AgrpNo,
mag.[Description],
p.PnlNo,
p.[PanelName],
r.RdrNo,
r.ReaderName
FROM [CardAccessLiveConfigurationPH].[dbo].[AccGrp] ag
JOIN [CardAccessLiveConfigurationPH].[dbo].[mAccGrp] mag ON mag.[AgrpNo] = ag.[Agno]
JOIN [CardAccessLiveConfigurationPH].[dbo].[Panel] p ON p.[pnlNo] = ag.[pnlref]
JOIN [CardAccessLiveConfigurationPH].[dbo].[Reader] r ON r.[PnlRef] = p.[PnlNo]

WHERE mag.[Description] LIKE '%' + @AccessGroup + '%' 
    AND r.ReaderName LIKE '%' + @Reader + '%'
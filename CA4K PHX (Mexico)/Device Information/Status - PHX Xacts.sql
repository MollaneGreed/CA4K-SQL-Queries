-- RUN from the MX SQL server
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT 
    t1.Panel,
	t4.PanelName,
    t1.Type,
    t1.Device,
        CASE
        WHEN t1.Status = 13 THEN 'Active'
        ELSE 'N/A' 
    END 'Status',
    t1.SDate,
    t1.State,
    t1.Version,
    t1.Xact
FROM CardAccessLiveEventsMX.dbo.Status t1 
LEFT JOIN CardAccessArchiveEventsMX.dbo.Status t2 ON t1.Panel = t2.Panel
LEFT JOIN CardAccessArchiveEventsMX_2.dbo.Status t3 ON t1.Panel = t3.Panel
LEFT JOIN CardAccessLiveConfigurationPH.dbo.Panel t4 On t1.Panel = t4.PnlNo 
WHERE t1.Xact > 0 OR t2.Xact > 0 OR t3.Xact > 0
ORDER By Xact DESC

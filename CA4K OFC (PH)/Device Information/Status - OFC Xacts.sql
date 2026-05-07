-- RUN from the OFC SQL server
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT 
    t1.Panel 'Panel Number',
	t1.Version 'Panel Firmware/Activity',
    t4.PanelName 'Panel Name',
    t4.ComPort,
    CASE
        WHEN t1.Status = 13 THEN 'Active'
        ELSE 'N/A' 
    END 'Status',
    t1.Xact 'Xact (Queued Transactions)',
    t1.SDate 'Last Updated UTC'
--Get the status table contents from the Live table in Afni's PH environment
FROM CardAccessLiveEventsPH.dbo.Status t1 
--Add the the contents from the archive table to the live table (This is the short term storage)
LEFT JOIN CardAccessArchiveEventsPH.dbo.Status t2 ON t1.Panel = t2.Panel
--Add the the contents from the archive_2 table to the live table (This is the long term storage)
LEFT JOIN CardAccessArchiveEventsPH_2.dbo.Status t3 ON t1.Panel = t3.Panel
-- Obtain the Panel Name
LEFT JOIN CardAccessLiveConfigurationPH.dbo.Panel t4 On t1.Panel = t4.PnlNo 
Where t1.Status = 13
AND t1.State = 0
AND t1.Xact > 0 OR t2.Xact > 0 OR t3.Xact > 0
ORDER By 'Xact (Queued Transactions)' DESC
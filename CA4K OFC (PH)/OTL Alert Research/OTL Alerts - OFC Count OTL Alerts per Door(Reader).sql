-- Run from the OFC SQL Server.
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT
    r.ReaderName 'Reader/User Name',
    p.PanelName 'Panel Name',
    --live_e.PnlNo 'Panel#',
    live_e.DeviceNo 'Reader#',
    live_e.class 'Event Type',
    COUNT(live_e.Description) AS 'Event Count'
FROM CardAccessLiveEventsPH.dbo.Event live_e
LEFT JOIN CardAccessArchiveEventsPH.dbo.Event archive_e
  ON live_e.PnlNo = archive_e.PnlNo AND live_e.DeviceNo = archive_e.DeviceNo -- Join based on the Panel and Reader Numbers
  AND archive_e.EDate >= DATEADD(DAY, -1, GETDATE()) -- Filter Archive table for last 24 hours
  AND archive_e.EDate <= GETDATE()
  AND archive_e.class = 'DOOR Open too Long'
LEFT JOIN CardAccessLiveConfigurationPH.dbo.Panel p
  ON live_e.PnlNo = p.PnlNo
LEFT JOIN CardAccessLiveConfigurationPH.dbo.Reader r
  ON live_e.PnlNo = r.PnlRef 
  AND live_e.DeviceNo = r.RdrNo
  AND r.NoOTL = '0'
  -- Filter for Live table last 24 hours
WHERE live_e.EDate >= DATEADD(DAY, -1, GETDATE())
  AND live_e.EDate <= GETDATE()
  --AND live_e.class IN ('DOOR Open too long', 'DOOR Now Closed')
  --AND live_e.DESCRIPTION LIKE '%TAKODANA%'
  --AND t4.ReaderName IS NOT NULL
  AND live_e.class = 'DOOR Open too Long'
GROUP BY live_e.class, r.ReaderName, p.PanelName, live_e.PnlNo, live_e.DeviceNo
ORDER BY 'Event Count' DESC;
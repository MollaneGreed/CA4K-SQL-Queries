-- Run from the OFC SQL Server.
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT
    t1.Description 'Reader/User Name',
    t3.PanelName 'Panel Name',
    t1.PnlNo 'Panel Number',
    t1.DeviceNo 'Reader Number',
    t1.class 'Event Type',
    COUNT(t1.Description) AS 'Event Count'
FROM CardAccessLiveEventsPH.dbo.Event t1
LEFT JOIN CardAccessArchiveEventsPH.dbo.Event t2
  ON t1.PnlNo = t2.PnlNo AND t1.DeviceNo = t2.DeviceNo -- Join based on the Panel and Reader Numbers
    AND t2.EDate >= DATEADD(DAY, -1, GETDATE()) -- Filter Archive table for last 24 hours
    AND t2.EDate <= GETDATE()
LEFT JOIN CardAccessLiveConfigurationPH.dbo.Panel t3 
  ON t1.PnlNo = t3.PnlNo
WHERE t1.EDate >= DATEADD(DAY, -1, GETDATE()) -- Filter for Live table last 24 hours
  AND t1.EDate <= GETDATE()
  AND t1.Badge = '0'
  --AND t1.class IN ('DOOR Open too Long','INPUT Abnormal','INPUT Abnormal')
  --AND t1.class NOT IN ('LINK Event Link Activate','BADGE Clock In','Badge Valid', 'INPUT Normal')
--GROUP BY t1.Description, t1.PnlNo, t1.DeviceNo, t1.class
GROUP BY t1.Description, t3.PanelName, t1.PnlNo, t1.DeviceNo, t1.class
ORDER BY 'Event Count' DESC, [Panel Number] ASC;

/*Select TOP (5)
*
FROM CardAccessArchiveEventsPH.dbo.Event
*/
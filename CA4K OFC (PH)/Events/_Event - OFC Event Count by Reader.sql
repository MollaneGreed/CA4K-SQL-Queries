-- Run from the OFC SQL Server.
DECLARE @READERS NVARCHAR(100) = 'SMT4 03F 85050 PROD 1 REAR'

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT
    t4.ReaderName 'Reader Name',
    t3.PanelName 'Panel Name',
    t1.PnlNo 'Panel#',
    t1.DeviceNo 'Reader3',
    t1.class 'Event Type',
    COUNT(t1.Description) AS 'Event Count'
FROM CardAccessLiveEventsPH.dbo.Event t1
  LEFT JOIN CardAccessArchiveEventsPH.dbo.Event t2
    ON t1.PnlNo = t2.PnlNo 
    AND t1.DeviceNo = t2.DeviceNo -- Join based on the Panel and Reader Numbers
    AND t2.EDate >= DATEADD(DAY, -1, GETDATE()) -- Set the start date to 24 hours ago
    AND t2.EDate <= GETDATE() -- Set the end date to now.
  LEFT JOIN CardAccessLiveConfigurationPH.dbo.Panel t3 
    ON t1.PnlNo = t3.PnlNo -- Match the Panel number in the event to the panel table
  LEFT JOIN CardAccessLiveConfigurationPH.dbo.Reader t4
    ON t1.PnlNo = t4.PnlRef AND t1.DeviceNo = t4.RdrNo -- Match the Panel and Reader numbers from the event table.
WHERE t1.EDate >= DATEADD(DAY, -1, GETDATE()) -- Set the start date to 24 hours ago
  AND t1.EDate <= GETDATE() -- Set the end date to now.
  AND t1.class LIKE 'DOOR%'
  AND t4.ReaderName LIKE '%' + @Readers + '%'
GROUP BY t1.class, t4.ReaderName, t3.PanelName, t1.PnlNo, t1.DeviceNo
ORDER BY t1.[PnlNo] DESC, t1.[Class] DESC;
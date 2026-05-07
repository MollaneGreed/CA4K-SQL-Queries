SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT 
    --,c.Enabled AS "COM Active "
    CASE
        WHEN c.Enabled = 0 THEN 'Disabled'
        WHEN c.Enabled = 1 THEN 'Active'
        ELSE 'N/A'
    END AS "COM Active"
    --,p.Enabled AS "Panel Active "
    ,CASE
        WHEN p.Enabled = 0 THEN 'Disabled'
        WHEN p.Enabled = 1 THEN 'Active'
        ELSE 'N/A'
    END AS "Panel Active"
    ,c.ComPort AS "Com Port #"
    ,p.PnlNo AS "Panel #"
    ,p.Address AS "Panel Address"
    ,c.IPAddress AS "IP Address"
    ,c.MACAddress AS "MAC Address"
    ,p.PanelName AS "Panel Name"
    ,p.Description AS "Panel Description"
    ,p.pan
    ,p.LastUpdated AS "Panel Last Updated"
    ,p.UTCOffset AS "Panel UTCOffset"
FROM CardAccessLiveConfigurationUS.dbo.Com AS c
LEFT JOIN CardAccessLiveConfigurationUS.dbo.Panel AS p ON c.ComPort = p.ComPort
ORDER BY c.ComPort, p.PnlNo
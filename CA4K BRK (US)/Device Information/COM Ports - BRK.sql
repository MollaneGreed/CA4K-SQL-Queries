-- This needs to be run from the SQL server and CardAccessLiveConfiguration database
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT 
--List of Panel Fields
    c.ComPort AS "Com Port #",
    CASE
        WHEN c.Enabled = 0 THEN 'Disabled'
        WHEN c.Enabled = 1 THEN 'Active'
        ELSE 'N/A'
    END AS "COM Active",
    c.IPAddress AS "IP Address",
    c.MACAddress AS "MAC Address",
    p.PanelName AS "Panel Name",
    c.LastUpdated as "Last Updated"    
FROM CardAccessLiveConfigurationUS.dbo.Com AS c
LEFT JOIN CardAccessLiveConfigurationUS.dbo.Panel AS p ON c.ComPort = p.ComPort
ORDER BY c.ComPort
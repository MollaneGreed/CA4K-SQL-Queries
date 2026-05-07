-- This needs to be run from the SQL server and CardAccessLiveConfiguration database
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT 
--List of Panel Fields
    p.PnlNo AS "Panel #",
    p.ComPort AS "Com Port #",
    CASE
        WHEN c.Enabled = 0 THEN 'Disabled'
        WHEN c.Enabled = 1 THEN 'Active'
        ELSE 'N/A'
    END AS "COM Active",
    c.IPAddress AS "IP Address",
    c.MACAddress AS "MAC Address",
    p.Enabled AS "Panel Active ",
    p.PanelName AS "Panel Name",
    p.Description AS "Panel Description",
    p.LastUpdated AS "Panel Last Updated",
    p.UTCOffset AS "Panel UTCOffset"
    --c.MACAddress AS "COM MAC",
/*List of Reader Fields
    r.Enabled AS "Reader Active",
    r.PnlRef AS "Reader Panel #",
    r.RdrNo AS "Reader #",
    r.ReaderName AS "Reader Name",
    r.LastUpdated AS "Reader Last Updated",
    r.UTCOffset AS "Reader UTCOffset"
    */
FROM CardAccessLiveConfigurationPH.dbo.Panel AS p
LEFT JOIN CardAccessLiveConfigurationPH.dbo.COM AS c ON p.ComPort = c.ComPort
ORDER BY p.PnlNo;

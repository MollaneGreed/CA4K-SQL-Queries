-- This needs to be run from the SQL server and CardAccessLiveConfiguration database
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT DISTINCT
--List of Panel Fields
    c.ComPort AS "Com Port #",
    c.DESCRIPTION AS "Com Port Desc",
    CASE
        WHEN c.Enabled = 0 THEN 'Disabled'
        WHEN c.Enabled = 1 THEN 'Active'
        ELSE 'N/A'
    END AS "COM Active",
    c.IPAddress AS "IP Address",
    c.MACAddress AS "MAC Address",
    p.PnlNo AS "Panel #",
    CASE
        WHEN al.Enabled = 1 THEN 'Active'
        WHEN i.Enabled = 1 THEN 'Active'
        WHEN r.Enabled = 1 THEN 'Active'
        WHEN p.Enabled = 1 THEN 'Active'
        WHEN c.Enabled = 1 THEN 'Active'
        Else 'Disabled'
    END AS "Devide Active",
    CASE
        WHEN al.ProgNo IS NOT NULL THEN 'Active Link'
        WHEN i.InpNo IS NOT NULL THEN 'Input'
        WHEN r.RdrNo IS NOT NULL THEN 'Reader'
        WHEN p.PnlNo IS NOT NULL THEN 'Panel'
        WHEN c.ComPort IS NOT NULL THEN 'COM Port'
    END AS "Device Type",
    CASE
        WHEN al.ProgNo IS NOT NULL THEN al.ProgNo
        WHEN i.InpNo IS NOT NULL THEN i.InpNo
        WHEN r.RdrNo IS NOT NULL THEN r.RdrNo
        WHEN p.PnlNo IS NOT NULL THEN p.PnlNo
        WHEN c.ComPort IS NOT NULL THEN c.ComPort
    END AS "Device #",
    CASE
        WHEN al.ProgNo IS NOT NULL THEN al.Description
        WHEN i.InpNo IS NOT NULL THEN i.Description
        WHEN r.RdrNo IS NOT NULL THEN r.Description
        WHEN p.PnlNo IS NOT NULL THEN p.PanelName
        WHEN c.ComPort IS NOT NULL THEN c.DESCRIPTION
    END AS "Name",
    CASE
        WHEN al.ProgNo IS NOT NULL THEN al.LastUpdated
        WHEN i.InpNo IS NOT NULL THEN i.LastUpdated
        WHEN r.RdrNo IS NOT NULL THEN r.LastUpdated
        WHEN p.PnlNo IS NOT NULL THEN p.LastUpdated
        WHEN c.ComPort IS NOT NULL THEN c.LastUpdated
    END AS "Last Updated",
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
FROM CardAccessLiveConfigurationUS.dbo.Com AS c
LEFT JOIN CardAccessLiveConfigurationUS.dbo.Panel AS p ON c.ComPort = p.ComPort
LEFT JOIN CardAccessLiveConfigurationUS.dbo.Reader AS r ON p.PnlNo = r.PnlRef
LEFT JOIN CardAccessLiveConfigurationUS.dbo.MActiveLinks AS al ON p.PnlNo = al.PnlRef
LEFT JOIN CardAccessLiveConfigurationUS.dbo.Input AS i ON p.PnlNo = i.PnlRef    

ORDER BY c.ComPort, "Device Type"
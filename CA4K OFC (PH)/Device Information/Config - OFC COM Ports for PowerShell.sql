-- Run from the LiveConfig Database
SELECT 
    CONCAT(
        CASE WHEN LEN(c.ComPort) = 1 THEN '0' + CAST(c.ComPort AS VARCHAR(2)) ELSE CAST(c.ComPort AS VARCHAR(2)) END,
        '-',        
        CASE WHEN LEN(p.PnlNo) = 1 THEN '0' + CAST(p.PnlNo AS VARCHAR(2)) ELSE CAST(p.PnlNo AS VARCHAR(2)) END,
        ', ',
        c.IPAddress,
        ', ',
        p.PanelName
    ) AS "Combined Column"
FROM COM AS c
LEFT JOIN Panel AS p ON c.ComPort = p.ComPort
ORDER BY "Combined Column";

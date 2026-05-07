-- This needs to be run from the SQL server and CardAccessLiveConfiguration database
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT 
--List of Fields
    p.[PnlNo] AS "Panel #",
    CASE
        WHEN p.[Enabled] = 0 THEN 'Disabled'
        WHEN p.[Enabled] = 1 THEN 'Active'
        ELSE 'N/A'
    END AS "Panel Active",
    r.[RdrNo] AS "Reader #",
    CASE
        WHEN r.[Enabled] = 0 THEN 'Disabled'
        WHEN r.[Enabled] = 1 THEN 'Active'
        ELSE 'N/A'
    END AS "Reader Active",
    --c.IPAddress AS "IP Address",
    --c.MACAddress AS "MAC Address",
    r.[ReaderName] AS "Reader Name",
    r.[Sensor] AS "Door Sensor Input",
    r.[Bypass] AS "Bypass Input",
    r.[LastUpdated] AS "Reader Last Updated"

FROM [CardAccessLiveConfigurationPH].[dbo].[Reader] AS r
LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Panel] AS p ON r.[PnlRef] = p.[PnlNo]

-- Update to filter by a panel#. <> is ≠
WHERE p.[Pnlno] > 0

-- Change the following to switch between filter methods.
-- ORDER BY p.[PnlNo],r.[RdrNo];
ORDER BY r.ReaderName


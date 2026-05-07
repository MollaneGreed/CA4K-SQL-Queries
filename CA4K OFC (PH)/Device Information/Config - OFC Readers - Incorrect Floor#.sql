-- This needs to be run from the SQL server and CardAccessLiveConfiguration database
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT 
--List of Fields
    p.[PnlNo] AS "Panel #",
    r.[RdrNo] AS "Reader #",
    r.[ReaderName] AS "Reader Name",
    r.[LastUpdated] AS "Reader Last Updated"

FROM [CardAccessLiveConfigurationPH].[dbo].[Reader] AS r
LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Panel] AS p ON r.[PnlRef] = p.[PnlNo]
-- The following will search for Any Site that does not match the 'OFC 04F' format.
WHERE r.ReaderName LIKE '___ _F%'
ORDER BY p.PnlNo, r.RdrNo
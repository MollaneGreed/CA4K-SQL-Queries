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
    r.[LastUpdated] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time' AS [Last Updated (CST)],
    o.[OperLoginName] AS 'Last Updated by'
FROM [CardAccessLiveConfigurationsMX].[dbo].[Reader] AS r
    LEFT JOIN [CardAccessLiveConfigurationsMX].[dbo].[Panel] AS p ON r.[PnlRef] = p.[PnlNo]
    LEFT JOIN [CardAccessLiveConfigurationsMX].[dbo].[Operators] AS o ON r.[LastOperator] = o.[operatorID]
ORDER BY p.[PnlNo],r.[RdrNo];


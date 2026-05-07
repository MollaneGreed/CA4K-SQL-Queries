-- This needs to be run from the SQL server and CardAccessLiveConfiguration database
WITH PartitionNamesCTE AS (
    SELECT dp.[caObjectID], 
        STRING_AGG(p.[PartitionName], CHAR(13) + CHAR(10))
        WITHIN GROUP (ORDER BY p.[PartitionName]) AS PartitionNames
    FROM [CardAccessLiveConfigurationPH].[dbo].[DevicePartitions] AS dp
    LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Partition] as p ON dp.[PartitionID] = p.[PartitionID]
    GROUP BY dp.[caObjectID]
)
SELECT
    r.[PnlRef] AS 'Panel #',
    r.[RdrNo] AS 'Reader #',
    convert(varchar, r.[Sensor]) + '-' + convert(varchar, r.[Bypass]) + '-' + convert(varchar, r.[Strike]) 'Current Inp-Byp-Stk',
    r.[ReaderName] AS 'Reader Name',
    PNCTE.PartitionNames AS 'Assigned Partition',
    r.[LastUpdated] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time' AS 'CST_Time',
    o.[OperLoginName] AS 'Last Mod By'
FROM [CardAccessLiveConfigurationPH].[dbo].[Reader] AS r
    LEFT JOIN PartitionNamesCTE AS PNCTE ON PNCTE.caObjectID = r.[caObjectID]
    LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Operators] AS o ON o.[OperatorID] = r.[LastOperator]
WHERE r.[PnlRef] > 0
    --AND PNCTE.PartitionNames Not Like '%06. Reader Access%'
ORDER BY r.[PnlRef], r.[RdrNo];

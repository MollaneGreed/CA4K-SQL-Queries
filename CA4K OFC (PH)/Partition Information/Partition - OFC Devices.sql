--Tables used
----DevicePartitions(PartitionId, caObjectID)
----Partition (PartitionID, PartitionName)
WITH PartitionNamesCTE AS (
    SELECT
        dp.[caObjectID],
        STRING_AGG(p.[PartitionName], ', ') WITHIN GROUP (ORDER BY p.[PartitionName]) AS PartitionNames
    FROM [CardAccessLiveConfigurationPH].[dbo].[DevicePartitions] AS dp
    LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Partition] as p ON dp.[PartitionID] = p.[PartitionID]
    GROUP BY dp.[caObjectID]
),
DeviceTypesCTE AS (
    SELECT
        dp.[caObjectID],
        STRING_AGG(p.[DeviceType], ', ') WITHIN GROUP (ORDER BY p.[DeviceType]) AS DeviceTypes,
        MAX(p.[LastUpdated]) AS LastUpdated
    FROM [CardAccessLiveConfigurationPH].[dbo].[DevicePartitions] AS dp
    LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Partition] as p 
        ON dp.[PartitionID] = p.[PartitionID]
    GROUP BY dp.[caObjectID]
)
SELECT TOP (1000)
    pn.[caObjectID] 'Partition UID' ,
    pn.[PartitionNames] 'Partition Names',
    dt.[DeviceTypes],
    dt.[LastUpdated] 'Device Last Updated'
FROM PartitionNamesCTE AS pn
LEFT JOIN DeviceTypesCTE AS dt ON pn.[caObjectID] = dt.[caObjectID]
--LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Reader] AS r ON r.[caObjectID] = pn.[caObjectID]
ORDER BY pn.[caObjectID];

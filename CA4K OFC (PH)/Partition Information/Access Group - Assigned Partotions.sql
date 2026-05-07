-- The following displays any access group that has only been setup with the default 'Admin Partition'
WITH PartitionNamesCTE AS (
    SELECT dp.[caObjectID], STRING_AGG(p.[PartitionName], ', ') WITHIN GROUP (ORDER BY p.[PartitionName]) AS PartitionNames
    FROM [CardAccessLiveConfigurationPH].[dbo].[DevicePartitions] AS dp
    LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Partition] as p ON dp.[PartitionID] = p.[PartitionID]
    GROUP BY dp.[caObjectID]
)
SELECT
    mag.[AgrpNo],
    mag.[Description],
    PNCTE.PartitionNames AS 'Assigned Partition',
    DATEADD(HH,-5, mag.[LastUpdated]) 'CST_Time',
    DATEADD(HH,+8, mag.[LastUpdated]) 'Manila_Time',
    o.[OperLoginName] AS 'Last Mod By'
FROM [CardAccessLiveConfigurationPH].[dbo].[MAccGrp] AS mag
    LEFT JOIN PartitionNamesCTE AS PNCTE ON PNCTE.caObjectID = mag.[caObjectID]
    LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Operators] AS o ON o.[OperatorID] = mag.[LastOperator]
    WHERE mag.[Description] like '%'
      AND PNCTE.PartitionNames NOT LIKE 'Admin Partition, %' 
      --AND PNCTE.PartitionNames NOT IN ('Admin Partition, Part. 03. DataCenter Control')
ORDER BY mag.[AgrpNo]
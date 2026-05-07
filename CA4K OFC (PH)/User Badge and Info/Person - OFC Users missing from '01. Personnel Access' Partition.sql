-- The Following collects information from the Partition and DevicePartitions tables to display the users that are not members of the 01. Personnel Access partition.
---- Create Custom Table for all the partition groups related to a single device.
WITH PartitionNamesCTE AS (
    SELECT dp.[caObjectID],
     STRING_AGG(
        p.[PartitionName],
        ', ') 
      WITHIN GROUP (
        ORDER BY p.[PartitionName]) AS [PartitionNames],
         MAX(p.[LastUpdated]) AS [LastUpdated]
---- Get data from Device Partition table and join it to the Partition table
    FROM [CardAccessLiveConfigurationPH].[dbo].[DevicePartitions] AS dp 
        JOIN [CardAccessLiveConfigurationPH].[dbo].[Partition] as p ON dp.[PartitionID] = p.[PartitionID]
    GROUP BY dp.[caObjectID]
    )
---- List all the user fields
SELECT 
    B.badge 'CA4K Badge',
    B.Embossed 'Employee ID',
    Pers.[FrstName],
    Pers.[LastName],
    pn.[PartitionNames] 'Current Partitions',
    Pers.[PersonID] "User's UID"
---- Get the user fields from the Personnel, Badge, and Custom Table
FROM [CardAccessLiveConfigurationPH].[dbo].[Badge] B 
    JOIN [CardAccessLiveConfigurationPH].[dbo].[Person] Pers on Pers.PersonID = B.PersonID 
    JOIN PartitionNamesCTE pn on pn.caObjectID = Pers.PersonID 
WHERE pn.[PartitionNames] NOT LIKE '%01. Personnel Access%' 
ORDER BY pers.[LastUpdated] DESC;

-- Create the table of user and partitions that need to be added to the DevicePartitions table
---- Create Custom Table for all the partition groups related to a single device.
WITH PartitionNamesCTE AS (
    SELECT 
    dp.[caObjectID],
    STRING_AGG(
        p.[PartitionName],
        ', ')
    WITHIN GROUP (
        ORDER BY p.[PartitionName]) AS [PartitionNames],
        MAX(p.[LastUpdated]) AS [LastUpdated]
---- Get data from Device Partition table and join it to the Partition table
    FROM [CardAccessLiveConfigurationPH].[dbo].[DevicePartitions] AS dp JOIN [CardAccessLiveConfigurationPH].[dbo].[Partition] as p ON dp.[PartitionID] = p.[PartitionID]
    GROUP BY dp.[caObjectID])
--Table of the specific entries that need to be added to the DevicePartitions table
SELECT 
    'bdd04732-955f-4833-86a4-a39aea80ac25' [PartitionID],
    Pers.[PersonID] AS [caObjectID]
---- Get the user fields from the Personnel and Custom Table
FROM [CardAccessLiveConfigurationPH].[dbo].[Person] Pers 
JOIN PartitionNamesCTE pn on pn.caObjectID = Pers.PersonID 
WHERE pn.[PartitionNames] NOT LIKE '%01. Personnel Access%'
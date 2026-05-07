SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT Distinct
p.[PartitionName],
p.[PartitionID]
  FROM [CardAccessLiveConfigurationPH].[dbo].[Partition] as p
  ORDER BY PartitionName;
/*
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT Distinct
p.[PartitionName],
p.[PartitionID],
TRY_CONVERT(varchar, p.[DeviceType]) + '. ' + pg.[PartGroupName] 'Device Type ID + Name'
  FROM [CardAccessLiveConfigurationPH].[dbo].[Partition] as p
  LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[PartitionGroup] AS pg ON p.[DeviceType] = pg.[DeviceType]
  LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[DevicePartitions] as dp ON dp.[PartitionID] = p.[PartitionID]
  WHERE p.[PartitionName] IS NOT NULL
  ORDER BY PartitionName;
*/
--/*
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT Distinct
[DeviceType],
[PartGroupName],
[LastUpdated]
  FROM [CardAccessLiveConfigurationPH].[dbo].[PartitionGroup]
  ORDER BY DeviceType;
--*/
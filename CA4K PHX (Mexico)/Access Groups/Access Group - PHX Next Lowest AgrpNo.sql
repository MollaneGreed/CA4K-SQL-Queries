SELECT 
MIN(AGTabl1.AgrpNo + 1) AS LowestUnusedAgrpNo
FROM [CardAccessLiveConfigurationsMX].[dbo].[MAccGrp] AGTabl1
WHERE NOT EXISTS (
    SELECT 1
    FROM [CardAccessLiveConfigurationsMX].[dbo].[MAccGrp] AGTable2
    WHERE AGTable2.AgrpNo = AGTabl1.AgrpNo + 1
);
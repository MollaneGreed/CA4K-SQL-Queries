SELECT 
MIN(AGTabl1.AgrpNo + 1) AS LowestUnusedAgrpNo
FROM [CardAccessLiveConfigurationUS].[dbo].[MAccGrp] AGTabl1
WHERE NOT EXISTS (
    SELECT 1
    FROM [CardAccessLiveConfigurationUS].[dbo].[MAccGrp] AGTable2
    WHERE AGTable2.AgrpNo = AGTabl1.AgrpNo + 1
);
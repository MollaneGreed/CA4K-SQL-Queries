SELECT 
MIN(AGTabl1.AgrpNo + 1) AS LowestUnusedAgrpNo
FROM [CardAccessLiveConfigurationPH].[dbo].[MAccGrp] AGTabl1
WHERE NOT EXISTS (
    SELECT 1
    FROM [CardAccessLiveConfigurationPH].[dbo].[MAccGrp] AGTable2
    WHERE AGTable2.AgrpNo = AGTabl1.AgrpNo + 1
);

SELECT
*
FROM [CardAccessLiveConfigurationPH].[dbo].[MAccGrp]
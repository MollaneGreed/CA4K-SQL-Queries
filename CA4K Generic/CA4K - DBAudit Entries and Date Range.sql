-- Count number of rows and show the first/last entry.
SELECT 
    COUNT(*) AS TotalRows
    --,MIN(RevisionStamp) AS FirstEntryDate
    --,MAX(RevisionStamp) AS LastEntryDate
--FROM [dbo].[DBAudit];
FROM [CardAccessLiveConfigurationsMX].[dbo].[ca_vw_Personnel]

[CardAccessArchiveConfigurationPH]
[CardAccessArchiveEventsPH]
[CardAccessCustomPH]
[CardAccessLiveConfigurationPH]
[CardAccessLiveEventsPH]
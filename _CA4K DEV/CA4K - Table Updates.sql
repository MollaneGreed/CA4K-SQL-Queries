-- Update Specific field with filters from another table.
/*
UPDATE rp
SET rp.[OTHPrior] = '9'
FROM [CardAccessLiveConfigurationPH].[dbo].[ReaderPriority] rp
LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Reader] r
    ON rp.PnlRef = r.PnlRef
    AND rp.RdrNo = r.RdrNo
WHERE rp.OTHPrior = '50'
AND (r.ReaderName LIKE '%OFC% TRAINING %'
    OR r.ReaderName LIKE '%OFC% TR %'
    OR r.ReaderName LIKE '%SMT4% TRAINING %'
    OR r.ReaderName LIKE '%SMT4% TR %')
;*/


SELECT
    rp.PnlRef 'Panel #'
	,rp.RdrNo 'Reader #'
    ,r.ReaderName
    ,rp.OTHPrior ' Other Denied'
FROM [CardAccessLiveConfigurationPH].[dbo].[ReaderPriority] rp
LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Reader] r ON rp.PnlRef = r.PnlRef AND rp.RdrNo = r.RdrNo
WHERE (r.ReaderName LIKE '%OFC% TRAINING %'
OR r.ReaderName LIKE '%OFC% TR %'
OR r.ReaderName LIKE '%SMT4% TRAINING %'
OR r.ReaderName LIKE '%SMT4% TR %')
;
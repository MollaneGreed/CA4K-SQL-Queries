-- This needs to be run from the SQL server and CardAccessLiveConfiguration database
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT
     r.[PnlRef] 'Panel#'
    ,r.[RdrNo] 'Reader#'
    ,r.[ReaderName] 'Reader Name'
    ,rp.[OTLPrior] 'Other Denied'
    ,rp.[VPrior] 'Void Violate'
    ,rp.[OTHPrior] 'Other Denied'
FROM [CardAccessLiveConfigurationPH].[dbo].[Reader] r
LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Readerpriority] rp ON r.PnlRef = rp.PnlRef AND r.RdrNo = rp.RdrNo
WHERE rp.[OTHPrior] = '9'
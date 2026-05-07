SELECT
    [PnlRef]
    ,[RdrNo]
    ,[ReaderName]
    ,[NoOTL]
    ,[OTL]
    ,[RepeatOTL]
FROM [CardAccessLiveConfigurationPH].[dbo].[Reader]
WHERE [NoOTL] = 1
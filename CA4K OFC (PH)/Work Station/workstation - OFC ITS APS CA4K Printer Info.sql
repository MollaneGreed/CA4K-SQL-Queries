SELECT
    [WorkstationName]
    ,[UsePrinting]
    ,[EventPrn]
    ,[BadgingPrn]
    ,[UseBadging]
    ,[Badgingoption]
    ,[EventPrinter]
FROM [CardAccessLiveConfigurationPH].[dbo].[WorkstationSettings]
WHERE WorkstationName LIKE 'ITS-APS-%'
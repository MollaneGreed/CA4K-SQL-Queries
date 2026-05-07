SELECT
    [WorkstationName]
    ,[UsePrinting]
    ,[EventPrn]
    ,[BadgingPrn]
    ,[UseBadging]
    ,[Badgingoption]
    ,[EventPrinter]
FROM [CardAccessLiveConfigurationsMX].[dbo].[WorkstationSettings]
WHERE WorkstationName LIKE 'ITS-APS-%'
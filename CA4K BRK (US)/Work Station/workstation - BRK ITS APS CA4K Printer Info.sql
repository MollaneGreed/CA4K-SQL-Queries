SELECT
    [WorkstationName]
    ,[UsePrinting]
    ,[EventPrn]
    ,[BadgingPrn]
    ,[UseBadging]
    ,[Badgingoption]
    ,[EventPrinter]
FROM [CardAccessLiveConfigurationUS].[dbo].[WorkstationSettings]
WHERE [EventPrn] <> 'Microsoft Print to PDF' OR [EventPrinter] <> 'Microsoft Print to PDF'
--WHERE WorkstationName LIKE 'ITS-APS-%'


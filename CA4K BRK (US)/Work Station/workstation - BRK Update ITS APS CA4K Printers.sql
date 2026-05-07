Update [CardAccessLiveConfigurationUS].[dbo].[WorkstationSettings]
SET [UsePrinting] = '1'
,[EventPrn] = 'Microsoft Print to PDF'
,[BadgingPrn] = 'None'
,[UseBadging] = '1'
,[Badgingoption] = '1'
,[EventPrinter] = 'Microsoft Print to PDF'
WHERE WorkstationName LIKE 'ITS-APS-%'
AND ([EventPrn] <> 'Microsoft Print to PDF' OR [EventPrinter] <> 'Microsoft Print to PDF')
;

SELECT
    [WorkstationName]
    ,[UsePrinting]
    ,[EventPrn]
    ,[BadgingPrn]
    ,[UseBadging]
    ,[Badgingoption]
    ,[EventPrinter]
FROM [CardAccessLiveConfigurationUS].[dbo].[WorkstationSettings]
WHERE WorkstationName LIKE 'ITS-APS-%'
;
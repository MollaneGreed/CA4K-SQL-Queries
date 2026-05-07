SELECT
WorkstationName
,UsePrinting
,EventPrn
,BadgingPrn
,UseBadging
,Badgingoption
,EventPrinter
FROM [CardAccessLiveConfigurationUS].[dbo].[WorkStationSettings]
--WHERE [EventPrinter] NOT LIKE 'Microsoft Print to PDF'
--OR [UsePrinting] NOT LIKE '1'
--OR [BadgingPrn] NOT LIKE 'None'
--OR [UseBadging]
/*
Update [CardAccessLiveConfigurationPH].[dbo].[WorkstationSettings]
SET [UsePrinting] = '1'
,[EventPrn] = 'Microsoft Print to PDF'
,[BadgingPrn] = 'None'
,[UseBadging] = '1'
,[Badgingoption] = '1'
,[EventPrinter] = 'Microsoft Print to PDF'
WHERE WorkstationName LIKE 'ITS-APS-%'
AND ([EventPrn] <> 'Microsoft Print to PDF' OR [EventPrinter] <> 'Microsoft Print to PDF')
;
*/
/*
Update [CardAccessLiveConfigurationPH].[dbo].[WorkstationSettings]
SET 
    [UsePrinting] = '1'
    --,[EventPrn] = 'Microsoft XPS Document Writer'
    --,[EventPrn] = 'Microsoft Print to PDF'
    ,[EventPrn] = 'OneNote (Desktop)'
    ,[BadgingPrn] = 'None'
    ,[UseBadging] = '1'
    ,[Badgingoption] = '1'
    ,[EventPrinter] = 'Microsoft XPS Document Writer'
WHERE WorkstationName LIKE 'APS-5C4QBD4'
--AND ([EventPrn] = 'Microsoft Print to PDF' OR [EventPrinter] <> 'Microsoft XPS Document Writer')
;
*/
SELECT
    WS.[WorkstationName]
    ,WS.[UsePrinting]
    ,WS.[EventPrn]
    ,WS.[BadgingPrn]
    ,WS.[UseBadging]
    ,WS.[Badgingoption]
    ,WS.[EventPrinter]
    ,O.[OperLoginName]
FROM [CardAccessLiveConfigurationPH].[dbo].[WorkstationSettings] WS
LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Operators] O ON WS.[LastOperator] = O.[OperatorID]
WHERE WorkstationName LIKE 'APS-%'
--ORDER BY WS.[LastUpdated] DESC
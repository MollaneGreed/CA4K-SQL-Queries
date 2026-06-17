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
--WHERE WorkstationName LIKE 'ITS-APS-%'
ORDER BY WS.[LastUpdated] DESC
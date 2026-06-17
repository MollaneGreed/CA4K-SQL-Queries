SELECT
    ws.[WorkstationName]
    ,ws.[UsePrinting]
    ,ws.[EventPrn]
    ,ws.[BadgingPrn]
    ,ws.[UseBadging]
    ,ws.[Badgingoption]
    ,ws.[EventPrinter]
    ,op.[OperLoginName] 'Last Operator'
FROM [CardAccessLiveConfigurationsMX].[dbo].[WorkstationSettings] ws
LEFT JOIN [CardAccessLiveConfigurationsMX].[dbo].[Operators] op ON op.OperatorID = ws.LastOperator
--WHERE WorkstationName NOT LIKE 'ITS-APS-%'
--WHERE ws.[EventPrn] <> 'Microsoft Print to PDF' OR ws.[EventPrinter] <> 'Microsoft Print to PDF'
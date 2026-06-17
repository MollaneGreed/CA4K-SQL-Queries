SELECT
    O.[OperFName] 'Name'
    ,O.[OperLName] 'Last Name'
    ,O.[OperLoginName] ' User Name'
    ,OS.[SearchOnChange]
FROM [CardAccessliveconfigurationPH].[dbo].[Operatorsettings] OS
LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Operators] O ON OS.[OperatorID] = O.[OperatorID]
ORDER BY O.[OperLoginName]
--WHERE [SearchOnChange] = '1'
;
/*
UPDATE [CardAccessliveconfigurationPH].[dbo].[Operatorsettings]
SET [SearchOnChange] = '0'
FROM [CardAccessliveconfigurationPH].[dbo].[Operatorsettings]
WHERE [SearchOnChange] = '1' ;

SELECT
    O.[OperFName] 'Name'
    ,O.[OperLName] 'Last Name'
    ,O.[OperLoginName] ' User Name'
    ,OS.[SearchOnChange]
FROM [CardAccessliveconfigurationPH].[dbo].[Operatorsettings] OS
LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Operators] O ON OS.[OperatorID] = O.[OperatorID]
;
*/
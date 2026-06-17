--Setup the initial Variable
DECLARE @AgrpNo INT;

-- Search for the highest group number
SELECT TOP (1)
@AgrpNo = [AgrpNo]
FROM [CardAccessLiveConfigurationUS].[dbo].[MAccGrp]
ORDER BY [AgrpNo] DESC;

-- Display the value stored
SELECT @AgrpNo AS 'Stored @AgrpNo';

-- Search for any panel that does not have the Correct Max Value Set
SELECT
[PnlNo] 'Panel#'
,[PanelName] 'Panel Name'
,[AGSize] 'Max Access Groups'
FROM [CardAccessLiveConfigurationUS].[dbo].[Panel]
WHERE [AGSize] < @AgrpNo
;

-- Update all Panels to use the stored value
/*
UPDATE [CardAccessLiveConfigurationPH].[dbo].[Panel]
SET [AGSize] = @AgrpNo
WHERE [AGSize] <> @AgrpNo
;

-- Search to display all panels to validate their max access group size
SELECT
[PnlNo] 'Panel#'
,[PanelName] 'Panel Name'
,[AGSize] 'Max Access Groups'
FROM [CardAccessLiveConfigurationUS].[dbo].[Panel]
*/
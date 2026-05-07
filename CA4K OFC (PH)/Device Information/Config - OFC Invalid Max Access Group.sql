-- Setup the initial Variable
DECLARE @AgrpNo INT;

-- Search for the highest group number
SELECT TOP (1) 
@AgrpNo = [AgrpNo] 
FROM [CardAccessLiveConfigurationPH].[dbo].[MAccGrp] 
ORDER BY [AgrpNo] DESC;

-- Display the value stored
SELECT @AgrpNo AS 'Stored @AgrpNo';

-- Search for any panel that does not have the Correct Max Value Set
SELECT
[PnlNo] 'Panel#'
,[PanelName] 'Panel Name'
,[AGSize] 'Max Access Groups'
FROM [CardAccessLiveConfigurationPH].[dbo].[Panel]
WHERE [AGSize] <> @AgrpNo
;

-- Update all Panels to use the stored value
/*
UPDATE [CardAccessLiveConfigurationPH].[dbo].[Panel]
SET [AGSize] = '434'
WHERE [AGSize] <> '434'
;*/

--Search to display all panels to validate their max access group size
SELECT
[PnlNo] 'Panel#'
,[PanelName] 'Panel Name'
,[AGSize] 'Max Access Groups'
FROM [CardAccessLiveConfigurationPH].[dbo].[Panel]
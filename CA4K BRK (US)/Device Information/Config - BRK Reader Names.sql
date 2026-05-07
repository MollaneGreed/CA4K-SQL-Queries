-- This needs to be run from the SQL server and CardAccessLiveConfiguration database

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT DISTINCT
    r.[PnlRef] AS 'Panel #',
    r.[RdrNo] AS 'Reader #',
    r.[ReaderName] AS 'Reader Name',
    CASE 
        WHEN r.[NoOTL] = '0' THEN 'Always'
        WHEN r.[NoOTL] = '1' THEN 'Only Once'
        WHEN r.[NoOTL] = '2' THEN 'Never'
        else CAST(r.[NoOTL] AS VARCHAR)
    END 'OTL Alert',
    r.[Sensor] 'Door Input Sensor',
    r.[Bypass] 'Bypass Sensor',
    r.[Strike] 'Door Strike Relay',
    CASE
        WHEN r.[RdrNo] = '1'  then  '1'
        WHEN r.[RdrNo] = '2'  then  '3'
        WHEN r.[RdrNo] = '3'  then  '5'
        WHEN r.[RdrNo] = '4'  then  '7'
        WHEN r.[RdrNo] = '5'  then  '9'
        WHEN r.[RdrNo] = '6'  then  '11'
        WHEN r.[RdrNo] = '7'  then  '13'
        WHEN r.[RdrNo] = '8'  then  '15'
        WHEN r.[RdrNo] = '9'  then  '17'
        WHEN r.[RdrNo] = '10' then  '19'
        WHEN r.[RdrNo] = '11' then  '21'
        WHEN r.[RdrNo] = '12' then  '23'
        WHEN r.[RdrNo] = '13' then  '25'
        WHEN r.[RdrNo] = '14' then  '27'
        WHEN r.[RdrNo] = '15' then  '29'
        WHEN r.[RdrNo] = '16' then  '31'
    END 'Default Input ',
    CASE 
        WHEN r.[APBEntry] = apb_in.[AreaNo] THEN apb_in.[Description]
        ELSE CAST(r.[APBEntry] AS VARCHAR)
    END 'APB IN',
    CASE 
        WHEN r.[APBExit] = apb_out.[AreaNo] THEN apb_out.[Description]
        ELSE CAST(r.[APBEntry] AS VARCHAR)
    END 'APB Exit',
    r.[LastUpdated] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time' AS 'CST_Time',
    o.[OperLoginName] AS 'Last Mod By'
    FROM [CardAccessLiveConfigurationUS].[dbo].[Reader] AS r
    LEFT JOIN [CardAccessLiveConfigurationUS].[dbo].[Operators] AS o ON o.[OperatorID] = r.[LastOperator]
    LEFT JOIN [CardAccessLiveConfigurationUS].[dbo].[DevicePartitions] AS dp ON dp.[caObjectID] = r.[caObjectID]
    LEFT JOIN [CardAccessLiveConfigurationUS].[dbo].[APBAreas] AS apb_in ON apb_in.[AreaNo] = r.[APBEntry]
    LEFT JOIN [CardAccessLiveConfigurationUS].[dbo].[APBAreas] AS apb_out ON apb_out.[AreaNo] = r.[APBExit]
WHERE r.[PnlRef] > 0    
    --AND r.[NoOTL] = 0
    --AND r.[ReaderName] LIKE '%83174%'
ORDER BY r.[PnlRef], r.[RdrNo];
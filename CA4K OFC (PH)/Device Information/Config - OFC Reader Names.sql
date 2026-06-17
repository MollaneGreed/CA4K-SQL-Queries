-- This needs to be run from the SQL server and CardAccessLiveConfiguration database

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT DISTINCT
    CASE 
        WHEN r.[NoOTL] = '0' THEN 'Always (0)'
        WHEN r.[NoOTL] = '1' THEN 'Only Once (1)'
        WHEN r.[NoOTL] = '2' THEN 'Never (2)'
        else CAST(r.[NoOTL] AS VARCHAR)
    END 'OTL Alert',
    FORMAT(r.[PnlRef], '00') [Panel#],
    FORMAT(r.[RdrNo], '00') [Reader#],
    --r.[PnlRef] 'Panel#', 
    --r.[RdrNo] 'Reader#',
    convert(varchar, FORMAT(r.[PnlRef], '00')) + '-' + convert(varchar, FORMAT(r.[RdrNo], '00')) 'Pnl - Rdr',
    r.[ReaderName] AS 'Reader Name',
    convert(varchar, FORMAT(r.[Sensor],'00')) + '-' + convert(varchar, FORMAT(r.[Bypass], '00')) + '-' + convert(varchar, FORMAT(r.[Strike],'00')) 'Current Inp-Byp-Stk',
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
FROM [CardAccessLiveConfigurationPH].[dbo].[Reader] AS r
    LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[Operators] AS o ON o.[OperatorID] = r.[LastOperator]
    LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[DevicePartitions] AS dp ON dp.[caObjectID] = r.[caObjectID]
    LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[APBAreas] AS apb_in ON apb_in.[AreaNo] = r.[APBEntry]
    LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[APBAreas] AS apb_out ON apb_out.[AreaNo] = r.[APBExit]
    --WHERE r.[PnlRef] = 15
    --AND r.[NoOTL] = 0
    WHERE r.[ReaderName] LIKE '%83060%'
    -- OR r.[ReaderName] LIKE '%83060%'
    -- OR r.[ReaderName] LIKE '%83063%'
--ORDER BY r.[ReaderName];
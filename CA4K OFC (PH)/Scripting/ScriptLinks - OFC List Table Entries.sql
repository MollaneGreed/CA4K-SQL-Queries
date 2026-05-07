SELECT
    [scriptID] 'Script ID'
    ,LEFT([scriptLinkName],4) 'Message ID'
    ,CASE
        WHEN [scriptLinkEnabled] = 1 THEN '(1) Enabled'
        WHEN [scriptLinkEnabled] = 0 THEN '(0) Disabled'
        ELSE CAST([scriptLinkEnabled] AS VARCHAR)
    END 'Enabled'
    ,[pnlNo] 'Panel#'
    ,[DeviceNo] 'Device#'
    ,[scriptLinkName] 'Script Name'
    ,RIGHT([scriptLinkName],LEN([scriptLinkName])-16) 'Door Name'
  FROM [CardAccessLiveConfigurationPH].[dbo].[alarmLink_ScriptLinks]
  --WHERE [scriptLinkEnabled] = 0
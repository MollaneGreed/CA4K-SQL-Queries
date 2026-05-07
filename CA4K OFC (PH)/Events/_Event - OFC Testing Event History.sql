SELECT Top 100
DATEADD(HH,-6, AckTStamp) 'AckTStamp -6',
[PnlNo],
[DeviceNo] 'Reader',
Case
    WHEN [Description] LIKE '90%, %' THEN [Description]
    WHEN [Description] LIKE '%, %, %, *%' THEN [Description]
    ELSE ' '
END 'Employee',
Case
    WHEN [Description] LIKE '%-% %' THEN [Description]
    ELSE [Name]
END 'Reader',
convert(varchar, [Status]) + ' - ' + [Class] 'Status - Class'
--[Description] 'Raw Description',
--[Name] 'Raw Name'
-- [EDate],
-- [AckTStamp]
-- [Name] 'Panel Name',
-- [Description] 'Trigger Source'
FROM [CardAccessLiveEventsPH].[dbo].[ca_vw_HistEventDisplayGrid]
    -- WHERE [Status] IN ('3','7')
    -- WHERE [Status] NOT IN ('1','2','4','5','6')
ORDER BY [AckTStamp] DESC;
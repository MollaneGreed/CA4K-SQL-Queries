-- Run from CA4K Dev
SELECT 
    [Panel Number],
    [Reader Number],
    [ReaderName],
    [Bypass],
    [Assigned Partition(s)],
    [APB Entry Name],
    [APB Exit Name],
    [Last Updated CST],
    [Last Updated UTC],
    [Last Operator Name]
    FROM [Continental_RPT].[dbo].[Custom_vw_ReaderUS]
    WHERE [Panel Number] > 0
ORDER BY [Last Updated CST] DESC;
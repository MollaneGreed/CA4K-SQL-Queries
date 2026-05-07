SELECT 
    COUNT(*) AS TotalRows,
    MIN([EDate]) AS OldestDate
FROM 
    [CardAccessArchiveEventsPH_2].[dbo].[Event]

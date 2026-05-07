SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT
    CASE 
        WHEN r.[ReaderName] LIKE '%OFC %' THEN  'OFC'
        WHEN r.[ReaderName] LIKE '%SMT4 %' THEN  'SMT4'
        WHEN r.[ReaderName] LIKE '%SMSR %' THEN  'SMSR'
        ELSE 'N/A'
    END AS 'Site',
    CASE 
        WHEN r.[ReaderName] LIKE '%OFC %' THEN  SUBSTRING(r.[ReaderName],CHARINDEX('OFC', r.[ReaderName]) + 4, 3)
        WHEN r.[ReaderName] LIKE '%SMT4 %' THEN  SUBSTRING(r.[ReaderName],CHARINDEX('SMT4', r.[ReaderName]) + 5, 3)
        WHEN r.[ReaderName] LIKE '%SMSR %' THEN  SUBSTRING(r.[ReaderName],CHARINDEX('SMSR', r.[ReaderName]) + 5, 3)
        ELSE 'N/A'
    END  AS 'Floor',
    RIGHT('00' + CAST(r.[PanelID] AS VARCHAR), 2) + '-' + RIGHT('00' + CAST(r.[ReaderID] AS VARCHAR), 2) AS 'Panel# - Reader#',
    r.[ReaderName] AS 'Reader Name'
FROM [CardAccessLiveConfigurationPH].[dbo].[ca_vw_Reader] AS r
ORDER BY [Site], [Floor], r.[PanelID], r.[ReaderID];

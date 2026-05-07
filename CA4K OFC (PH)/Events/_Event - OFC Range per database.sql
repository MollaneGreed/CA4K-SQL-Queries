SELECT
    MAX([EDate] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time') AS "Newest Record (Live CST)",
    MIN([EDate] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time') AS "Oldest Record (Live CST)"
    FROM [CardAccessliveEventsPH].[dbo].[Event];

SELECT
    MAX([EDate] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time') AS "Newest Record (Archive CST)",
    MIN([EDate] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time') AS "Oldest Record (Archive CST)"
    FROM [CardAccessArchiveEventsPH].[dbo].[Event];

SELECT Top (1000)
    MAX([EDate] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time') AS "Newest Record (Archive_2 CST)",
    MIN([EDate] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time') AS "Oldest Record (Archive_2 CST)"
    FROM [CardAccessArchiveEventsPH_2].[dbo].[Event];
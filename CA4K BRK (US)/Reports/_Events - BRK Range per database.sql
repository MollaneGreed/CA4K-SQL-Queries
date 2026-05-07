SELECT
    MIN([EDate] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time') AS "Newest Record (Live CST)",
    MAX([EDate] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time') AS "Oldest Record (Live CST)"
    FROM [CardAccessliveEventsUS].[dbo].[Event];

SELECT
    MIN([EDate] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time') AS "Newest Record (Archive CST)",
    MAX([EDate] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time') AS "Oldest Record (Archive CST)"
    FROM [CardAccessArchiveEventsUS].[dbo].[Event];

SELECT Top (1000)
    MIN([EDate] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time') AS "Newest Record (Archive_2 CST)",
    MAX([EDate] AT TIME ZONE 'UTC' AT TIME ZONE 'Central Standard Time') AS "Oldest Record (Archive_2 CST)"
    FROM [CardAccessArchiveEventsUS_2].[dbo].[Event];
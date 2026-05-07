-- Use other queries to get the sequence event 
DECLARE
    @Start DATE = DATEADD(DAY, -1, GETDATE())
    ,@End DATE = DATEADD(DAY, 1, GETDATE())
    ,@Employee varchar(10) = 'Brownfield'
    ;
SELECT
*
FROM [CardAccessLiveEventsUS].[dbo].[Event]
WHERE ([Description] LIKE '%' + @Employee + '%' OR [Name] LIKE '%' + @Employee + '%')
AND [EDate] BETWEEN @Start AND @End
/*
UPDATE [CardAccessLiveEventsUS].[dbo].[event]
    SET PnlNo = 18
    ,DeviceNo = 5
    ,badge = 33159
    ,Facno = 1
    ,Arch = 16386
    ,HasPhoto = 1
WHERE [seqno] = '96ef3da5-885b-408d-9dcc-cab1895fe542'
;
*/
SELECT*
FROM [CardAccessLiveEventsUS].[dbo].[event]
WHERE [seqno] = '96ef3da5-885b-408d-9dcc-cab1895fe542'
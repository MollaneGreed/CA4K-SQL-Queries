--This Query is able to check for all events that occur between the specified times on multiple days.
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT 
    [PnlNo] 'Panel Number'
    ,[DeviceNo] 'Reader Number'
    ,[AckTStamp] 'Event received by server'
    ,[EDate] 'Event saved to DB'
    ,[Class] 'Event Type'
    ,[Description] 'Event Source'
    ,[Name] 'Event Location'
FROM [CardAccessArchiveEventsPH].[dbo].[Event]
WHERE [EDate] BETWEEN '2024-07-10 15:59:00' AND '2024-07-10 16:09:00'
    OR [EDate] BETWEEN '2024-07-11 15:59:00' AND '2024-07-11 16:09:00'
    OR [EDate] BETWEEN '2024-07-12 15:59:00' AND '2024-07-12 16:09:00'
    OR [EDate] BETWEEN '2024-07-13 15:59:00' AND '2024-07-13 16:09:00'
    OR [EDate] BETWEEN '2024-07-14 15:59:00' AND '2024-07-14 16:09:00'
    OR [EDate] BETWEEN '2024-07-15 15:59:00' AND '2024-07-15 16:09:00'
    OR [EDate] BETWEEN '2024-07-16 15:59:00' AND '2024-07-16 16:09:00';

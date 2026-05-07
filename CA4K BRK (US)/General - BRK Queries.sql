--US SQL Server queries
--Count of US ArchiveEvents_2 per Reader
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    SELECT TOP 10
        e.PnlNo AS 'Panel Number',
        e.DeviceNo AS 'Reader Number',
        e.name AS 'Event Name',
        COUNT(*) AS 'Event Count'
    FROM [CardAccessArchiveEventsUS_2].[dbo].[Event] e
    --WHERE FORMAT(e.edate, 'YYYY-MM') = '2023-09'
    GROUP BY e.PnlNo, e.DeviceNo, e.name
    ORDER BY 'Panel Number','Reader Number';

--Top 10 US Archive_2 events with all columns visible
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    Select Top (10)
    *
    FROM [CardAccessArchiveEventsUS_2].[dbo].[Event];

--All US readers ordered by panel
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    Select
    r.PnlRef AS 'Panel Number',
    r.RdrNo AS 'Reader Number',
    r.ReaderName AS 'Reader Name',
    r.[Description] AS 'Description'
    FROM [CardAccessLiveConfigurationUS].[dbo].Reader r
    ORDER BY r.PnlRef;

--Top 10 US ArchiveEvents_2 Events with Reader Names from ArchiveConfig Joined with e.DeviceNo = r.RdrNo
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    SELECT Top 10
    e.PnlNo AS 'Event Panel Number',
    e.DeviceNo AS 'Event Reader Number',
    r.ReaderName AS 'Reader Name',
    COUNT(*) AS 'Event Count'
    FROM [CardAccessArchiveEventsUS_2].[dbo].[Event] e
    INNER JOIN [CardAccessArchiveConfigurationUS].[dbo].[Reader] r ON (e.DeviceNo = r.RdrNo AND e.PnlNo = r.PnlRef)
    WHERE e.EDate BETWEEN '2022-10-01' AND  '2022-11-01'
    GROUP BY  e.PnlNo, e.DeviceNo, r.ReaderName;

--Top 10 US ArchiveEvents_2 Events with Reader Names from ArchiveConfig Joined with r.RdrNo = e.DeviceNo
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    SELECT top 10
    e.PnlNo AS 'Panel Number',
    e.DeviceNo AS 'Reader Number',
    r.[Description] AS 'Device Name',
    COUNT(e.EDate) AS 'Event Count'
    FROM [CardAccessArchiveEventsUS].[dbo].[Event] e
    JOIN [CardAccessArchiveConfigurationUS].[dbo].[Reader] r ON r.RdrNo = e.DeviceNo
    --WHERE e.edate >= '2023-10-01' AND e.edate < '2023-11-01'
    GROUP BY e.PnlNo, e.DeviceNo, r.Description;


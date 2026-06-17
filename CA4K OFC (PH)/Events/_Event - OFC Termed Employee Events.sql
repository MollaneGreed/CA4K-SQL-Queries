--This Query is able to check for all events that occur between the specified times on multiple days.

DECLARE @DateRange INT = '3';
-- Pick Variables and comment out the unused ones
    -- Start Date Options
        --DECLARE @StartDate DATE = '2025-04-08'; -- Uses Specified Date
        DECLARE @StartDate DATE = DATEADD(HOUR, -@DateRange, GETDATE()); -- Start x Days Ago.
    -- Readers
        DECLARE @Readers NVARCHAR(100) = 'OFC 04F 83024 PROD 1';

-- Do not change the following values
DECLARE @Start DATETIMEOFFSET = CAST(@StartDate AS DATETIME) AT TIME ZONE 'Singapore Standard Time';
DECLARE @End DATETIMEOFFSET = DATEADD(SECOND, 86399, DATEADD(DAY, @DateRange, @Start)); -- Gets 7 Days after Start;

WITH ArchiveEvents AS (
    SELECT
    [EDate],
    [Class],
    [Description],
    [Name],
    [Badge],
    [AckTStamp]
    FROM [CardAccessliveEventsPH].[dbo].[ca_vw_EventDisplayGrid]    
    WHERE [EDate] BETWEEN @Start AND @End
UNION ALL
    SELECT
    [EDate],
    [Class],
    [Description],
    [Name],
    [Badge],
    [AckTStamp]
    FROM [CardAccessArchiveEventsPH].[dbo].[ca_vw_EventDisplayGrid]
    WHERE [EDate] BETWEEN @Start AND @End
UNION ALL
	SELECT
    [EDate],
    [Class],
    [Description],
    [Name],
    [Badge],
    [AckTStamp]
    FROM [CardAccessArchiveEventsPH_2].[dbo].[ca_vw_EventDisplayGrid]
    WHERE [EDate] BETWEEN @Start AND @End
    )
SELECT 
    ae.[EDate] AS [UTC_Time],
    ae.[Class] 'Event Type',
    ae.[Description] 'Event Source',
    CASE
        WHEN p.[Enabled] = '0' THEN 'Disabled'
        WHEN p.[Enabled] = '1' THEN 'Enabled'
    END 'Enabled',
    ae.[Name] 'Event Location',
    ae.[Badge],
    ae.[AckTStamp] 'Acknowledged Time'
FROM ArchiveEvents ae
LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[ca_vw_Personnel] p ON [Description] LIKE p.[LASTNAME] +'%'
WHERE [Enabled] = '0'
ORDER BY [EDate] ASC;

/*
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT TOP (1)
    e.[EDate] AS [UTC_Time],
    e.[Class] 'Event Type',
    e.[Description] 'Event Source',
    CASE
        WHEN p.[Enabled] = '0' THEN 'Disabled'
        WHEN p.[Enabled] = '1' THEN 'Enabled'
    END 'Enabled',
    e.[Name] 'Event Location',
    e.[Badge],
    e.[AckTStamp] 'Acknowledged Time'
FROM [CardAccessliveEventsPH].[dbo].[ca_vw_EventDisplayGrid] e
LEFT JOIN [CardAccessLiveConfigurationPH].[dbo].[ca_vw_Personnel] p ON [Description] LIKE p.[LASTNAME] +'%'
WHERE [Enabled] = '0';

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT TOP (1)
*
FROM [CardAccessLiveConfigurationPH].[dbo].[ca_vw_Personnel]
WHERE [LASTNAME] LIKE '%9067083%';
*/
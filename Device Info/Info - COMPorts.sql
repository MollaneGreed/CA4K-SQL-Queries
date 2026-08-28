-- Set the following variables
DECLARE
  @SQL NVARCHAR(MAX),
  @LiveConfigDB NVARCHAR(255) = 'CardAccessLiveConfiguration';

SET @SQL = '
    SELECT TOP (1000)
        CASE
            WHEN [Enabled] = 1 THEN ''Enabled''
            Else ''Disabled''
        END ''Status''
        ,[COMPort]
        ,CASE
            WHEN [IPAddress] <> '''' THEN [IPAddress]
            ELSE ''''
        END ''IP''
        ,CASE
            WHEN [MACAddress] <> '''' THEN [MACAddress]
            ELSE ''''
        END ''MACAddress''
        ,CASE
            WHEN [Enabled] = 1 THEN ''http://'' + [IPAddress] + '':80''
            ELSE ''''
        END ''Default Portal''
    FROM ' + QUOTENAME(@LiveConfigDB) + '.[dbo].[Com]
    WHERE [COMPort] IS NOT NULL
    ORDER BY [COMPort]';

EXEC sp_executesql @SQL;
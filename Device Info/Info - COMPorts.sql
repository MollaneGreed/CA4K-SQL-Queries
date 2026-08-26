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
        ,[PanelAddress] ''Address''
        ,[COMPort]
        ,[PanelName] ''Name''
        ,[IPAddress] ''IP''
        ,''http://'' + [IPAddress] + '':80'' ''Default Portal''
    FROM ' + QUOTENAME(@LiveConfigDB) + '.[dbo].[ca_vw_HardwarePanel]';

EXEC sp_executesql @SQL;
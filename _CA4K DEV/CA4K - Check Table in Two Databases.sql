DECLARE @TableName sysname = 'alarmLink_ScriptLinks';
DECLARE @SQL nvarchar(MAX);

-- The following places the entire query into the @SQL variable and then executes it at the end.
SET @SQL = N'
SELECT TOP (10) *
FROM CardAccessLiveConfigurationPH_Test.dbo.' + QUOTENAME(@TableName) + N';
SELECT TOP (10) *
FROM CardAccessLiveConfigurationPH.dbo.' + QUOTENAME(@TableName) + N';
';
EXEC sp_executesql @SQL;


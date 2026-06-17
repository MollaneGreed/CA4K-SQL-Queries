DECLARE @TableName sysname = 'MAccGrp';
DECLARE @SQL nvarchar(MAX);

-- The following places the entire query into the @SQL variable and then executes it at the end.
SET @SQL = N'
SELECT TOP (20) *
FROM CardAccessLiveConfigurationPH.dbo.' + QUOTENAME(@TableName) + N';
SELECT TOP (20) * 
FROM CardAccessArchiveConfigurationPH.dbo.' + QUOTENAME(@TableName) + N';
';
EXEC sp_executesql @SQL;


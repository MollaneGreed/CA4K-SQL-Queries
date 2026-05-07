-- Automation that will clear the destination table and populate it with the source.

DECLARE @CurrentTable SYSNAME = 'BuildInfo';  -- <<< CHANGE THIS ONLY

DECLARE
    @HasIdentity BIT,
    @ColumnList NVARCHAR(MAX),
    @SQL NVARCHAR(MAX),
    @SQL2 nvarchar(MAX);

--------------------------------------------------
-- 1. Detect identity column
--------------------------------------------------
SELECT @HasIdentity = CASE WHEN EXISTS (
    SELECT 1
    FROM CardAccessLiveConfigurationPH_Test.sys.columns TestCol
    JOIN CardAccessLiveConfigurationPH_Test.sys.tables TestTab
        ON TestCol.object_id = TestTab.object_id
    WHERE TestTab.name = @CurrentTable
      AND TestCol.is_identity = 1
) THEN 1 ELSE 0 END;

--------------------------------------------------
-- 2. Build column list automatically
--------------------------------------------------
SELECT @ColumnList =
    STRING_AGG(QUOTENAME(TestCol.name), ', ')
    WITHIN GROUP (ORDER BY TestCol.column_id)
FROM CardAccessLiveConfigurationPH_Test.sys.columns TestCol
JOIN CardAccessLiveConfigurationPH_Test.sys.tables TestTab
    ON TestCol.object_id = TestTab.object_id
WHERE TestTab.name = @CurrentTable;

--------------------------------------------------
-- 3. Build full migration script
--------------------------------------------------
SET @SQL = N'
DELETE FROM CardAccessLiveConfigurationPH_Test.dbo.' + QUOTENAME(@CurrentTable) + ';

' + CASE WHEN @HasIdentity = 1 THEN
    'SET IDENTITY_INSERT CardAccessLiveConfigurationPH_Test.dbo.' + QUOTENAME(@CurrentTable) + ' ON;'
    ELSE '' END + '

INSERT INTO CardAccessLiveConfigurationPH_Test.dbo.' + QUOTENAME(@CurrentTable) + '
(' + @ColumnList + ')
SELECT
' + @ColumnList + '
FROM CardAccessLiveConfigurationPH.dbo.' + QUOTENAME(@CurrentTable) + ';

' + CASE WHEN @HasIdentity = 1 THEN
    'SET IDENTITY_INSERT CardAccessLiveConfigurationPH_Test.dbo.' + QUOTENAME(@CurrentTable) + ' OFF;'
    ELSE '' END;

--------------------------------------------------
-- 4. Execute
--------------------------------------------------
EXEC sp_executesql @SQL;

-- The following places the entire query into the @SQL variable and then executes it at the end.
SET @SQL2 = N'
SELECT TOP (3) *
FROM CardAccessLiveConfigurationPH_Test.dbo.' + QUOTENAME(@CurrentTable) + N';
SELECT TOP (3) *
FROM CardAccessLiveConfigurationPH.dbo.' + QUOTENAME(@CurrentTable) + N';
';
EXEC sp_executesql @SQL2;
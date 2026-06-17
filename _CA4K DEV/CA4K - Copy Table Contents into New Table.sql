-- Automation that will clear the destination table and populate it with the source.


--- Update These Values ---
DECLARE @CurrentTable SYSNAME = 'MAccGrp',
        @SourceDB NVARCHAR(MAX) = 'CardAccessArchiveConfigurationPH',
        @DestinationDB NVARCHAR(MAX) = 'CardAccessLiveConfigurationPH'
;


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
    FROM CardAccessLiveConfigurationPH.sys.columns TestCol
    JOIN CardAccessLiveConfigurationPH.sys.tables TestTab
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
FROM CardAccessLiveConfigurationPH.sys.columns TestCol
JOIN CardAccessLiveConfigurationPH.sys.tables TestTab
    ON TestCol.object_id = TestTab.object_id
WHERE TestTab.name = @CurrentTable;

--------------------------------------------------
-- 3. Build full migration script
--------------------------------------------------
SET @SQL = N'
DELETE FROM' + QUOTENAME(@SourceDB) + '.dbo.' + QUOTENAME(@CurrentTable) + ';

' + CASE WHEN @HasIdentity = 1 THEN
    'SET IDENTITY_INSERT ' + QUOTENAME(@DestinationDB) + '.dbo.' + QUOTENAME(@CurrentTable) + ' ON;'
    ELSE '' END + '

INSERT INTO ' + QUOTENAME(@DestinationDB) + '.dbo.' + QUOTENAME(@CurrentTable) + '
(' + @ColumnList + ')
SELECT
' + @ColumnList + '
FROM ' + QUOTENAME(@SourceDB) + '.dbo.' + QUOTENAME(@CurrentTable) + ';

' + CASE WHEN @HasIdentity = 1 THEN
    'SET IDENTITY_INSERT ' + QUOTENAME(@DestinationDB) + '.dbo.' + QUOTENAME(@CurrentTable) + ' OFF;'
    ELSE '' END;

--------------------------------------------------
-- 4. Execute
--------------------------------------------------
EXEC sp_executesql @SQL;

-- The following creates a query that will display the two tables after @SQL2.
SET @SQL2 = N'
SELECT TOP (20) *
FROM ' + QUOTENAME(@DestinationDB) + '.dbo.' + QUOTENAME(@CurrentTable) + N';
SELECT TOP (20) *
FROM ' + QUOTENAME(@SourceDB) + '.dbo.' + QUOTENAME(@CurrentTable) + N';
';
EXEC sp_executesql @SQL2;
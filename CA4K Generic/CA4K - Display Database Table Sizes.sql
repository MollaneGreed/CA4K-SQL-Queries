-- Run against individual databases to see the size of it's tables
SELECT 
    t.NAME AS table_name,
    s.Name AS schema_name,
    p.rows AS row_count,
    ROUND(SUM(a.total_pages) * 8 / 1024, 2) AS size_in_mb,
    ROUND(SUM(a.total_pages) * 8 / 1024 / 1024, 2) AS size_in_gb
FROM sys.tables t
JOIN sys.indexes i ON t.object_id = i.object_id
JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
JOIN sys.allocation_units a ON p.partition_id = a.container_id
JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE i.index_id <= 1
GROUP BY t.Name, s.Name, p.Rows
ORDER BY size_in_mb DESC;

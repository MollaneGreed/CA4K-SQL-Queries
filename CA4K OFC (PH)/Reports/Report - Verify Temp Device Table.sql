
USE tempdb;
GO

SELECT name 
FROM sys.tables
WHERE name LIKE '#DeviceView%';

--DROP TABLE #DeviceView;

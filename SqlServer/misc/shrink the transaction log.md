# Get List of the Logical and Physical Name of the Files in the Entire Database
* SELECT d.name DatabaseName, f.name LogicalName,
f.physical_name AS PhysicalName,
f.type_desc TypeofFile
FROM sys.master_files f
INNER JOIN sys.databases d ON d.database_id = f.database_id
where f.database_id not in (1,2,3,4)
GO

## Check Database Size in SQL SERVER
* SELECT sys.databases.name,
       CONVERT(VARCHAR, SUM(size)*8/1024) + ' MB' AS [Total disk space]
FROM sys.databases
JOIN sys.master_files
ON sys.databases.database_id = sys.master_files.database_id
GROUP BY sys.databases.name
ORDER BY sys.databases.name;

* SELECT mdf.database_id,  mdf.name,  mdf.physical_name as data_file, ldf.physical_name as log_file, 
db_size = CAST((mdf.size * 8.0)/1024 AS DECIMAL(8,2)), log_size = CAST((ldf.size * 8.0 / 1024) AS DECIMAL(8,2))
FROM (SELECT * FROM sys.master_files WHERE type_desc = 'ROWS' ) mdf
JOIN (SELECT * FROM sys.master_files WHERE type_desc = 'LOG' ) ldf
ON mdf.database_id = ldf.database_id

### Shrink the log using TSQL
* ALTER DATABASE AdventureWorks2012
SET RECOVERY SIMPLE
GO
DBCC SHRINKFILE (AdventureWorks2012_log, 1)
GO
ALTER DATABASE AdventureWorks2012
SET RECOVERY FULL
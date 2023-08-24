--DBCC SQLPERF(logspace)

DECLARE @dbname VARCHAR(155) = NULL, @SpaceUsed FLOAT = NULL

DECLARE @LOGSPACE TABLE( dbName VARCHAR(155),LogSizeMB FLOAT,[LogSpaceUsed%] FLOAT,[Status] INT)

INSERT @LOGSPACE EXEC ('DBCC SQLPERF(''logspace'')')

-- Now pull it back for review
-- if your optional parms are null, you return log usage for all databases

SELECT dbName, LogSizeMB, [LogSpaceUsed%], [Status] FROM @LOGSPACE
WHERE (dbName = @dbName OR @dbName IS NULL) AND ([LogSpaceUsed%] >= @SpaceUsed OR @SpaceUsed IS NULL) 
and dbName = 'BK15_MDB';


SELECT DB_NAME (database_id) as [Database Name], name as [Database File Name],
[Type] = CASE WHEN Type_Desc = 'ROWS' THEN 'Data File(s)'
WHEN Type_Desc = 'LOG'  THEN 'Log File(s)'
ELSE Type_Desc END,
size*8/1024 as 'Size (MB)',
physical_name as [Database_File_Location]
FROM sys.master_files
where  DB_NAME (database_id) = 'BK15_MDB'
ORDER BY 1,3

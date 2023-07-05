DECLARE @name NVARCHAR(256) -- database name  
DECLARE @backup_name NVARCHAR(256)
DECLARE @path NVARCHAR(512) -- path for backup files  
DECLARE @fileName NVARCHAR(512) -- filename for backup  
DECLARE @query NVARCHAR(max)

-- specify database backup directory
SET @path = '\\sharedisk\QLSX\Backup\S3DNIPI\Log\'  
  
DECLARE db_cursor CURSOR READ_ONLY FOR  
SELECT name 
FROM master.sys.databases 
WHERE name NOT IN ('master','model','msdb','tempdb')  -- exclude these databases
AND state = 0 -- database is online
AND is_in_standby = 0 -- database is not read only for log shipping

 
OPEN db_cursor   
FETCH NEXT FROM db_cursor INTO @name   
 
WHILE @@FETCH_STATUS = 0   
BEGIN   
   SET @fileName = @path + @name + '_' + CONVERT(NVARCHAR(20),GETDATE(),112) + '_' + REPLACE(CONVERT(NVARCHAR(20),GETDATE(),108),':','') + '.TRN'  
   set @backup_name = @name + ' Log Backup'
   set @query = 'BACKUP LOG [' + @name  +  '] TO DISK = ''' + @fileName +  ''' WITH NOFORMAT, NOINIT,  NAME = ''' + @backup_name + ''', SKIP, NOREWIND, NOUNLOAD,  STATS = 10;' 
   -- select @query as query
   EXECUTE sp_executesql @query 
   
 
   FETCH NEXT FROM db_cursor INTO @name   
END   
 
CLOSE db_cursor   
DEALLOCATE db_cursor
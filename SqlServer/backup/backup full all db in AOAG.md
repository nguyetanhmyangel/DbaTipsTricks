DECLARE @name NVARCHAR(256) -- database name  
DECLARE @path NVARCHAR(512) -- path for backup files  
DECLARE @fileName NVARCHAR(512) -- filename for backup  

-- specify database backup directory
SET @path = '\\sharedisk\QLSX\Backup\S3DNIPI\Full\'  
  
--DECLARE db_cursor CURSOR READ_ONLY FOR  
--SELECT name 
--FROM master.sys.databases 
--WHERE name NOT IN ('master','model','msdb','tempdb')  -- exclude these databases
--AND state = 0 -- database is online
--AND is_in_standby = 0 -- database is not read only for log shipping

DECLARE db_cursor CURSOR READ_ONLY FOR  
SELECT name FROM sys.databases 
where database_id > 4 and state = 0 and user_access = 0 and  name not in (
SELECT
AGDatabases.database_name AS Databasename
FROM sys.dm_hadr_availability_group_states States
INNER JOIN master.sys.availability_groups Groups ON States.group_id = Groups.group_id
INNER JOIN sys.availability_databases_cluster AGDatabases ON Groups.group_id = AGDatabases.group_id
WHERE primary_replica = @@Servername
AND state = 0 -- database is online
AND is_in_standby = 0 -- database is not read only for log shipping
)

 
OPEN db_cursor   
FETCH NEXT FROM db_cursor INTO @name   
 
WHILE @@FETCH_STATUS = 0   
BEGIN   
   SET @fileName = @path + @name + '_' + CONVERT(NVARCHAR(20),GETDATE(),112) + '_' + REPLACE(CONVERT(NVARCHAR(20),GETDATE(),108),':','') + '.BAK'  
   BACKUP DATABASE @name TO DISK = @fileName  
 
   FETCH NEXT FROM db_cursor INTO @name   
END   
 
CLOSE db_cursor   
DEALLOCATE db_cursor
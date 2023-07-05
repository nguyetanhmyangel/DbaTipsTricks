USE [master]
GO

EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'your-database'
GO

-- if error: Cannot drop the database 'VSP_House_RU' because it is being used for replication.
--exec sp_removedbreplication 'VSP_House_RU'
--go

DROP DATABASE [your-database]
GO


--//General script to deletes the backup history one database in secondary and drop it// 
-- show all is not join availability groups visible to this server where this Server is the Primary replica
SELECT name ,'EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N''[' + name + ']'' ; drop database [' + + name + ']' as query
FROM sys.databases 
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
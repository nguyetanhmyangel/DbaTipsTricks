USE [master]
GO

EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'your-database'
GO

-- if error: Cannot drop the database 'VSP_House_RU' because it is being used for replication.
--exec sp_removedbreplication 'VSP_House_RU'
--go

DROP DATABASE [your-database]
GO
-- find recovery mode
select name,recovery_model_desc from sys.databases

ALTER DATABASE AdventureWorks SET RECOVERY FULL|SIMPLE|BULK_LOGGED

----------------------------------------
--Create a full SQL Server backup to disk
--The command is BACKUP DATABASE databaseName.  
--The "TO DISK" option specifies that the backup should be written to disk and the location and filename to create the backup is specified.

BACKUP DATABASE AdventureWorks 
TO DISK = 'C:\AdventureWorks.BAK'
GO

----------------------------------------
--Create a differential SQL Server backup
--This command adds the "WITH DIFFERENTIAL" option.

BACKUP DATABASE AdventureWorks 
TO DISK = 'C:\AdventureWorks.BAK' 
WITH DIFFERENTIAL 
GO

----------------------------
--Create a file level SQL Server backup
--This command uses the "WITH FILE" option to specify a file backup.  
--You need to specify the logical filename within the database which can be obtained by using the command sp_helpdb 'databaseName', 
--specifying the name of your database.

BACKUP DATABASE TestBackup FILE = 'TestBackup' 
TO DISK = 'C:\TestBackup_TestBackup.FIL'
GO

------------------------------
--Create a filegroup SQL Server backup
--This command uses the "WITH FILEGROUP" option to specify a filegroup backup.  
--You need to specify the filegroup name from the database which can be obtained by using the command sp_helpdb 'databaseName', 
---specifying the name of your database.

BACKUP DATABASE TestBackup FILEGROUP = 'ReadOnly' 
TO DISK = 'C:\TestBackup_ReadOnly.FLG'
GO

-------------------------------------
--Create a full SQL Server backup to multiple disk files
--This command uses the "DISK" option multiple times to write the backup to three equally sized smaller files instead of one large file.

BACKUP DATABASE AdventureWorks 
TO DISK = 'C:\AdventureWorks_1.BAK',
DISK = 'D:\AdventureWorks_2.BAK',
DISK = 'E:\AdventureWorks_3.BAK'
GO

--------------------------
--Create a full SQL Server backup with a password
--This command creates a backup with a password that will need to be supplied when restoring the database.

BACKUP DATABASE AdventureWorks 
TO DISK = 'C:\AdventureWorks.BAK'
WITH PASSWORD = 'Q!W@E#R$'
GO

----
--Create a full SQL Server backup with progress stats
--This command creates a full backup and also displays the progress of the backup.  The default is to show progress after every 10%.

BACKUP DATABASE AdventureWorks 
TO DISK = 'C:\AdventureWorks.BAK'
WITH STATS
GO
---Here is another option showing stats after every 1%.

BACKUP DATABASE AdventureWorks 
TO DISK = 'C:\AdventureWorks.BAK'
WITH STATS = 1
GO

---------------------------------------
--Create a SQL Server backup and give it a description
--This command uses the description option to give the backup a name.  
--This can later be used with some of the restore commands to see what is contained with the backup.  The maximum size is 255 characters.

BACKUP DATABASE AdventureWorks 
TO DISK = 'C:\AdventureWorks.BAK'
WITH DESCRIPTION = 'Full backup for AdventureWorks'
GO

-----------------------------------------
--Create a mirrored SQL Server backup
--This option allows you to create multiple copies of the backups, preferably to different locations.

BACKUP DATABASE AdventureWorks 
TO DISK = 'C:\AdventureWorks.BAK'
MIRROR TO DISK =  'D:\AdventureWorks_mirror.BAK'
WITH FORMAT
GO

-------------------------------------------------------------
--Specifying multiple options for SQL Server Backups
--This next example shows how you can use multiple options at the same time.

BACKUP DATABASE AdventureWorks 
TO DISK = 'C:\AdventureWorks.BAK'
MIRROR TO DISK =  'D:\AdventureWorks_mirror.BAK'
WITH FORMAT, STATS, PASSWORD = 'Q!W@E#R$'
GO
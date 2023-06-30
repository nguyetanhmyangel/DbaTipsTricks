	use master
	go
	DECLARE @Availibility_Group_Name varchar(150) = 'SQL-S3DNIPI', @DiskPath varchar(max) = '\\sharedisk\QLSX\Backup\S3DNIPI\Full\',

	@dbName VARCHAR(155) = NULL, @SpaceUsed FLOAT = NULL ,@results varchar(max),@query nvarchar(max), @path varchar(max)

	DECLARE @LOGSPACE TABLE(dbName VARCHAR(155),LogSizeMB FLOAT, [LogSpaceUsed%] FLOAT,[Status] INT)

	INSERT @LOGSPACE
	EXEC ('DBCC SQLPERF(''logspace'')')

	--select  coalesce(@results + ',', '') +  convert(varchar(12),dbName)
	--from @LOGSPACE WHERE (dbName = @dbName OR @dbName IS NULL) AND ([LogSpaceUsed%] >= @SpaceUsed OR @SpaceUsed IS NULL) and ([LogSpaceUsed%] >= 50)
	--and dbName not in ('model','master','tempdb','msdb')

	---select @results as results

	IF OBJECT_ID(N'tempdb..#ShinkLogDb') IS NOT NULL
	BEGIN
		DROP TABLE #ShinkLogDb
	END

	CREATE TABLE #ShinkLogDb
	(
		DbName VARCHAR(155) null, exec_query_in_secondary varchar(max) null
	)

	insert into #ShinkLogDb(DbName,exec_query_in_secondary) 
	select  ltrim(rtrim(dbName)) as dbName,
	'EXEC msdb.dbo.sp_delete_database_backuphistory database_name = N''[' + @dbName + ']'' ; drop databse [' + + @dbName + ']' as query
	from @LOGSPACE WHERE (dbName = @dbName OR @dbName IS NULL) AND ([LogSpaceUsed%] >= @SpaceUsed OR @SpaceUsed IS NULL) and ([LogSpaceUsed%] >= 70)
	and dbName not in ('model','master','tempdb','msdb') 

	DECLARE firstCursor CURSOR FOR
	select  ltrim(rtrim(dbName)) as dbName from #ShinkLogDb
	OPEN firstCursor
	FETCH NEXT FROM firstCursor INTO @dbName
	WHILE @@FETCH_STATUS = 0
	BEGIN
		 --- remove availability db from AOAG
		 set @query = CONCAT('if EXISTS  (SELECT 1 FROM sys.databases where database_id > 4 and state = 0 and user_access = 0 and  name in (',
		'SELECT AGDatabases.database_name AS Databasename ',
		'FROM sys.dm_hadr_availability_group_states States ',
		'INNER JOIN master.sys.availability_groups Groups ON States.group_id = Groups.group_id ',
		'INNER JOIN sys.availability_databases_cluster AGDatabases ON Groups.group_id = AGDatabases.group_id ',
		'WHERE primary_replica = @@Servername)and name = ''' + @dbName + ''') ',
		'ALTER AVAILABILITY GROUP [' + @Availibility_Group_Name + '] REMOVE DATABASE [' + @dbName + ']')
		 EXECUTE sp_executesql @query

		 --- set db recovery mode is simple
		 SET @query =  'if exists (select 1 FROM sys.databases WHERE name = ''' + @dbName + ''') ALTER DATABASE [' + @dbName + '] SET RECOVERY SIMPLE'
		 EXECUTE sp_executesql @query

		 --- Shrink the mdf file
		 SET @query =  'Use [' + @dbName + '] if exists (select 1 FROM sys.databases WHERE name = ''' + @dbName + ''') DBCC SHRINKFILE ( N''' + @dbName + ''' , 0);'
		 EXECUTE sp_executesql @query

		 -- Shrink the log.ldf file
		--DBCC SHRINKFILE(N'SampleDataBase_log', 0);
		 SET @query =  'Use [' + @dbName + '] if exists (select 1 FROM sys.databases WHERE name = ''' + @dbName + ''') DBCC SHRINKFILE ( N''' + @dbName + '_log'' , 0);'
		 EXECUTE sp_executesql @query

		 --- set recovery mode full and backup full
		 SELECT @path =  @DiskPath + @dbName + '_' + CONVERT(VARCHAR(20),GETDATE(),112) + '_' + REPLACE(CONVERT(VARCHAR(20),GETDATE(),108),':','') + '.bak' 	
		 SET @query =  'Use [' + @dbName + '] if exists (select 1 FROM sys.databases WHERE name = ''' + @dbName + ''') ALTER DATABASE [' + @dbName + '] SET RECOVERY FULL; BACKUP DATABASE [' + @dbName + '] TO DISK = ''' +  @path + ''''
		 EXECUTE sp_executesql @query

		 --- add db to AOAG 

	FETCH NEXT FROM firstCursor INTO @dbName
	END	
	CLOSE firstCursor
	DEALLOCATE firstCursor

	--- copey result of query and run in secondary server
	select * from #ShinkLogDb



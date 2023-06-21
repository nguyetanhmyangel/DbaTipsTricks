DECLARE @path VARCHAR(500),@Dbname VARCHAR(500) ,@time DATETIME,@year VARCHAR(4),@month VARCHAR(2)
,@day VARCHAR(2),@hour VARCHAR(2),@minute VARCHAR(2),@second VARCHAR(2), @query nvarchar(max)

-- 2. Getting the time values
SELECT @time = GETDATE()
SELECT @year = (SELECT CONVERT(VARCHAR(4), DATEPART(yy, @time)))
SELECT @month = (SELECT CONVERT(VARCHAR(2), FORMAT(DATEPART(mm,@time),'00')))
SELECT @day = (SELECT CONVERT(VARCHAR(2), FORMAT(DATEPART(dd,@time),'00')))
SELECT @hour = (SELECT CONVERT(VARCHAR(2), FORMAT(DATEPART(hh,@time),'00')))
SELECT @minute = (SELECT CONVERT(VARCHAR(2), FORMAT(DATEPART(mi,@time),'00')))
SELECT @second = (SELECT CONVERT(VARCHAR(2), FORMAT(DATEPART(ss,@time),'00')))


-- 3. Defining the filename format
set @Dbname  = 'LQ_KNT_RDB'
--SELECT @path =  'H:\Backup\' + @Dbname + '\' + @Dbname +'_' + @year + '_' + @month + '_' + @day + '_' +  @hour +  @minute +  @second + '.bak' 
SELECT @path =  '\\sharedisk\QLSX\Backup\VSPXLApp\' +  @Dbname +'_' + @year + '_' + @month + '_' + @day + '_' +  @hour +  @minute +  @second + '.bak' 

--SELECT @path =  '\\sqlform-node1\Temp\' + @Dbname +'_' + @year + '_' + @month + '_' + @day + '_' +  @hour +  @minute +  @second + '.bak' 
--\\sqlform-node1\Temp
	
SET @query =  'if exists (select 1 FROM sys.databases WHERE name = ''' + @Dbname + ''') ALTER DATABASE [' + @Dbname + '] SET RECOVERY FULL; BACKUP DATABASE [' + @Dbname + '] TO DISK = ''' +  @path + ''''

--select @path as path, @query as query 

---exec (@query)

 EXECUTE sp_executesql @query
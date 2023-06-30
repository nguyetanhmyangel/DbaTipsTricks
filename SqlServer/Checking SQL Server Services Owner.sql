SET NOCOUNT ON

--  Temporary Tables
CREATE TABLE #tmpServices 
(oOutput VARCHAR(1024))

CREATE TABLE #tmpServicesDetail
(oOutput VARCHAR(1024))

CREATE TABLE #tmpServicesFinal
(ServiceName VARCHAR(100),
ServiceOwner VARCHAR(100),
ServiceStartTp VARCHAR(100),
ServiceBinary VARCHAR(150))

-- sc query is used to query the entire service control manager and then filters 
-- by anything with "SQL" in it's name.  /I option ignores Case.
INSERT INTO #tmpServices EXEC xp_cmdshell 'sc query |find /I "sql"|find /I "service_name"'

-- Remove NULL records
DELETE FROM #tmpServices WHERE oOutput IS NULL

-- Cursor variables
DECLARE @curServNm  VARCHAR(100)
DECLARE @cCMD       VARCHAR(100)
DECLARE @cBinary    VARCHAR(150)
DECLARE @cOwner     VARCHAR(100)
DECLARE @cStartTp   VARCHAR(100)

DECLARE cCursor CURSOR FOR
SELECT RTRIM(LTRIM(SUBSTRING(oOutPut,PATINDEX('%:%', oOutPut)+1, LEN(oOutPut)) )) AS ServiceName
FROM #tmpServices

OPEN cCursor
FETCH NEXT FROM cCursor INTO @curServNm

 WHILE @@FETCH_STATUS = 0

  BEGIN

   --  You can use different Options  to query SC.  For Example, use sc queryex to pull PID
   SET @cCMD = 'sc qc "#SERVICENAME#"'
   SET @cCMD = REPLACE(@cCMD, '#SERVICENAME#', @curServNm)
   
    INSERT INTO #tmpServicesDetail EXEC xp_cmdshell @cCMD

    DELETE FROM #tmpServicesDetail WHERE oOutput IS NULL
                           
    --  To extract any other piece of data, you should modify/add variable:  
    -- For Example:  If I use sc queryex to get PID, then I would make the following changes: 
    -- Then You can Insert it into Temp Table
    -- SELECT @cPID = RTRIM(LTRIM(SUBSTRING(oOutPut,PATINDEX('%:%', oOutPut)+1, LEN(oOutPut)) )) 
    -- FROM   #tmpServicesDetail
    -- WHERE  PATINDEX('%PID%', oOutPut) > 0
    
    SELECT @cBinary = RTRIM(LTRIM(SUBSTRING(oOutPut,PATINDEX('%:%', oOutPut)+1, LEN(oOutPut)) )) 
    FROM   #tmpServicesDetail
    WHERE  PATINDEX('%BINARY_PATH_NAME%', oOutPut) > 0
    
    SELECT @cOwner = RTRIM(LTRIM(SUBSTRING(oOutPut,PATINDEX('%:%', oOutPut)+1, LEN(oOutPut)) )) 
    FROM   #tmpServicesDetail
    WHERE  PATINDEX('%SERVICE_START_NAME%:%', oOutPut) > 0
    
    SELECT @cStartTp = RTRIM(LTRIM(SUBSTRING(oOutPut,PATINDEX('%:%', oOutPut)+1, LEN(oOutPut)) )) 
    FROM   #tmpServicesDetail
    WHERE  PATINDEX('%START_TYPE%:%', oOutPut) > 0

    INSERT INTO #tmpServicesFinal (
     ServiceName,
     ServiceOwner,
     ServiceStartTp,
     ServiceBinary)
    VALUES(
     @curServNm,
     @cOwner,
     @cStartTp,
     @cBinary)

FETCH NEXT FROM cCursor INTO @curServNm
END

CLOSE cCursor
DEALLOCATE cCursor

-- Final result set
SELECT * FROM #tmpServicesFinal

-- Clean-up objects
IF OBJECT_ID('TempDB.dbo.#tmpServices') IS NOT NULL
 DROP TABLE #tmpServices

IF OBJECT_ID('TempDB.dbo.#tmpServicesDetail') IS NOT NULL
 DROP TABLE #tmpServicesDetail

IF OBJECT_ID('TempDB.dbo.#tmpServicesFinal') IS NOT NULL
 DROP TABLE #tmpServicesFinal
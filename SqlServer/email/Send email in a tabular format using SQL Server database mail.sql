-- Example 1
-- Here is the sample code.

CREATE TABLE #Temp 
( 
  [Rank]  [int],
  [Player Name]  [varchar](128),
  [Ranking Points] [int],
  [Country]  [varchar](128)
)

INSERT INTO #Temp
SELECT 1,'Rafael Nadal',12390,'Spain'
UNION ALL
SELECT 2,'Roger Federer',7965,'Switzerland'
UNION ALL
SELECT 3,'Novak Djokovic',7880,'Serbia'

DECLARE @xml NVARCHAR(MAX)
DECLARE @body NVARCHAR(MAX)

SET @xml = CAST(( SELECT [Rank] AS 'td','',[Player Name] AS 'td','', [Ranking Points] AS 'td','', Country AS 'td'
FROM #Temp 
ORDER BY Rank 
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))

SET @body ='<html><body><H3>Tennis Rankings Info</H3>
<table border = 1> 
<tr>
<th> Rank </th> <th> Player Name </th> <th> Ranking Points </th> <th> Country </th></tr>'    

SET @body = @body + @xml +'</table></body></html>'

EXEC msdb.dbo.sp_send_dbmail
@profile_name = 'SQL ALERTING', -- replace with your SQL Database Mail Profile 
@body = @body,
@body_format ='HTML',
@recipients = 'bruhaspathy@hotmail.com', -- replace with your email address
@subject = 'E-mail in Tabular Format' ;

DROP TABLE #Temp

-- The HTML output from the above example looks like this:
-- <html>
-- <body>
-- <h3>Tennis Rankings Info</h3>
-- <table border="1">
--  <tr>
--   <th>Rank </th>
--   <th>Player Name </th>
--   <th>Ranking Points </th>
--   <th>Country </th>
--  </tr>
--  <tr>
--   <td>1</td>
--   <td>Rafael Nadal</td>
--   <td>12390</td>
--   <td>Spain</td>
--  </tr>
--  <tr>
--   <td>2</td>
--   <td>Roger Federer</td>
--   <td>7965</td>
--   <td>Switzerland</td>
--  </tr>
--  <tr>
--   <td>3</td>
--   <td>Novak Djokovic</td>
--   <td>7880</td>
--   <td>Serbia</td>
--  </tr>
-- </table>
-- </body>
-- </html>

-- Send HTML Table via SQL Server Database Mail - Example 2
-- As another example, if you want to change this and select FirstName, LastName and EmailAddress from Person.Contact in the AdventureWorks database and order it by LastName, FirstName you would make these changes:

DECLARE @xml NVARCHAR(MAX)
DECLARE @body NVARCHAR(MAX)

SET @xml = CAST(( SELECT [FirstName] AS 'td','',[LastName] AS 'td','', [EmailAddress] AS 'td'
FROM Person.Contact 
ORDER BY LastName, FirstName 
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))


SET @body ='<html><body><H3>Contact Info</H3>
<table border = 1> 
<tr>
<th> First Name </th> <th> Last Name </th> <th> Email </th></tr>'    
 
SET @body = @body + @xml +'</table></body></html>'

EXEC msdb.dbo.sp_send_dbmail
@profile_name = 'SQL ALERTING', -- replace with your SQL Database Mail Profile 
@body = @body,
@body_format ='HTML',
@recipients = 'bruhaspathy@hotmail.com', -- replace with your email address
@subject = 'E-mail in Tabular Format' ;
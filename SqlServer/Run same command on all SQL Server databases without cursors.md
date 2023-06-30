General sp_MSforeachdb Syntax
This is the general syntax, where @command is a variable-length string that contains the query you want to run.

EXEC sp_MSforeachdb @command
The "?" Placeholder
In addition to using a straight command, we will see in the examples below how to use ? placeholder which substitutes the database name which allows us to change the context of which database the command is running in.

Example 1: Query Information From All Databases On A SQL Instance
Here is a simple example of where we query a system table from all databases including the system databases.

--Example 1
--This query will return a listing of all tables in all databases on a SQL instance: 

DECLARE @command varchar(1000) 
SELECT @command = 'USE ? SELECT name FROM sysobjects WHERE xtype = ''U'' ORDER BY name' 
EXEC sp_MSforeachdb @command 
You can alternately omit the process of declaring and setting the @command variable. The T-SQL command below behaves identically to the one above and is condensed to a single line of code:

--This query will return a listing of all tables in all databases on a SQL instance: 
EXEC sp_MSforeachdb 'USE ? SELECT name FROM sysobjects WHERE xtype = ''U'' ORDER BY name' 
Example 2: Execute A DDL Query Against All User Databases On A SQL Instance
In this example we will create stored procedure spNewProcedure1 in all databases except for the databases we exclude in the IF statement.

--Example 2
--This statement creates a stored procedure in each user database that will return a listing of all users in a database, sorted by their modification date 

DECLARE @command varchar(1000) 

SELECT @command = 'IF ''?'' NOT IN(''master'', ''model'', ''msdb'', ''tempdb'') BEGIN USE ? 
   EXEC(''CREATE PROCEDURE spNewProcedure1 AS SELECT name, createdate, updatedate FROM sys.sysusers ORDER BY updatedate DESC'') END' 

EXEC sp_MSforeachdb @command 
As you may notice, there are additional items to take into consideration when limiting the scope of the sp_MSforeachdb stored procedure, particularly when creating or modifying objects. You must also set the code to execute if the IF statement is true by using the T-SQL keywords BEGIN and END.

You should take note that the USE ? statement is contained within the BEGIN...END block. It is important to remember key T-SQL rules and account for them. In this case the rule that when creating a procedure, the CREATE PROCEDURE phrase must be the first line of code to be executed. To accomplish this you can encapsulate the CREATE PROCEDURE code within an explicit EXEC() function.

Example 3: Query File Information From All Databases On A SQL Instance
Throughout the examples provided above you saw the use of the question mark as a placeholder for the database name. To reference the database name as a string to be returned in a query, it needs to be embed between a double set of single quotation marks. To treat it as a reference to the database object simply use it by itself.

It is necessary to set the database for the query to run against, by using the USE ? statement, otherwise the code will execute in the context of the current database, for each database in your SQL instance. If you have 5 databases hosted in the current instance and you were to run the stored procedure code above while in the context of DBx it would execute the T-SQL text of the @command 5 times in DBx.

So in example 3 we get the correct output since we are using USE ? and then we use ''?'' to return the actual database name in the query.

--Example 3
--This query will return a listing of all files in all databases on a SQL instance:

EXEC sp_MSforeachdb 'USE ? SELECT ''?'', SF.filename, SF.size FROM sys.sysfiles SF'

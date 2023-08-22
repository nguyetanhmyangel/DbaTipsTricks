Personally I'm opposed to using loops in SQL and therefor try to avoid them as much as possible. The idea behind this is to perform as little statements as possible. In this case I'd generate a piece of dynamic SQL and execute that.


--- DECLARE @Receipientlist varchar(8000)
--- SET @ReceipientList = STUFF((SELECT ';' + emailaddress FROM Your query here FOR XML PATH('')),1,1,'')


DECLARE @SQL NVARCHAR(MAX);
SELECT @SQL = CAST((
    SELECT [text()] = REPLACE(REPLACE('
        EXEC msdb.dbo.sp_send_dbmail 
            @profile_name=''eMail Profile'',
            @recipients=''{email}'',
            @subject=''Happy Birthday'',
            @body=''Happy BirthDay to {fullname}'',  
            @body_format = ''text'';
    '
    ,'{fullname}',im.FullName)
    ,'{email}',cm.PersonalEmail)
    FROM tblIndividualMst  im
        INNER JOIN tblContactMst cm 
            ON cm.ContactID = im.ContactID
    WHERE im.GroupID = 4673 
        AND im.DateOfBirth = CAST(GETDATE() AS DATE)
    FOR XML PATH('')
) AS NVARCHAR(max));
EXEC sp_executesql @SQL;

Let me explain what I'm doing here:

Declare @SQL and assign result the of the query casted to NVARCHAR(max).

DECLARE @SQL NVARCHAR(MAX);
SELECT @SQL = CAST((
XML engine is used to concat strings which is way faster than using normal contattenation, [text()] makes sure no XML tags will surround the SQL code.

    SELECT [text()] = REPLACE(REPLACE('
This is a template of the SQL code to be generated with placeholders that will be replaced.

        EXEC msdb.dbo.sp_send_dbmail 
            @profile_name=''eMail Profile'',
            @recipients=''{email}'',
            @subject=''Happy Birthday'',
            @body=''Happy BirthDay to {fullname}'',  
            @body_format = ''text'';
    '
Replacing placeholders ,'{fullname}',im.FullName) ,'{email}',cm.PersonalEmail) The query that will define how much iterations are needed.

    FROM tblIndividualMst  im
        INNER JOIN tblContactMst cm 
            ON cm.ContactID = im.ContactID
    WHERE im.GroupID = 4673 
        AND im.DateOfBirth = CAST(GETDATE() AS DATE)
Tell SQL to generate XML for this query but by suppying an empty string and using [text()] we've made sure no tags are actually included in the result.

    FOR XML PATH('')
Cast XML to NVARCHAR(max)

) AS NVARCHAR(max));
And finally execute!

EXEC sp_executesql @SQL;
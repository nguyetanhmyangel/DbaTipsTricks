-- Unsent Emails
-- The Emails which are not sent due to any reason are available in the msdb.dbo.sysmail_unsentitems table.
SELECT * FROM msdb.dbo.sysmail_unsentitems
 
-- Sent Emails
-- The Emails which were sent without any problems are available in the msdb.dbo.sysmail_sentitems table.
SELECT * FROM msdb.dbo.sysmail_sentitems
 
-- Failed Emails
-- The Emails which are failed and were not sent are available in the msdb.dbo.sysmail_faileditems table.
SELECT * FROM msdb.dbo.sysmail_faileditems
 
-- Above table does not store the details of the Error i.e. the Error Message. The details of the Error are present in the msdb.dbo.sysmail_event_log table.
-- The following Query gets list of Failed emails as well as the details of the Error.
SELECT mailitem_id
    ,[subject]
    ,[last_mod_date]
    ,(SELECT TOP 1 [description]
            FROM msdb.dbo.sysmail_event_log
            WHERE mailitem_id = logs.mailitem_id
            ORDER BY log_date DESC) [description]
FROM msdb.dbo.sysmail_faileditems logs
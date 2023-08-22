
sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
 
sp_configure 'Database Mail XPs', 1;
GO
RECONFIGURE
GO

To create a new Database Mail profile named ‘Notifications’ we will use the sysmail_add_profile_sp stored procedure and the following code:

-- Create a Database Mail profile  
EXECUTE msdb.dbo.sysmail_add_profile_sp  
    @profile_name = 'KTAT_Profile',  
    @description = 'Profile used for sending outgoing notifications using Gmail.' ;  
GO

--- Update profile if exist this profile:
EXEC msdb.dbo.sysmail_update_profile_sp
    @profile_name = 'KTAT_Profile',
    @description = 'Profile used for sending outgoing notifications to KTAT app.';

To grant permission for a database user or role to use this Database Mail profile, we will use the sysmail_add_principalprofile_sp stored procedure and the following code:

-- Grant access to the profile to the DBMailUsers role  
EXECUTE msdb.dbo.sysmail_add_principalprofile_sp  
    @profile_name = 'KTAT_Profile',  
    @principal_name = 'public',  
    @is_default = 0 ;
GO

--- Update if exist
EXECUTE msdb.dbo.sysmail_update_principalprofile_sp  
    @profile_name = 'KTAT_Profile',  
    @principal_name = 'public',  
    @is_default = 0 ;
GO

- Create a Database Mail account  
EXECUTE msdb.dbo.sysmail_add_account_sp  
    @account_name = 'KTAT_Account',  
    @description = 'Mail account cho gui email tu dong den CB quan ly an toan cac don vi.',  
    @email_address = 'ktat@vietsov.com.vn',  
    @display_name = 'KTAT VSP',  
	@replyto_address = N'hungdm.rd@vietsov.com.vn',
    @mailserver_name = 'mail.vietsov.com.vn',
	@mailserver_type = N'SMTP',
    @port = 25,
	@use_default_credentials = 0,
    @enable_ssl = 0,
    @username = 'ktat@vietsov.com.vn',
    @password = 'xxxxxxx' ;  
GO

--- Update if exist
EXECUTE msdb.dbo.sysmail_update_account_sp  
    @account_name = 'KTAT_Account',  
    @description = 'Mail account cho gui email tu dong den CB quan ly an toan cac don vi.',  
    @email_address = 'ktat@vietsov.com.vn',  
    @display_name = 'KTAT VSP',  
	@replyto_address = N'hungdm.rd@vietsov.com.vn',
    @mailserver_name = 'mail.vietsov.com.vn',
	@mailserver_type = N'SMTP',
    @port = 25,
	@use_default_credentials = 0,
    @enable_ssl = 0,
    @username = 'ktat@vietsov.com.vn',
    @password = 'xxxxxx' ;  
GO

To add the Database Mail account to the Database Mail profile, we will use the sysmail_add_profileaccount_sp stored procedure and the following code:
-- Add the account to the profile 
EXECUTE msdb.dbo.sysmail_update_profileaccount_sp  
    @profile_name = 'KTAT_Profile',  
    @account_name = 'KTAT_Account',  
    @sequence_number =1 ;  
GO
--- Update if exist
EXECUTE msdb.dbo.sysmail_update_profileaccount_sp  
    @profile_name = 'KTAT_Profile',  
    @account_name = 'KTAT_Account',  
    @sequence_number =1 ;  
GO


If for some reason, execution of the code above returns an error, use the following code to roll back the changes:

EXECUTE msdb.dbo.sysmail_delete_profileaccount_sp @profile_name = 'Notifications'
EXECUTE msdb.dbo.sysmail_delete_principalprofile_sp @profile_name = 'Notifications'
EXECUTE msdb.dbo.sysmail_delete_account_sp @account_name = 'Gmail'
EXECUTE msdb.dbo.sysmail_delete_profile_sp @profile_name = 'Notifications'
If anything goes wrong, executing the stored procedures individually could help in troubleshooting the issue. Just make sure to execute the ‘sysmail_add_profileaccount_sp’ stored procedure after the Database Account, and a Database Profile are created.


--- query to check data
SELECT *FROM msdb.dbo.sysmail_account
SELECT *FROM msdb.dbo.sysmail_configuration
SELECT *FROM msdb.dbo.sysmail_principalprofile
SELECT *FROM msdb.dbo.sysmail_profile
SELECT *FROM msdb.dbo.sysmail_profileaccount
SELECT *FROM msdb.dbo.sysmail_profileaccount

--- https://www.sqlshack.com/configure-database-mail-sql-server/
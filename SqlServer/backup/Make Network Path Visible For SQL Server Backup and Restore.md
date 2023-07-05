1. Create Mapping a Network Drive, ex: Z
2. Enabled xp_cmdshell command in your SQL instance, as it is disabled by default.
    EXEC sp_configure 'show advanced options', 1;
    GO
    RECONFIGURE;
    GO

    EXEC sp_configure 'xp_cmdshell',1
    GO
    RECONFIGURE
    GO
3. Define that share drive for SQL with the xp_cmdshell command as follows:
    EXEC XP_CMDSHELL 'net use Z: \\sharedisk\QLSX\Backup\S3DNIPI'
4. In order to verify the new drive, you can use the below command that will show you all files in that newly mapped drive:
    EXEC XP_CMDSHELL 'Dir Z:'

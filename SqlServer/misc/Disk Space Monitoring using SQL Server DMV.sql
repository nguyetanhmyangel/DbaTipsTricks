SELECT DISTINCT 
volume_mount_point [Disk Mount Point], 
file_system_type [File System Type], 
logical_volume_name as [Logical Drive Name], 
CONVERT(DECIMAL(18,2),total_bytes/1073741824.0) AS [Total Size in GB], ---1GB = 1073741824 bytes
CONVERT(DECIMAL(18,2),available_bytes/1073741824.0) AS [Available Size in GB],  
CAST(CAST(available_bytes AS FLOAT)/ CAST(total_bytes AS FLOAT) AS DECIMAL(18,2)) * 100 AS [Space Free %] 
FROM sys.master_files 
CROSS APPLY sys.dm_os_volume_stats(database_id, file_id)
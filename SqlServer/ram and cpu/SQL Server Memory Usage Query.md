-- SQL memory
   SELECT 
      sqlserver_start_time,
      committed_kb/1024 as SQL_current_Memory_usage_mb ,
      committed_target_kb/1024 as SQL_Max_Memory_target_mb            
   FROM sys.dm_os_sys_info;
   
   --OS memory
   SELECT 
      total_physical_memory_kb/1024 as OS_Total_Memory_mb ,
      available_physical_memory_kb/1024 as OS_Available_Memory_mb  
   FROM sys.dm_os_sys_memory;
For performance reasons, SQL Server doesn’t release memory that it has already allocated. When SQL Server is started, it slowly takes the memory specified under the min_server_memory option, and then continues to grow until it reaches the value specified in the max_server_memory option. (For more information about these settings, see Server memory configuration options in the SQL Server documentation.)

SQL Server memory has two components: the buffer pool and the non-buffer pool (also called memory to leave or MTL). The value of the max_server_memory option determines the size of the SQL Server buffer pool, which consists of the buffer cache, procedure cache, plan cache, buff structures, and other caches.

Starting with SQL Server 2012, min_server_memory and max_server_memory account for all memory allocations for all caches, including SQLGENERAL, SQLBUFFERPOOL, SQLQUERYCOMPILE, SQLQUERYPLAN, SQLQUERYEXEC, SQLOPTIMIZER, and SQLCLR. For a complete list of memory clerks under max_server_memory, see sys.dm_os_memory_clerks in the Microsoft SQL Server documentation.

To check the current max_server_memory value, use the command:


$ sp_configure 'max_server_memory'
We recommend that you cap max_server_memory at a value that doesn’t cause systemwide memory pressure. There’s no universal formula that applies to all environments, but we have provided some guidelines in this section. max_server_memory is a dynamic option, so it can be changed at run time.

As a starting point, you can determine max_server_memory as follows:


max_server_memory = total_RAM – (memory_for_the_OS + MTL)
where:

Memory for the operating system is 1-4 GB.

MTL (memory to leave) includes the stack size, which is 2 MB on 64-bit machines per worker thread and can be calculated as follows: MTL = stack_size * max_worker_threads

Alternatively, you can use:


max_server_memory = total_RAM – (1 GB for the OS + memory_basis_amount_of_RAM_on_the_server)
where the memory basis amount of RAM is determined as follows:

If RAM on the server is between 4 GB and 16 GB, leave 1 GB per 4 GB of RAM. For example, for a server with 16 GB, leave 4 GB.

If RAM on the server is over 16 GB, leave 1 GB per 4 GB of RAM up to 16 GB, and 1 GB per 8 GB of RAM above 16 GB.

For example, if a server has 256 GB of RAM, the calculation will be:

1 GB for the OS

Up to 16 GB RAM: 16/4 = 4 GB

Remaining RAM above 16 GB: (256-16)/8 = 30

Total RAM to leave: 1 + 4 + 30 = 35 GB

max_server_memory: 256 - 35 = 221 GB

After initial configuration, monitor the memory you can free over a typical workload duration to determine if you need to increase or decrease the memory allocated to SQL Server.
SELECT  
   CONNECTIONPROPERTY('net_transport') AS net_transport,
   CONNECTIONPROPERTY('protocol_type') AS protocol_type,
   CONNECTIONPROPERTY('auth_scheme') AS auth_scheme,
   CONNECTIONPROPERTY('local_net_address') AS local_net_address,
   CONNECTIONPROPERTY('local_tcp_port') AS local_tcp_port,
   CONNECTIONPROPERTY('client_net_address') AS client_net_address 


   SELECT SERVERPROPERTY('ComputerNamePhysicalNetBIOS') [Machine Name]
   ,SERVERPROPERTY('InstanceName') AS [Instance Name]
   ,LOCAL_NET_ADDRESS AS [IP Address Of SQL Server]
   ,CLIENT_NET_ADDRESS AS [IP Address Of Client]
 FROM SYS.DM_EXEC_CONNECTIONS 
 WHERE SESSION_ID = @@SPID

 SELECT CONNECTIONPROPERTY('local_net_address') AS [IP Address Of SQL Server]
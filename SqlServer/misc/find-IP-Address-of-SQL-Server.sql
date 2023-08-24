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

DECLARE @IPAdress NVARCHAR(50)=''
SELECT @IPAdress = CASE WHEN dec.client_net_address = '<local machine>'
    THEN (SELECT TOP(1) c.local_net_address FROM
        sys.dm_exec_connections AS c WHERE c.local_net_address IS NOT NULL)
    ELSE dec.client_net_address
    END FROM sys.dm_exec_connections AS dec WHERE dec.session_id = @@SPID;
SELECT @IPAdress
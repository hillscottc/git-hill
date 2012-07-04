/****** Object:  LinkedServer [MP_LINK]    Script Date: 10/17/2011 11:51:59 ******/
EXEC master.dbo.sp_addlinkedserver @server = N'MP', @srvproduct=N'USFSHWSAPP130', @provider=N'SQLNCLI', @datasrc=N'USFSHWSAPP130', @catalog=N'MusicPortal'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'MP_LINK',@useself=N'False',@locallogin=NULL,@rmtuser=N'RDXUser',@rmtpassword='databridge'

GO

EXEC master.dbo.sp_serveroption @server=N'MP_LINK', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'MP_LINK', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'MP_LINK', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'MP_LINK', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'MP_LINK', @optname=N'rpc', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'MP_LINK', @optname=N'rpc out', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'MP_LINK', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'MP_LINK', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'MP_LINK', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'MP_LINK', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'MP_LINK', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'MP_LINK', @optname=N'use remote collation', @optvalue=N'true'
GO



USE [RDxReport]
GO


PRINT N'Synchronizing objects from RDxReport to RDxReport'

SET NUMERIC_ROUNDABORT, IMPLICIT_TRANSACTIONS OFF
SET ANSI_PADDING, ANSI_NULLS, QUOTED_IDENTIFIER, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, XACT_ABORT ON
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

USE [RDxReport];
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
DROP TABLE [MP].[Release];
GO
CREATE TABLE [MP].[Release] (
[ID] bigint IDENTITY(1, 1) NOT NULL,
[UPC] nvarchar(14) NOT NULL,
[AccountID] bigint NOT NULL,
[CompanyID] bigint NOT NULL,
[DivisionID] bigint NOT NULL,
[LabelID] bigint NOT NULL,
[ExclusiveInfo] nvarchar(MAX) NULL,
[ReleaseStatusID] int NULL,
[ChangeCode] varchar(2) NOT NULL DEFAULT ('I'),
[ChangeDatetime] datetime NOT NULL DEFAULT (getdate()))
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY];
GO


CREATE NONCLUSTERED INDEX [ChangeDateTime]
ON [MP].[Release]
([ChangeDatetime])
WITH
(
PAD_INDEX = OFF,
FILLFACTOR = 100,
IGNORE_DUP_KEY = OFF,
STATISTICS_NORECOMPUTE = OFF,
ONLINE = OFF,
ALLOW_ROW_LOCKS = ON,
ALLOW_PAGE_LOCKS = ON
)
ON [PRIMARY];
GO


CREATE CLUSTERED INDEX [Clustered_UPC]
ON [MP].[Release]
([UPC])
WITH
(
PAD_INDEX = OFF,
FILLFACTOR = 100,
IGNORE_DUP_KEY = OFF,
STATISTICS_NORECOMPUTE = OFF,
ONLINE = OFF,
ALLOW_ROW_LOCKS = ON,
ALLOW_PAGE_LOCKS = ON
)
ON [PRIMARY];
GO


USE [RDxReport];
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
DROP TABLE [MP].[ResourceTerritoryRight];
GO
CREATE TABLE [MP].[ResourceTerritoryRight] (
[ID] bigint IDENTITY(1, 1) NOT NULL,
[ISRC] nvarchar(12) NOT NULL,
[Type] nvarchar(5) NOT NULL,
[AdSupportedStreaming] bit NOT NULL,
[VevoPolicy] nvarchar(12) NOT NULL,
[UGCYouTube] nvarchar(12) NOT NULL,
[TerritoryISOCode] nvarchar(3) NOT NULL,
[ChangeCode] varchar(2) NOT NULL DEFAULT ('I'),
[ChangeDatetime] datetime NOT NULL DEFAULT (getdate()))
ON [PRIMARY];
GO


CREATE NONCLUSTERED INDEX [ChangeDateTime]
ON [MP].[ResourceTerritoryRight]
([ChangeDatetime])
WITH
(
PAD_INDEX = OFF,
FILLFACTOR = 100,
IGNORE_DUP_KEY = OFF,
STATISTICS_NORECOMPUTE = OFF,
ONLINE = OFF,
ALLOW_ROW_LOCKS = ON,
ALLOW_PAGE_LOCKS = ON
)
ON [PRIMARY];
GO


CREATE NONCLUSTERED INDEX [ResourceTerritoryRight]
ON [MP].[ResourceTerritoryRight]
([ISRC] , [Type])
WITH
(
PAD_INDEX = OFF,
FILLFACTOR = 100,
IGNORE_DUP_KEY = OFF,
STATISTICS_NORECOMPUTE = OFF,
ONLINE = OFF,
ALLOW_ROW_LOCKS = ON,
ALLOW_PAGE_LOCKS = ON
)
ON [PRIMARY];
GO



USE [RDxReport];
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
DROP TABLE [MP].[Right];
GO
CREATE TABLE [MP].[Right] (
[ID] bigint IDENTITY(1, 1) NOT NULL,
[RightID] smallint NOT NULL,
[Name] nvarchar(255) NOT NULL,
[ChangeCode] varchar(2) NOT NULL DEFAULT ('I'),
[ChangeDatetime] datetime NOT NULL DEFAULT (getdate()))
ON [PRIMARY];
GO


CREATE CLUSTERED INDEX [Clustered_RightID]
ON [MP].[Right]
([RightID])
WITH
(
PAD_INDEX = OFF,
FILLFACTOR = 100,
IGNORE_DUP_KEY = OFF,
STATISTICS_NORECOMPUTE = OFF,
ONLINE = OFF,
ALLOW_ROW_LOCKS = ON,
ALLOW_PAGE_LOCKS = ON
)
ON [PRIMARY];
GO

USE [RDxReport];
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
DROP TABLE [MP].[TrackTerritoryRight] ;
GO
CREATE TABLE [MP].[TrackTerritoryRight] (
[ID] bigint IDENTITY(1, 1) NOT NULL,
[UPC] nvarchar(14) NOT NULL,
[CompanyID] bigint NOT NULL,
[ISRC] nvarchar(12) NOT NULL,
[Type] nvarchar(5) NOT NULL,
[RightID] smallint NOT NULL,
[TerritoryISOCode] nvarchar(3) NOT NULL,
[ChangeCode] varchar(2) NOT NULL DEFAULT ('I'),
[ChangeDatetime] datetime NOT NULL DEFAULT (getdate()))
ON [PRIMARY];
GO


CREATE NONCLUSTERED INDEX [ChangeDateTime]
ON [MP].[TrackTerritoryRight]
([ChangeDatetime])
WITH
(
PAD_INDEX = OFF,
FILLFACTOR = 100,
IGNORE_DUP_KEY = OFF,
STATISTICS_NORECOMPUTE = OFF,
ONLINE = OFF,
ALLOW_ROW_LOCKS = ON,
ALLOW_PAGE_LOCKS = ON
)
ON [PRIMARY];
GO


CREATE NONCLUSTERED INDEX [ISRC]
ON [MP].[TrackTerritoryRight]
([ISRC] , [Type])
WITH
(
PAD_INDEX = OFF,
FILLFACTOR = 100,
IGNORE_DUP_KEY = OFF,
STATISTICS_NORECOMPUTE = OFF,
ONLINE = OFF,
ALLOW_ROW_LOCKS = ON,
ALLOW_PAGE_LOCKS = ON
)
ON [PRIMARY];
GO


CREATE NONCLUSTERED INDEX [TrackTerritoryRight]
ON [MP].[TrackTerritoryRight]
(
 [UPC] , [CompanyID] , [ISRC] , [Type] , [RightID] , [TerritoryISOCode] 
)
WITH
(
PAD_INDEX = OFF,
FILLFACTOR = 100,
IGNORE_DUP_KEY = OFF,
STATISTICS_NORECOMPUTE = OFF,
ONLINE = OFF,
ALLOW_ROW_LOCKS = ON,
ALLOW_PAGE_LOCKS = ON
)
ON [PRIMARY];
GO










-- =============================================
-- Author:		Valentin Kantchev
-- Create date: 05/20/2009
-- Description:	Inserts records in MP.Release
-- Changes:
-- RDx-387: Add company Id to the join. 
-- =============================================
ALTER PROCEDURE [MP].[ReleaseInsert]
AS
BEGIN
	insert into MP.Release
	(UPC, AccountID, CompanyID, 
	 DivisionID, LabelID, ExclusiveInfo,
	 ReleaseStatusId, ChangeCode, ChangeDatetime)
	select 
		l.UPC
		,l.AccountID
		,l.CompanyID
		,l.DivisionID
		,l.LabelID
		,l.ExclusiveInfo
		,l.ReleaseStatusId
		,l.ChangeCode
		,ChangeDatetime = getdate()
		
	from 
		MP.Release t
		right outer join openquery (ETL, ' select * from RDxETL.MP.Release where WorkflowCode = ''B'' ') l 
			on t.UPC = l.UPC and t.CompanyID = l.CompanyID
	where
		(t.UPC is null) and (t.CompanyID is null)
END
GO


GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Valentin Kantchev
-- Create date: 05/20/2009
-- Description:	Updates records in MP.Release
-- Changes:
-- RDx-387: Add company Id to the join. 
-- =============================================
ALTER PROCEDURE [MP].[ReleaseUpdate] 
AS
BEGIN
	update MP.Release
	set
		[UPC] = l.[UPC]
		,[AccountID] = l.[AccountID]
		,[CompanyID] = l.[CompanyID]
		,[DivisionID] = l.[DivisionID]
		,[LabelID] = l.[LabelID]
		,[ExclusiveInfo] = l.[ExclusiveInfo]
		,[ReleaseStatusID] = l.ReleaseStatusId
		,ChangeCode = l.ChangeCode
		,ChangeDatetime = getdate()
	from 
		MP.Release t
		inner join openquery (ETL, ' select * from RDxETL.MP.Release where WorkflowCode = ''B'' ') l  
			on t.UPC = l.UPC and t.CompanyID = l.CompanyID
END
GO


GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Valentin Kantchev
-- Create date: 05/20/2009
-- Description:	Creates a job for processing in ETL.RDxETL.MP.TrackTerritoryRight
-- =============================================
ALTER PROCEDURE [MP].[TrackTerritoryRightCreateJob] @jobSize int
AS
BEGIN
	-- create a job for everything that is unprocessed
	execute(
	'
	update  RDxETL.MP.TrackTerritoryRight
		set WorkflowCode = ''J''
	where  WorkflowCode = ''L'' 
	'
	) at ETL	
	
	declare @realJobSize int		
	select @realJobSize = JobSize from openquery(ETL, ' select JobSize = count(*) from RDxETL.MP.TrackTerritoryRight where WorkflowCode = ''J'' ')

	return @realJobSize;		
END
GO


GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Valentin Kantchev
-- Create date: 05/20/2009
-- Description:	Inserts records in MP.TrackTerritoryRight
-- Changes:
-- RDx-387 CC 09-21-2011  Add Company Id and Type to the join
-- =============================================
ALTER PROCEDURE [MP].[TrackTerritoryRightInsert]
AS
BEGIN
	insert into MP.TrackTerritoryRight
	([UPC],[CompanyID],[ISRC],[Type],
	 [RightID],[TerritoryISOCode],ChangeCode,ChangeDatetime )
	select 
		l.[UPC]
		,l.[CompanyID]
		,l.[ISRC]
		,l.[Type]
		,l.[RightID]
		,l.[TerritoryISOCode]
		,l.ChangeCode
		,ChangeDatetime = getdate()
	from 
		MP.TrackTerritoryRight t
		right outer join openquery (ETL, ' select * from RDxETL.MP.TrackTerritoryRight where WorkflowCode = ''B'' ') l 
			on 
         t.UPC = l.UPC and t.CompanyId = l.CompanyId and 
         t.ISRC = l.ISRC and t.[Type] = l.[Type] and 
         t.RightID = l.RightID and 
         t.TerritoryISOCode = l.TerritoryISOCode 
	where
		(t.TerritoryISOCode is null) and (t.UPC is null) and (t.ISRC is null) and (t.RightID is null)
END
GO


GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Valentin Kantchev
-- Create date: 05/20/2009
-- Description:	Opens a batch of @batchSize for processing in ETL.RDxETL.MP.TrackTerritoryRight
-- =============================================
ALTER PROCEDURE [MP].[TrackTerritoryRightOpenBatch] @batchSize int
AS
BEGIN
	execute(
	'
	update  RDxETL.MP.TrackTerritoryRight
		set WorkflowCode = ''B''
	where 
		WorkflowCode = ''J''
	') at ETL;

	return @@rowcount;
END
GO


GO


SET NOEXEC OFF
GO




USE [RDxReport]
GO

/****** Object:  View [RDx].[MPResourceRight]    Script Date: 10/06/2011 12:07:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [RDx].[MPResourceRight]
AS
SELECT DISTINCT 
      rtr.ISRC, rtr.Type, rtr.AdSupportedStreaming, rtr.VevoPolicy, rtr.UGCYouTube, rtr.TerritoryISOCode, 
      r.AccountID, rtr.ChangeDatetime, rtr.ChangeCode
FROM  MP.ResourceTerritoryRight AS rtr 
      LEFT OUTER JOIN (SELECT DISTINCT ISRC, Type, UPC, CompanyId FROM MP.TrackTerritoryRight) AS ttr ON (rtr.ISRC = ttr.ISRC and rtr.Type = ttr.Type) 
      LEFT OUTER JOIN MP.Release AS r ON (ttr.UPC = r.UPC and ttr.CompanyId = r.CompanyID)

GO



ALTER VIEW [RDx].[MPTrackRight]
AS
SELECT DISTINCT 
  ttr.UPC, ttr.CompanyId, ttr.ISRC, ttr.[Type], r.Name AS Exploitation, ttr.TerritoryISOCode, 
  CASE WHEN ttr.RightID IS NULL THEN CAST(1 AS bit) ELSE CAST(0 AS bit) END AS Restricted, 
  rl.AccountID, r.ChangeDatetime, ttr.ChangeCode, ReleaseStatusId
FROM  MP.[Right] AS r 
	  LEFT OUTER JOIN MP.TrackTerritoryRight AS ttr 
	  ON (r.RightID = ttr.RightID)
      LEFT OUTER JOIN MP.Release AS rl 
	  ON (ttr.UPC = rl.UPC and ttr.CompanyId = rl.CompanyID)

GO
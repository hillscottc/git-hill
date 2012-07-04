USE [RDxETL]
GO


PRINT N'Synchronizing objects from RDxETL to RDxETL'

SET NUMERIC_ROUNDABORT, IMPLICIT_TRANSACTIONS ON
SET ANSI_PADDING, ANSI_NULLS, QUOTED_IDENTIFIER, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, XACT_ABORT ON
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Enrique Almada
-- Create date: 9/20/2011
-- Description:	
-- =============================================
CREATE PROCEDURE [MP].[SyncRelease]
AS
BEGIN
	DECLARE
		@RC					INT,
		@executeSQL			NVARCHAR(2000)	
		
	
	SELECT UPC, AccountId, CompanyId, DivisionId, LabelId, ExclusiveInfo, ReleaseStatusId
	INTO #_LoadRelease 
	FROM OPENQUERY (MP, '
						SELECT 
							r.upc [UPC],
							a.AccountNumber [AccountID],
							c.rmsid [CompanyId],
							l.rmsdivisionid [DivisionId],
							l.rmslabelid [LabelId],
							r.specialinstructions [ExclusiveInfo],
							r.ReleaseStatusId [ReleaseStatusId]
						FROM
							MusicPortal.dbo.Release r
								INNER JOIN MusicPortal.dbo.Label l ON l.id = r.labelid
								INNER JOIN MusicPortal.dbo.Company c ON c.id = l.companyid
								INNER JOIN MusicPortal.dbo.ReleaseRights rr ON r.id = rr.releaseid
								INNER JOIN MusicPortal.dbo.Account a ON a.id = c.accountid
								INNER JOIN MusicPortal.dbo.Track t ON t.id = rr.trackid
								INNER JOIN MusicPortal.dbo.Recording rec ON rec.id = t.recordingid	
								INNER JOIN MusicPortal.dbo.ReleaseTerritory rt ON rt.id = rr.releaseterritoryid
								INNER JOIN MusicPortal.dbo.Territory ter ON ter.id = rt.territoryid
						WHERE
							r.releasestatusid IN (2,3,4,5,6) AND
							--r.rightsmodifiedon >= @startTime AND 
							--(@endTime is NULL OR r.rightsmodifiedon <= @endTime) AND
							rec.isrc <> '''' AND
							t.releaseid = r.id AND
							EXISTS (
									SELECT r1.id
									FROM
										MusicPortal.dbo.ReleaseStatusAudit r1
											INNER JOIN MusicPortal.dbo.ReleaseStatusAudit r2 ON r1.releaseid = r2.releaseid
									WHERE
										r1.releasestatusid = 2 AND
										r2.releasestatusid = 3 AND
										r1.id <> r2.id AND
										r1.timestamp < r2.timestamp AND
										r1.releaseid = r.id
								   )-- release has been submitted and approved previously
					   ')
	
	CREATE TABLE #to_be_synced (UPC NVARCHAR(14), ACCOUNT_ID BIGINT, COMPANY_ID BIGINT, DIVISION_ID BIGINT, LABEL_ID BIGINT, EXCLUSIVE_INFO NVARCHAR(Max), RELEASE_STATUS_ID INT, SOURCE_SYSTEM NVARCHAR(100), SCENARIO NVARCHAR(100));

	-- Check RECORDS that are not in RDxETL
	INSERT #to_be_synced
		SELECT DISTINCT
			L.UPC, L.AccountId, L.CompanyId, L.DivisionId, L.LabelId,
			LTRIM(RTRIM(L.ExclusiveInfo)), L.ReleaseStatusId,
			'MP', 'RECORDS that are not in RDxETL'
		FROM
			#_LoadRelease L
		WHERE
			NOT EXISTS (
						SELECT 1
						FROM MP.Release E
						WHERE
							E.UPC = L.UPC COLLATE DATABASE_DEFAULT  AND
							E.AccountId = L.AccountId AND
							E.CompanyId = L.CompanyId AND
							E.DivisionId = L.DivisionId AND
							E.LabelId = L.LabelId --AND
							--E.ReleaseStatusID = L.ReleaseStatusId
					   )
		ORDER BY 1 DESC
	
	-- Check records that RDx don't correspond to a record in MP
	INSERT #to_be_synced
		SELECT DISTINCT
			E.UPC, E.AccountId, E.CompanyId, E.DivisionId, E.LabelId,
			LTRIM(RTRIM(E.ExclusiveInfo)), E.ReleaseStatusId,
			'MP', 'RECORDS in RDx don''t correspond to a record in Source System'
		FROM
			MP.Release E
		WHERE		
			E.CHANGECODE IN ('U', 'I') AND
			NOT EXISTS (
						SELECT 1
						FROM #_LoadRelease L
						WHERE
							L.UPC COLLATE DATABASE_DEFAULT = E.UPC AND
							L.AccountId = E.AccountId AND
							L.CompanyId = E.CompanyId AND
							L.DivisionId = E.DivisionId AND
							L.LabelId = E.LabelId --AND
							--L.ReleaseStatusId = E.ReleaseStatusID
						)
	
	-- Check records marked deleted in RDx that still exists in CTX
	INSERT #to_be_synced
		SELECT DISTINCT
			E.UPC, E.AccountId, E.CompanyId, E.DivisionId, E.LabelId,
			LTRIM(RTRIM(E.ExclusiveInfo)), E.ReleaseStatusId,
			'MP', 'RECORDS market deleted in RDx that still exists in Source System'
		FROM
			MP.Release E
		WHERE
			E.CHANGECODE IN ('UD', 'ID') AND
			EXISTS (
					SELECT 1
					FROM #_LoadRelease L
					WHERE
						L.UPC COLLATE DATABASE_DEFAULT = E.UPC AND
						L.AccountId = E.AccountId AND
						L.CompanyId = E.CompanyId AND
						L.DivisionId = E.DivisionId AND
						L.LabelId = E.LabelId 
				   )
					
	SELECT TOP 5000 * FROM #to_be_synced ORDER BY SCENARIO, UPC
					   
	-- Drop temporal tables
	DROP TABLE #to_be_synced
	DROP TABLE #_LoadRelease
END
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Enrique Almada
-- Create date: 9/20/2011
-- Description:	
-- =============================================
CREATE PROCEDURE [MP].[SyncResourceTerritoryRight]
AS
BEGIN
	DECLARE
		@RC					INT,
		@executeSQL			NVARCHAR(2000)
	
	SELECT ISRC, Type, AdSupportedStreaming, VevoPolicy, UGCYouTube, TerritoryISOCode
	INTO #ResourceRights 
	FROM
		OPENQUERY (MP, '
						SELECT
							rec.isrc [ISRC],
							rtp.Name [Type],
							rsr.AdSupportedStreaming [AdSupportedStreaming],
							ISNULL(rsr.VevoPolicy, '''') [VevoPolicy],
							ISNULL(rsr.UGCYouTube, '''') [UGCYouTube],
							ISNULL(ter.countrycode, '''') [TerritoryISOCode]
						FROM 
							MusicPortal.dbo.Release r
								INNER JOIN MusicPortal.dbo.Label l ON l.id = r.labelid
								INNER JOIN MusicPortal.dbo.Track t ON t.releaseid = r.id
								INNER JOIN MusicPortal.dbo.Recording rec ON rec.id = t.recordingid
								INNER JOIN MusicPortal.dbo.Company c ON c.id = rec.companyid
								INNER JOIN MusicPortal.dbo.Account a ON a.id = c.accountid
								INNER JOIN MusicPortal.dbo.ResourceRights rsr ON rsr.resourceid = rec.id
								INNER JOIN MusicPortal.dbo.Territory ter ON ter.id = rsr.territoryid
								INNER JOIN MusicPortal.dbo.RecordingType rtp ON rec.RecordingTypeId = rtp.Id
						WHERE
							r.releasestatusid IN (2,3,4,5,6) AND
							--r.rightsmodifiedon >= @startTime AND 
							--(@endTime IS NULL OR r.rightsmodifiedon <= @endTime) AND
							rec.isrc <> '''' AND
							EXISTS (
									SELECT r1.id
									FROM
										MusicPortal.dbo.ReleaseStatusAudit r1
											INNER JOIN MusicPortal.dbo.ReleaseStatusAudit r2 ON r1.releaseid = r2.releaseid
									WHERE 
										r1.releasestatusid = 2 AND
										r2.releasestatusid = 3 AND
										r1.id <> r2.id AND
										r1.timestamp < r2.timestamp AND
										r1.releaseid = r.id
								   )-- release has been submitted and approved previously
						ORDER BY
							rec.isrc,
							ter.countrycode
					   ')
	
	CREATE TABLE #to_be_synced (ISRC NVARCHAR(12), TYPE NVARCHAR(5), AD_SUPPORTED_STREAMING BIT, VEVO_POLICY NVARCHAR(12), UGC_YOUTUBE NVARCHAR(12), TERRITORY_ISO_CODE NVARCHAR(3), SOURCE_SYSTEM NVARCHAR(100), SCENARIO NVARCHAR(100));
	
	-- Check RECORDS that are not in RDxETL
	INSERT #to_be_synced
		SELECT DISTINCT
			L.ISRC, L.TYPE, L.AdSupportedStreaming, L.VevoPolicy, L.UGCYouTube, L.TerritoryISOCode, 'MP', 'RECORDS that are not in RDxETL'
		FROM
			#ResourceRights L
		WHERE
			NOT EXISTS (
						SELECT 1
						FROM MP.ResourceTerritoryRight E
						WHERE
							E.ISRC = L.ISRC AND
							E.TYPE = L.TYPE COLLATE DATABASE_DEFAULT AND
							E.TerritoryISOCode = L.TerritoryISOCode COLLATE DATABASE_DEFAULT
					   )
		ORDER BY 1 DESC
	
	-- Check records that RDx don't correspond to a record in CTX
	INSERT #to_be_synced
		SELECT DISTINCT 
			E.ISRC, E.TYPE, E.AdSupportedStreaming, E.VevoPolicy, E.UGCYouTube, E.TerritoryISOCode, 'MP', 'RECORDS in RDx don''t correspond to a record in Source System'
		FROM
			MP.ResourceTerritoryRight E
		WHERE
			E.CHANGECODE IN ('U', 'I') AND
			NOT EXISTS (
						SELECT 1
						FROM #ResourceRights L
						WHERE
							L.ISRC = E.ISRC AND
							L.TYPE COLLATE DATABASE_DEFAULT = E.TYPE AND
							L.TerritoryISOCode COLLATE DATABASE_DEFAULT = E.TerritoryISOCode 
					   )
	
	-- Check records marked deleted in RDx that still exists in CTX
	INSERT #to_be_synced
		SELECT DISTINCT
			E.ISRC, E.TYPE, E.AdSupportedStreaming, E.VevoPolicy, E.UGCYouTube, E.TerritoryISOCode, 'MP', 'RECORDS market deleted in RDx that still exists in Source System'
		FROM
			MP.ResourceTerritoryRight E
		WHERE
			E.CHANGECODE IN ('UD', 'ID') AND
			EXISTS (
					SELECT 1
					FROM #ResourceRights L
					WHERE
						L.ISRC = E.ISRC AND
						L.TYPE COLLATE DATABASE_DEFAULT = E.TYPE AND
						L.TerritoryISOCode COLLATE DATABASE_DEFAULT = E.TerritoryISOCode 
				   )
	
	SELECT TOP 5000 * FROM #to_be_synced ORDER BY SCENARIO, ISRC, TYPE, TERRITORY_ISO_CODE
					   
	-- Drop temporal tables
	DROP TABLE #to_be_synced
	DROP TABLE #ResourceRights
END
GO


GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Enrique Almada
-- Create date: 9/22/2011
-- Description:	
-- =============================================
CREATE PROCEDURE [MP].[SyncTrackTerritoryRight]
AS
BEGIN
	DECLARE
		@RC					INT,
		@executeSQL			NVARCHAR(2000)
	
	SELECT
		t.AccountId, t.CompanyId, t.DivisionId, t.LabelId, t.UPC, t.ExclusiveInfo, t.ISRC, t.TerritoryISOCode,
		t.ReleaseStatusID, t.Type, t.AlbumOnly, t.Download, t.Streamable, t.ConditionalDownload, t.MakeOwnRingtone,
		t.PreOrder, t.Jukebox, t.Kiosk
	INTO #ReleaseRights
	FROM
		OPENQUERY (MP, '
						SELECT 
							a.AccountNumber [AccountId],
							c.rmsid [CompanyId],
							l.rmsdivisionid [DivisionId],
							l.rmslabelid [LabelId],
							r.upc [UPC],
							r.specialinstructions [ExclusiveInfo],
							rec.isrc [ISRC],
							ter.countrycode [TerritoryISOCode],
							r.ReleaseStatusID [ReleaseStatusID],
							rtp.Name [Type],
							rr.AlbumOnly,
							rr.Download,
							rr.Streamable,
							rr.ConditionalDownload,
							rr.MakeOwnRingtone,
							rr.PreOrder,
							rr.Jukebox,
							rr.Kiosk
						FROM 
							MusicPortal.dbo.Release r
								INNER JOIN MusicPortal.dbo.Label l ON l.id = r.labelid
								INNER JOIN MusicPortal.dbo.Company c ON c.id = l.companyid
								INNER JOIN MusicPortal.dbo.ReleaseRights rr ON r.id = rr.releaseid
								INNER JOIN MusicPortal.dbo.Account a ON a.id = c.accountid
								INNER JOIN MusicPortal.dbo.Track t ON t.id = rr.trackid
								INNER JOIN MusicPortal.dbo.Recording rec ON rec.id = t.recordingid	
								INNER JOIN MusicPortal.dbo.ReleaseTerritory rt ON rt.id = rr.releaseterritoryid
								INNER JOIN MusicPortal.dbo.Territory ter ON ter.id = rt.territoryid
								INNER JOIN MusicPortal.dbo.RecordingType rtp ON rec.RecordingTypeId = rtp.Id
						WHERE
							r.releasestatusid IN (2,3,4,5,6) AND
							--r.rightsmodifiedon >= @startTime AND 
							--(@endTime is NULL OR r.rightsmodifiedon <= @endTime) AND
							rec.isrc <> '''' AND
							t.releaseid = r.id AND
							EXISTS (
									SELECT r1.id
									FROM
										MusicPortal.dbo.ReleaseStatusAudit r1
											INNER JOIN MusicPortal.dbo.ReleaseStatusAudit r2 on r1.releaseid = r2.releaseid
									WHERE
										r1.releasestatusid = 2 AND
										r2.releasestatusid = 3 AND
										r1.id <> r2.id AND
										r1.timestamp < r2.timestamp AND
										r1.releaseid = r.id
								   )-- release has been submitted and approved previously
					   ') t
	
	/*
	Rights:
		1 - AlbumOnly
		2 - Download
		3 - ConditionalDownload
		4 - Streamable
		5 - Jukebox
		6 - Kiosk
		7 - MakeOwnRingtone
		8 - PreOrder
	*/
	
	SELECT l.UPC, l.CompanyId, l.ISRC, l.Type, r.ID AS RightID, l.TerritoryISOCode
	INTO #TrackTerritoryRight
	FROM
		#ReleaseRights l
		INNER JOIN MP.[Right] r ON (UPPER(r.Name) = UPPER('AlbumOnly') AND l.AlbumOnly = 1)
								OR (UPPER(r.Name) = UPPER('Download') AND l.Download = 1)
								OR (UPPER(r.Name) = UPPER('ConditionalDownload') AND l.ConditionalDownload = 1)
								OR (UPPER(r.Name) = UPPER('Streamable') AND l.Streamable = 1)
								OR (UPPER(r.Name) = UPPER('JukeBox') AND l.JukeBox = 1)
								OR (UPPER(r.Name) = UPPER('Kiosk') AND l.Kiosk = 1)
								OR (UPPER(r.Name) = UPPER('MakeOwnRingtone') AND l.MakeOwnRingtone = 1)
								OR (UPPER(r.Name) = UPPER('Preorder') AND l.PreOrder = 1)
	
	CREATE TABLE #to_be_synced (UPC NVARCHAR(14), COMPANY_ID BIGINT, ISRC NVARCHAR(12), TYPE NVARCHAR(5), RIGHT_ID SMALLINT, TERRITORY_ISO_CODE NVARCHAR(3), SOURCE_SYSTEM NVARCHAR(100), SCENARIO NVARCHAR(100));
	
	-- Check RECORDS that are not in RDxETL
	INSERT #to_be_synced
		SELECT DISTINCT
			L.UPC, L.CompanyId, L.ISRC, L.TYPE, L.RightID, L.TerritoryISOCode, 'MP', 'RECORDS that are not in RDxETL'
		FROM
			#TrackTerritoryRight L
		WHERE
			NOT EXISTS (
						SELECT 1
						FROM MP.TrackTerritoryRight E
						WHERE
							E.UPC  = L.UPC COLLATE DATABASE_DEFAULT AND
							E.CompanyID = L.CompanyId AND
							E.ISRC = L.ISRC AND
							E.TYPE  = L.TYPE COLLATE DATABASE_DEFAULT AND
							E.RightID = L.RightId AND
							E.TerritoryISOCode  = L.TerritoryISOCode COLLATE DATABASE_DEFAULT
					   )
		ORDER BY 1 DESC
	
	-- Check records that RDx don't correspond to a record in CTX
	INSERT #to_be_synced
		SELECT DISTINCT
			E.UPC, E.CompanyID, E.ISRC, E.TYPE, E.RightID, E.TerritoryISOCode, 'MP', 'RECORDS in RDx don''t correspond to a record in Source System'
		FROM
			MP.TrackTerritoryRight E
		WHERE
			E.CHANGECODE IN ('UD', 'ID') AND
			NOT EXISTS (
						SELECT 1
						FROM #TrackTerritoryRight L
						WHERE
							L.UPC COLLATE DATABASE_DEFAULT = E.UPC  AND
							L.CompanyID = E.CompanyId AND
							L.ISRC = E.ISRC AND
							L.TYPE COLLATE DATABASE_DEFAULT = E.TYPE  AND
							L.RightID = E.RightId AND
							L.TerritoryISOCode COLLATE DATABASE_DEFAULT = E.TerritoryISOCode 
					   )
	
	-- Check records marked deleted in RDx that still exists in CTX
	INSERT #to_be_synced
		SELECT DISTINCT
			E.UPC, E.CompanyID, E.ISRC, E.TYPE, E.RightID, E.TerritoryISOCode, 'MP', 'RECORDS market deleted in RDx that still exists in Source System'
		FROM
			MP.TrackTerritoryRight E
		WHERE
			E.CHANGECODE IN ('UD', 'ID') AND
			EXISTS (
					SELECT 1
					FROM #TrackTerritoryRight L
					WHERE
						L.UPC COLLATE DATABASE_DEFAULT = E.UPC  AND
						L.CompanyID = E.CompanyId AND
						L.ISRC = E.ISRC AND
						L.TYPE COLLATE DATABASE_DEFAULT = E.TYPE  AND
						L.RightID = E.RightId AND
						L.TerritoryISOCode COLLATE DATABASE_DEFAULT = E.TerritoryISOCode 
				   )
	
	SELECT TOP 5000 * FROM #to_be_synced ORDER BY SCENARIO, UPC, COMPANY_ID, ISRC, TYPE, TERRITORY_ISO_CODE, RIGHT_ID
					   
	-- Drop temporal tables
	DROP TABLE #to_be_synced
	DROP TABLE #TrackTerritoryRight
	DROP TABLE #ReleaseRights
END
GO


GO


GO

SET NOEXEC OFF
GO
USE [RDxETL]
GO

/*Script created by Toad for SQL Server at 11/10/2011 12:26 p.m..
Please back up your database before running this script.*/

PRINT N'Synchronizing objects from RDxETL to RDxETL'

SET NUMERIC_ROUNDABORT, IMPLICIT_TRANSACTIONS OFF
SET ANSI_PADDING, ANSI_NULLS, QUOTED_IDENTIFIER, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, XACT_ABORT ON
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO

BEGIN TRANSACTION
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Valentin Kantchev
-- Create date: 05/20/2009
-- Description:	Inserts records in CTX.LoadDataContractDriver
-- =============================================
ALTER PROCEDURE [CTX].[DataContractLoadDriverLoad] 
AS
BEGIN

	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingJobRows = count(*) from CTX.LoadDataContractDriver where [WORKFLOW_CODE] = 'L'
	if (@existingJobRows > 0)
		return @existingJobRows;

	declare @rowcount int
	set @rowcount = 0
	
	-- new records
	insert into CTX.LoadDataContractDriver 
	(
		[CONTRACT_ID],
		[WORKFLOW_CODE],
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.[CONTRACT_ID],
		'L',
		case when l.[CHANGE_CODE] = 'C' then 'I' else 'ID' end,
		l.CHANGE_DATE_TIME
	from 
		CTX.LoadDataContract l
		left outer join CTX.DataContract t 
			on l.[CONTRACT_ID] = t.[CONTRACT_ID]
	where 
		(t.[CONTRACT_ID] is null)
		and
		(l.[WORKFLOW_CODE] = 'LT')

	set @rowcount = @rowcount + @@rowcount

	/*
	RDx-360:	AlmadaA
				Verify rows flagged as changes are being set correctly 
				and only when change in source system occurs
	*/
	-- Updates
	insert into CTX.LoadDataContractDriver 
	(
		[CONTRACT_ID],
		[WORKFLOW_CODE],
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.[CONTRACT_ID],
		'L',
		case
			when l.[CHANGE_CODE] = 'C' then 
				CASE
					WHEN t.CHANGE_CODE = 'UD' THEN 'U'
					WHEN (
							ISNULL(t.ORGANIZATION_ID, -99) <> ISNULL(l.ORGANIZATION_ID, -99) OR
							ISNULL(t.TEMPLATE_ID, -99) <> ISNULL(l.TEMPLATE_ID, -99) OR
							ISNULL(t.CONTRACT_DESC, 'null') <> ISNULL(l.CONTRACT_DESC, 'null') OR
							ISNULL(t.CONTRACT_RECORD_TYPE, 'null') <> ISNULL(l.CONTRACT_RECORD_TYPE, 'null') OR
							ISNULL(t.CONTRACT_TYPE, 'null') <> ISNULL(l.CONTRACT_TYPE, 'null') OR
							ISNULL(t.UNIQUE_CONTRACT_NUMBER, 'null') <> ISNULL(l.UNIQUE_CONTRACT_NUMBER, 'null') OR
							ISNULL(t.ARTIST_ID, -99) <> ISNULL(l.ARTIST_ID, -99) OR
							ISNULL(t.ARTIST, 'null') <> ISNULL(l.ARTIST, 'null') OR
							ISNULL(t.CONTRACT_SUMMARY_STATUS, 'null') <> ISNULL(l.CONTRACT_SUMMARY_STATUS, 'null') OR
							ISNULL(t.COMPANY_ID, -99) <> ISNULL(l.COMPANY_ID, -99) OR
							ISNULL(t.COMPANY, 'null') <> ISNULL(l.COMPANY, 'null') OR
							ISNULL(t.CONTRACT_EFFECTIVE_DATE, 'null') <> ISNULL(l.CONTRACT_EFFECTIVE_DATE, 'null') OR
							ISNULL(t.CURRENT_ARTIST, 'null') <> ISNULL(l.CURRENT_ARTIST, 'null') OR
							ISNULL(t.END_OF_TERM_DATE, 'null') <> ISNULL(l.END_OF_TERM_DATE, 'null') OR
							ISNULL(t.HEADER_NOTES, 'null') <> ISNULL(l.HEADER_NOTES, 'null') OR
							ISNULL(t.RIGHTS_PERIOD, 'null') <> ISNULL(l.RIGHTS_PERIOD, 'null') OR
							ISNULL(t.RIGHTS_EXPIRY_DATE, 'null') <> ISNULL(l.RIGHTS_EXPIRY_DATE, 'null') OR
							ISNULL(t.RIGHTS_EXPIRY_RULE, 'null') <> ISNULL(l.RIGHTS_EXPIRY_RULE, 'null') OR
							ISNULL(t.RIGHTS_PERIOD_NOTES, 'null') <> ISNULL(l.RIGHTS_PERIOD_NOTES, 'null') OR
							ISNULL(t.TERRITORIAL_RIGHTS_NOTES, 'null') <> ISNULL(l.TERRITORIAL_RIGHTS_NOTES, 'null')
						) THEN 'U'
					ELSE 'Z'
				END
			else 'UD' 
		end,
		l.CHANGE_DATE_TIME
	from 
		CTX.LoadDataContract l
		inner join CTX.DataContract t 
			on l.[CONTRACT_ID] = t.[CONTRACT_ID] 
	where 
		(l.[WORKFLOW_CODE] = 'LT')		
		
	set @rowcount = @rowcount + @@rowcount		
	
	return @rowcount
END
GO

IF @@ERROR <> 0 OR @@TRANCOUNT = 0 BEGIN IF @@TRANCOUNT > 0 ROLLBACK SET NOEXEC ON END
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Valentin Kantchev
-- Create date: 05/20/2009
-- Description:	Inserts records in CTX.LoadDataExploitationDriver
-- =============================================
ALTER PROCEDURE [CTX].[DataExploitationLoadDriverLoad] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingJobRows = count(*) from CTX.LoadDataExploitationDriver where WORKFLOW_CODE = 'L'
	if (@existingJobRows > 0)
		return @existingJobRows;
		
	declare @timestamp datetime
	set @timestamp = getdate()

	declare @rowcount int
	set @rowcount = 0
	
	-- New Records
	insert into CTX.LoadDataExploitationDriver 
	(
		CONTRACT_ID,
		RESTRICTIONS_CATEGORY,
		RESTRICTIONS_ITEM,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.CONTRACT_ID,
		l.RESTRICTIONS_CATEGORY,
		l.RESTRICTIONS_ITEM,
		'L',
		'I',
		@timestamp 
	from 
		CTX.LoadDataExploitation l
		left outer join CTX.DataExploitation t 
			on t.CONTRACT_ID = l.CONTRACT_ID 
				and t.RESTRICTIONS_CATEGORY = l.RESTRICTIONS_CATEGORY
				and t.RESTRICTIONS_ITEM = l.RESTRICTIONS_ITEM
	where 		
		(t.CONTRACT_ID is null) and (t.RESTRICTIONS_CATEGORY is null) and (t.RESTRICTIONS_ITEM is null)
		and
		l.WORKFLOW_CODE = 'LT'
		
	set @rowcount = @rowcount + @@rowcount

	/*
	RDx-360:	AlmadaA
				Verify rows flagged as changes are being set correctly 
				and only when change in source system occurs
	*/
	-- Updates
	insert into CTX.LoadDataExploitationDriver 
	(
		CONTRACT_ID,
		RESTRICTIONS_CATEGORY,
		RESTRICTIONS_ITEM,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.CONTRACT_ID,
		l.RESTRICTIONS_CATEGORY,
		l.RESTRICTIONS_ITEM,
		'L',
		CASE
			WHEN t.CHANGE_CODE = 'UD' THEN 'U'
			WHEN (
					ISNULL(t.ORGANIZATION_ID, -99) <> ISNULL(l.ORGANIZATION_ID, -99) OR
					ISNULL(t.RIGHT_ACQUIRED, 'null') <> ISNULL(l.RIGHT_ACQUIRED, 'null') OR
					ISNULL(t.TYPE_OF_RESTRICTION, 'null') <> ISNULL(l.TYPE_OF_RESTRICTION, 'null') OR
					ISNULL(t.WHEN_TO_CONSENT_CONSULT, 'null') <> ISNULL(l.WHEN_TO_CONSENT_CONSULT, 'null') OR
					ISNULL(t.PERIOD_OF_RESTRICTION, 'null') <> ISNULL(l.PERIOD_OF_RESTRICTION, 'null') OR
					ISNULL(t.RESTRICTION_END_DATE, 'null') <> ISNULL(l.RESTRICTION_END_DATE, 'null') OR
					ISNULL(t.DOWNLOAD_BY, 'null') <> ISNULL(l.DOWNLOAD_BY, 'null') OR
					ISNULL(t.COMPLETE_PRODUCT_ONLY, 'null') <> ISNULL(l.COMPLETE_PRODUCT_ONLY, 'null') OR
					ISNULL(t.HOLDBACKS, 'null') <> ISNULL(l.HOLDBACKS, 'null') OR
					ISNULL(t.NOTES, 'null') <> ISNULL(l.NOTES, 'null') OR
					ISNULL(t.ON_RESTRICTED_ARTIST_LIST, 'null') <> ISNULL(l.ON_RESTRICTED_ARTIST_LIST, 'null') OR
					ISNULL(t.RESTRICTED_ONLINE_MOBILE_USE, 'null') <> ISNULL(l.RESTRICTED_ONLINE_MOBILE_USE, 'null') OR
					ISNULL(t.RESTRICTED_MOBILE_AUDIO_USE, 'null') <> ISNULL(l.RESTRICTED_MOBILE_AUDIO_USE, 'null') OR
					ISNULL(t.RESTRICTED_MOBILE_VIDEO_USE, 'null') <> ISNULL(l.RESTRICTED_MOBILE_VIDEO_USE, 'null') OR
					ISNULL(t.RESTRICTED_ONLINE_AUDIO_USE, 'null') <> ISNULL(l.RESTRICTED_ONLINE_AUDIO_USE, 'null') OR
					ISNULL(t.RESTRICTED_ONLINE_VIDEO_USE, 'null') <> ISNULL(l.RESTRICTED_ONLINE_VIDEO_USE, 'null')
				) THEN 'U'
			ELSE 'Z'
		END,
		@timestamp 
	from 
		CTX.LoadDataExploitation l
		inner join CTX.DataExploitation t 
			on l.CONTRACT_ID = t.CONTRACT_ID 
				and l.RESTRICTIONS_CATEGORY = t.RESTRICTIONS_CATEGORY
				and l.RESTRICTIONS_ITEM = t.RESTRICTIONS_ITEM
	where
		l.WORKFLOW_CODE = 'LT'	and l.CHANGE_CODE <> 'D'
		
	set @rowcount = @rowcount + @@rowcount						

	-- Deletes
	insert into CTX.LoadDataExploitationDriver 
	(
		CONTRACT_ID,
		RESTRICTIONS_CATEGORY,
		RESTRICTIONS_ITEM,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		t.CONTRACT_ID,
		t.RESTRICTIONS_CATEGORY,
		t.RESTRICTIONS_ITEM,
		'L',
		'UD',
		@timestamp 
	from 
		CTX.LoadDataExploitation l 
		inner join CTX.DataExploitation t
			on (    t.CONTRACT_ID = l.CONTRACT_ID 
				and t.RESTRICTIONS_CATEGORY = l.RESTRICTIONS_CATEGORY
				and t.RESTRICTIONS_ITEM = l.RESTRICTIONS_ITEM)
	 WHERE
			l.WORKFLOW_CODE = 'LT'  AND l.CHANGE_CODE = 'D'
		
		
	set @rowcount = @rowcount + @@rowcount		
	return @rowcount
	
END
GO

IF @@ERROR <> 0 OR @@TRANCOUNT = 0 BEGIN IF @@TRANCOUNT > 0 ROLLBACK SET NOEXEC ON END
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Valentin Kantchev
-- Create date: 05/20/2009
-- Description:	Inserts records in CTX.LoadDataRepertoireDriver
-- =============================================
ALTER PROCEDURE [CTX].[DataRepertoireLoadDriverLoad] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingJobRows = count(*) from CTX.LoadDataRepertoireDriver where WORKFLOW_CODE = 'L'
	if (@existingJobRows > 0)
		return @existingJobRows;
		
	declare @timestamp datetime
	set @timestamp = getdate()

	declare @rowcount int
	set @rowcount = 0
	
	-- New Records
	insert into CTX.LoadDataRepertoireDriver 
	(
		CONTRACT_ID,
		REPERTOIRE_TYPE,
		UNIQUE_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.CONTRACT_ID,
		l.REPERTOIRE_TYPE,
		l.UNIQUE_ID,
		'L',
		'I',
		@timestamp 
	from 
		CTX.LoadDataRepertoire l
		left outer join CTX.DataRepertoire t 
			on t.CONTRACT_ID = l.CONTRACT_ID 
				and t.REPERTOIRE_TYPE = l.REPERTOIRE_TYPE
				and t.UNIQUE_ID = l.UNIQUE_ID
	where 		
		(t.CONTRACT_ID is null) and (t.REPERTOIRE_TYPE is null) and (t.UNIQUE_ID is null)
		and
		l.WORKFLOW_CODE = 'LT'
		
	set @rowcount = @rowcount + @@rowcount

	
	--RDx-360: Removing the Update section for this table since all the main 
	--		   fields are part of the unique key. Otherwise only the change  
	--		   date and the change code will be update cascading changes that 
	--		   are not really changing anything.

	---- Updates
	--insert into CTX.LoadDataRepertoireDriver 
	--(
	--	CONTRACT_ID,
	--	REPERTOIRE_TYPE,
	--	UNIQUE_ID,
	--	WORKFLOW_CODE,
	--	CHANGE_CODE,
	--	CHANGE_DATE_TIME
	--)
	--select 
	--	l.CONTRACT_ID,
	--	l.REPERTOIRE_TYPE,
	--	l.UNIQUE_ID,
	--	'L',
	--	'U',
	--	@timestamp 
	--from 
	--	CTX.LoadDataRepertoire l
	--	inner join CTX.DataRepertoire t 
	--		on l.CONTRACT_ID = t.CONTRACT_ID 
	--			and l.REPERTOIRE_TYPE = t.REPERTOIRE_TYPE
	--			and l.UNIQUE_ID = t.UNIQUE_ID
	--where
	--	l.WORKFLOW_CODE = 'LT'	and l.CHANGE_CODE <> 'D'
		
	--set @rowcount = @rowcount + @@rowcount						

	-- Deletes
	insert into CTX.LoadDataRepertoireDriver 
	(
		CONTRACT_ID,
		REPERTOIRE_TYPE,
		UNIQUE_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		t.CONTRACT_ID,
		t.REPERTOIRE_TYPE,
		t.UNIQUE_ID,
		'L',
		'UD',
		@timestamp 
	FROM 
		
		CTX.LoadDataRepertoire l 
		inner join CTX.DataRepertoire t
			on t.CONTRACT_ID = l.CONTRACT_ID 
				and t.REPERTOIRE_TYPE = l.REPERTOIRE_TYPE
				and t.UNIQUE_ID = l.UNIQUE_ID
	 WHERE
	  l.WORKFLOW_CODE = 'LT'  AND l.CHANGE_CODE = 'D'
		
		
	set @rowcount = @rowcount + @@rowcount		
	return @rowcount
	
END
GO

IF @@ERROR <> 0 OR @@TRANCOUNT = 0 BEGIN IF @@TRANCOUNT > 0 ROLLBACK SET NOEXEC ON END
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Valentin Kantchev
-- Create date: 05/20/2009
-- Description:	Inserts records in CTX.LoadDataTerritoryDriver
-- =============================================
ALTER PROCEDURE [CTX].[DataTerritoryLoadDriverLoad]
AS
BEGIN
 DECLARE @existingJobRows INT
 SET @existingJobRows = 0

 -- see if we have loaded records (i.e. rows with workflow_code = 'L')
 SELECT @existingJobRows = count(*) FROM CTX.LoadDataTerritoryDriver WHERE WORKFLOW_CODE = 'L'
 IF (@existingJobRows > 0)
  RETURN @existingJobRows;

 DECLARE @timestamp DATETIME
 SET @timestamp = getdate()

 DECLARE @rowcount INT
 SET @rowcount = 0

 -- New Records
 INSERT INTO CTX.LoadDataTerritoryDriver
 (
  CONTRACT_ID,
  TERRITORY_TYPE,
  UNIQUE_ID,
  WORKFLOW_CODE,
  CHANGE_CODE,
  CHANGE_DATE_TIME
 )
 SELECT
  l.CONTRACT_ID,
  l.TERRITORY_TYPE,
  l.UNIQUE_ID,
  'L',
  'I',
  @timestamp
 FROM
  CTX.LoadDataTerritory l
  LEFT OUTER JOIN CTX.DataTerritory t
   ON t.CONTRACT_ID = l.CONTRACT_ID
    AND t.TERRITORY_TYPE = l.TERRITORY_TYPE
    AND t.UNIQUE_ID = l.UNIQUE_ID
 WHERE
  (t.CONTRACT_ID IS NULL) AND (t.TERRITORY_TYPE IS NULL) AND (t.UNIQUE_ID IS NULL)
  AND
  l.WORKFLOW_CODE = 'LT' AND l.CHANGE_CODE <> 'D'

 SET @rowcount = @rowcount + @@rowcount

 /*
 RDx-360:	AlmadaA
			Verify rows flagged as changes are being set correctly 
			and only when change in source system occurs
 */
 -- Updates
 INSERT INTO CTX.LoadDataTerritoryDriver
 (
  CONTRACT_ID,
  TERRITORY_TYPE,
  UNIQUE_ID,
  WORKFLOW_CODE,
  CHANGE_CODE,
  CHANGE_DATE_TIME
 )
 SELECT
  l.CONTRACT_ID,
  l.TERRITORY_TYPE,
  l.UNIQUE_ID,
  'L',
  CASE
	WHEN t.CHANGE_CODE = 'UD' THEN 'U'
	WHEN (
			ISNULL(t.PROPERTY_NM, 'null') <> ISNULL(l.PROPERTY_NM, 'null') OR
			ISNULL(t.NAME, 'null') <> ISNULL(l.NAME, 'null')
		 ) THEN 'U'
	ELSE 'Z'
  END,
  @timestamp
 FROM
  CTX.LoadDataTerritory l
  INNER JOIN CTX.DataTerritory t
   ON l.CONTRACT_ID = t.CONTRACT_ID
    AND l.TERRITORY_TYPE = t.TERRITORY_TYPE
    AND l.UNIQUE_ID = t.UNIQUE_ID
 WHERE
	l.WORKFLOW_CODE = 'LT'  AND l.CHANGE_CODE <> 'D'

 SET @rowcount = @rowcount + @@rowcount

 -- Deletes
 INSERT INTO CTX.LoadDataTerritoryDriver
 (
  CONTRACT_ID,
  TERRITORY_TYPE,
  UNIQUE_ID,
  WORKFLOW_CODE,
  CHANGE_CODE,
  CHANGE_DATE_TIME
 )
 SELECT
  t.CONTRACT_ID,
  t.TERRITORY_TYPE,
  t.UNIQUE_ID,
  'L',
  'UD',
  @timestamp
 FROM
  CTX.LoadDataTerritory l
  INNER JOIN CTX.DataTerritory t
   ON l.CONTRACT_ID = t.CONTRACT_ID
    AND l.TERRITORY_TYPE = t.TERRITORY_TYPE
    AND l.UNIQUE_ID = t.UNIQUE_ID
 WHERE
  l.WORKFLOW_CODE = 'LT'  AND l.CHANGE_CODE = 'D'


 SET @rowcount = @rowcount + @@rowcount
 RETURN @rowcount

END
GO

IF @@ERROR <> 0 OR @@TRANCOUNT = 0 BEGIN IF @@TRANCOUNT > 0 ROLLBACK SET NOEXEC ON END
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Valentin Kantchev
-- Create date: 05/20/2009
-- Description:	Inserts records in DRA.LoadEntityClearanceDriver
-- =============================================
ALTER PROCEDURE [DRA].[EntityClearanceLoadDriverLoad] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingJobRows = count(*) from DRA.LoadEntityClearanceDriver where WORKFLOW_CODE = 'L'
	if (@existingJobRows > 0)
		return @existingJobRows;
		
	declare @timestamp datetime
	set @timestamp = getdate()

	declare @rowcount int
	set @rowcount = 0
	
	-- New Records
	insert into DRA.LoadEntityClearanceDriver 
	(
		ENTITY_CLEARANCE_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.ENTITY_CLEARANCE_ID,
		'L',
		'I',
		@timestamp 
	from 
		DRA.LoadEntityClearance l
		left outer join DRA.EntityClearance t 
			on l.ENTITY_CLEARANCE_ID = t.ENTITY_CLEARANCE_ID
	where 		
		(t.ENTITY_CLEARANCE_ID is null)
		and
		l.WORKFLOW_CODE = 'LT'
		
	set @rowcount = @rowcount + @@rowcount

	/*
	RDx-360:	AlmadaA
				Verify rows flagged as changes are being set correctly 
				and only when change in source system occurs
	*/
	-- Updates
	insert into DRA.LoadEntityClearanceDriver 
	(
		ENTITY_CLEARANCE_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.ENTITY_CLEARANCE_ID,
		'L',
		CASE
			WHEN t.CHANGE_CODE = 'UD' THEN 'U'
			WHEN (
					ISNULL(t.ENTITY_CLEARANCE_SET_ID, -99) <> ISNULL(l.ENTITY_CLEARANCE_SET_ID, -99) OR
					ISNULL(t.EXPLOITATION_ID, -99) <> ISNULL(l.EXPLOITATION_ID, -99) OR
					ISNULL(t.CLEARANCE_ID, -99) <> ISNULL(l.CLEARANCE_ID, -99) OR
					ISNULL(t.CLEARANCE_STATE, 'null') <> ISNULL(l.CLEARANCE_STATE, 'null') OR
					ISNULL(t.DISAGGREGATION_FLAG, 'null') <> ISNULL(l.DISAGGREGATION_FLAG, 'null') OR
					ISNULL(t.NOTES, 'null') <> ISNULL(l.NOTES, 'null') OR
					ISNULL(t.REJECTION_NOTES, 'null') <> ISNULL(l.REJECTION_NOTES, 'null')
				) THEN 'U'
			ELSE 'Z'
		END,
		@timestamp 
	from 
		DRA.LoadEntityClearance l
		inner join DRA.EntityClearance t 
			on l.ENTITY_CLEARANCE_ID = t.ENTITY_CLEARANCE_ID
	where
		l.WORKFLOW_CODE = 'LT' and l.CHANGE_CODE <> 'D'
		
	set @rowcount = @rowcount + @@rowcount						

	-- mark as deleted (i.e. set CHANGE_CODE = 'UD') those records that have been deleted from the source table
	insert into DRA.LoadEntityClearanceDriver 
	(
		ENTITY_CLEARANCE_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.ENTITY_CLEARANCE_ID,
		'L',
		'UD',
		l.CHANGE_DATE_TIME 
	from
		DRA.LoadEntityClearance l
	where
		l.CHANGE_CODE = 'D' and l.WORKFLOW_CODE = 'LT'

	set @rowcount = @rowcount + @@rowcount		

	-- mark as deleted (i.e. set CHANGE_CODE = 'UD') those records that have been removed from the clearance set.
	insert into DRA.LoadEntityClearanceDriver 
	(
		ENTITY_CLEARANCE_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		t.ENTITY_CLEARANCE_ID,
		'L',
		'UD',
		@timestamp 
	from 
		(
			-- this gets all records in LoadEntityClearance for ENTITY_CLEARANCE_SET_ID that also exist in EntityClearance
			select distinct t.ENTITY_CLEARANCE_ID
			from 
				DRA.EntityClearance t 
				inner join DRA.LoadEntityClearance l
					on t.ENTITY_CLEARANCE_SET_ID = l.ENTITY_CLEARANCE_SET_ID
			where 
				l.WORKFLOW_CODE = 'LT'					
		)as t
		-- left join to LoadEntityClearance on all fields to see which records are not in LoadEntityClearance
		-- those records will have to be deleted from EntityClearance
		left outer join DRA.LoadEntityClearance l 
			on t.ENTITY_CLEARANCE_ID = l.ENTITY_CLEARANCE_ID
	where
		(l.ENTITY_CLEARANCE_ID is null)
		
	set @rowcount = @rowcount + @@rowcount		
	return @rowcount
	
END
GO

IF @@ERROR <> 0 OR @@TRANCOUNT = 0 BEGIN IF @@TRANCOUNT > 0 ROLLBACK SET NOEXEC ON END
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Valentin Kantchev
-- Create date: 05/20/2009
-- Description:	Inserts records in DRA.LoadEntityClearanceSetDriver
-- =============================================
ALTER PROCEDURE [DRA].[EntityClearanceSetLoadDriverLoad] 
AS
BEGIN

	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingJobRows = count(*) from DRA.LoadEntityClearanceSetDriver where [WORKFLOW_CODE] = 'L'
	if (@existingJobRows > 0)
		return @existingJobRows;

	declare @rowcount int
	set @rowcount = 0
	
-- new records
	insert into DRA.LoadEntityClearanceSetDriver 
	(
		[ENTITY_CLEARANCE_SET_ID],
		[WORKFLOW_CODE],
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.[ENTITY_CLEARANCE_SET_ID],
		'L',
		case when l.[CHANGE_CODE] = 'C' then 'I' else 'ID' end,
		l.CHANGE_DATE_TIME
	from 
		DRA.LoadEntityClearanceSet l
		left outer join DRA.EntityClearanceSet t 
			on l.[ENTITY_CLEARANCE_SET_ID] = t.[ENTITY_CLEARANCE_SET_ID]
	where 
		(t.[ENTITY_CLEARANCE_SET_ID] is null)
		and
		(l.[WORKFLOW_CODE] = 'LT')

	set @rowcount = @rowcount + @@rowcount

	/*
	RDx-360:	AlmadaA
				Verify rows flagged as changes are being set correctly 
				and only when change in source system occurs
	*/
	-- Updates
	insert into DRA.LoadEntityClearanceSetDriver 
	(
		[ENTITY_CLEARANCE_SET_ID],
		[WORKFLOW_CODE],
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.[ENTITY_CLEARANCE_SET_ID],
		'L',
		CASE WHEN l.[CHANGE_CODE] = 'C' THEN
			CASE
				WHEN t.CHANGE_CODE = 'UD' THEN 'U'
				WHEN (
						ISNULL(t.RESOURCE_ID, -99) <> ISNULL(l.RESOURCE_ID, -99) OR
						ISNULL(t.RELEASE_ID, -99) <> ISNULL(l.RELEASE_ID, -99) OR
						ISNULL(t.TERRITORIAL_RIGHTS_NOTES, 'null') <> ISNULL(l.TERRITORIAL_RIGHTS_NOTES, 'null') OR
						ISNULL(t.TERRITORIAL_RIGHTS_NOTES_FLAG, 'null') <> ISNULL(l.TERRITORIAL_RIGHTS_NOTES_FLAG, 'null') OR
						ISNULL(t.COMPANY_ID, -99) <> ISNULL(l.COMPANY_ID, -99)
					 ) then 'U'
				ELSE 'Z'
			END
			ELSE 'UD'
		END,
		l.CHANGE_DATE_TIME
	from 
		DRA.LoadEntityClearanceSet l
		inner join DRA.EntityClearanceSet t 
			on l.[ENTITY_CLEARANCE_SET_ID] = t.[ENTITY_CLEARANCE_SET_ID] 
	where 
		(l.[WORKFLOW_CODE] = 'LT')
		
	set @rowcount = @rowcount + @@rowcount		
	
	-- mark as deleted (i.e. set CHANGE_CODE = 'UD') those records that have been deleted from the source table
	insert into DRA.LoadEntityClearanceSetDriver 
	(
		ENTITY_CLEARANCE_SET_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.ENTITY_CLEARANCE_SET_ID,
		'L',
		'UD',
		l.CHANGE_DATE_TIME 
	from
		DRA.LoadEntityClearanceSet l
	where
		l.CHANGE_CODE = 'D' and l.WORKFLOW_CODE = 'LT'

	set @rowcount = @rowcount + @@rowcount		
	
	return @rowcount
END
GO

IF @@ERROR <> 0 OR @@TRANCOUNT = 0 BEGIN IF @@TRANCOUNT > 0 ROLLBACK SET NOEXEC ON END
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Valentin Kantchev
-- Create date: 05/20/2009
-- Description:	Inserts records in DRA.LoadEntityCountryRightDriver
-- =============================================
ALTER PROCEDURE [DRA].[EntityCountryRightLoadDriverLoad] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingJobRows = count(*) from DRA.LoadEntityCountryRightDriver where WORKFLOW_CODE = 'L'
	if (@existingJobRows > 0)
		return @existingJobRows;
		
	declare @timestamp datetime
	set @timestamp = getdate()

	declare @rowcount int
	set @rowcount = 0
	
	-- New Records
	insert into DRA.LoadEntityCountryRightDriver 
	(
		ENTITY_CLEARANCE_SET_ID,
		COUNTRY_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.ENTITY_CLEARANCE_SET_ID,
		l.COUNTRY_ID,
		'L',
		'I',
		@timestamp 
	from 
		DRA.LoadEntityCountryRight l
		left outer join DRA.EntityCountryRight t 
			on l.ENTITY_CLEARANCE_SET_ID = t.ENTITY_CLEARANCE_SET_ID and l.COUNTRY_ID = t.COUNTRY_ID
	where 		
		(t.ENTITY_CLEARANCE_SET_ID is null) and (t.COUNTRY_ID is null)
		and l.WORKFLOW_CODE = 'LT' and l.CHANGE_CODE <> 'D' 
		
	set @rowcount = @rowcount + @@rowcount

	/*
	RDx-360:	AlmadaA
				Verify rows flagged as changes are being set correctly 
				and only when change in source system occurs
	*/
	-- Updates
	insert into DRA.LoadEntityCountryRightDriver 
	(
		ENTITY_CLEARANCE_SET_ID,
		COUNTRY_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.ENTITY_CLEARANCE_SET_ID,
		l.COUNTRY_ID,		
		'L',
		CASE
			WHEN t.CHANGE_CODE = 'UD' THEN 'U'
			WHEN ISNULL(t.MEMBERSHIP_STATE, 'null') <> ISNULL(l.MEMBERSHIP_STATE, 'null') THEN 'U'
			ELSE 'Z'
		END,
		@timestamp 
	from 
		DRA.LoadEntityCountryRight l
		inner join DRA.EntityCountryRight t 
			on l.ENTITY_CLEARANCE_SET_ID = t.ENTITY_CLEARANCE_SET_ID and l.COUNTRY_ID = t.COUNTRY_ID
	where
		l.WORKFLOW_CODE = 'LT' and l.CHANGE_CODE <> 'D'
		
	set @rowcount = @rowcount + @@rowcount						

	-- mark as deleted (i.e. set CHANGE_CODE = 'UD') those records that have been deleted from the source table
	insert into DRA.LoadEntityCountryRightDriver 
	(
		ENTITY_CLEARANCE_SET_ID,
		COUNTRY_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.ENTITY_CLEARANCE_SET_ID,
		l.COUNTRY_ID,		
		'L',
		'UD',
		@timestamp 
	from
		DRA.LoadEntityCountryRight l
	where
		l.CHANGE_CODE = 'D' and l.WORKFLOW_CODE = 'LT'

	set @rowcount = @rowcount + @@rowcount		


	return @rowcount
END
GO

IF @@ERROR <> 0 OR @@TRANCOUNT = 0 BEGIN IF @@TRANCOUNT > 0 ROLLBACK SET NOEXEC ON END
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Valentin Kantchev
-- Create date: 05/20/2009
-- Description:	Inserts records in DRA.LoadEntityCountryRightMVDriver
-- =============================================
ALTER PROCEDURE [DRA].[EntityCountryRightMVLoadDriverLoad] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingJobRows = count(*) from DRA.LoadEntityCountryRightMVDriver where WORKFLOW_CODE = 'L'
	if (@existingJobRows > 0)
		return @existingJobRows;
		
	declare @timestamp datetime
	set @timestamp = getdate()

	declare @rowcount int
	set @rowcount = 0
	
	-- New Records
	insert into DRA.LoadEntityCountryRightMVDriver 
	(
		ENTITY_CLEARANCE_SET_ID,
		COUNTRY_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.ENTITY_CLEARANCE_SET_ID,
		l.COUNTRY_ID,
		'L',
		'I',
		@timestamp 
	from 
		DRA.LoadEntityCountryRightMV l
		left outer join DRA.EntityCountryRightMV t 
			on l.ENTITY_CLEARANCE_SET_ID = t.ENTITY_CLEARANCE_SET_ID and l.COUNTRY_ID = t.COUNTRY_ID
	where 		
		(t.ENTITY_CLEARANCE_SET_ID is null) and (t.COUNTRY_ID is null)
		and
		l.WORKFLOW_CODE = 'LT' and l.CHANGE_CODE <> 'D' 
		
	set @rowcount = @rowcount + @@rowcount

	
	--RDx-360: Removing the Update section for this table since all the main 
	--		   fields are part of the unique key. Otherwise only the change  
	--		   date and the change code will be update cascading changes that 
	--		   are not really changing anything.
	
	---- Updates
	--insert into DRA.LoadEntityCountryRightMVDriver 
	--(
	--	ENTITY_CLEARANCE_SET_ID,
	--	COUNTRY_ID,
	--	WORKFLOW_CODE,
	--	CHANGE_CODE,
	--	CHANGE_DATE_TIME
	--)
	--select 
	--	l.ENTITY_CLEARANCE_SET_ID,
	--	l.COUNTRY_ID,		
	--	'L',
	--	'U',
	--	@timestamp 
	--from 
	--	DRA.LoadEntityCountryRightMV l
	--	inner join DRA.EntityCountryRightMV t 
	--		on l.ENTITY_CLEARANCE_SET_ID = t.ENTITY_CLEARANCE_SET_ID and l.COUNTRY_ID = t.COUNTRY_ID
	--where
	--	l.WORKFLOW_CODE = 'LT'	 and l.CHANGE_CODE <> 'D' 
		
	--set @rowcount = @rowcount + @@rowcount						

	-- mark as deleted (i.e. set CHANGE_CODE = 'UD') those records that have been deleted from the source table
	insert into DRA.LoadEntityCountryRightMVDriver 
	(
		ENTITY_CLEARANCE_SET_ID,
		COUNTRY_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.ENTITY_CLEARANCE_SET_ID,
		l.COUNTRY_ID,		
		'L',
		'UD',
		@timestamp 
	from
		DRA.LoadEntityCountryRightMV l
	where
		l.CHANGE_CODE = 'D' and l.WORKFLOW_CODE = 'LT'
	
	set @rowcount = @rowcount + @@rowcount		
	return @rowcount
	
END
GO

IF @@ERROR <> 0 OR @@TRANCOUNT = 0 BEGIN IF @@TRANCOUNT > 0 ROLLBACK SET NOEXEC ON END
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Valentin Kantchev
-- Create date: 05/20/2009
-- Description:	Inserts records in DRA.LoadEntityRejectionReasonDriver
-- =============================================
ALTER PROCEDURE [DRA].[EntityRejectionReasonLoadDriverLoad] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingJobRows = count(*) from DRA.LoadEntityRejectionReasonDriver where WORKFLOW_CODE = 'L'
	if (@existingJobRows > 0)
		return @existingJobRows;
		
	declare @timestamp datetime
	set @timestamp = getdate()

	declare @rowcount int
	set @rowcount = 0
	
	-- New Records
	insert into DRA.LoadEntityRejectionReasonDriver 
	(
		ENTITY_CLEARANCE_ID,
		REJECTION_REASON_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.ENTITY_CLEARANCE_ID,
		l.REJECTION_REASON_ID,
		'L',
		'I',
		@timestamp 
	from 
		DRA.LoadEntityRejectionReason l
		left outer join DRA.EntityRejectionReason t 
			on l.ENTITY_CLEARANCE_ID = t.ENTITY_CLEARANCE_ID and l.REJECTION_REASON_ID = t.REJECTION_REASON_ID
	where 		
		(t.ENTITY_CLEARANCE_ID is null) and (t.REJECTION_REASON_ID is null)
		and
		l.WORKFLOW_CODE = 'LT'
		
	set @rowcount = @rowcount + @@rowcount

	--RDx-360: Removing the Update section for this table since all the main 
	--		   fields are part of the unique key. Otherwise only the change  
	--		   date and the change code will be update cascading changes that 
	--		   are not really changing anything.
	---- Updates
	--insert into DRA.LoadEntityRejectionReasonDriver 
	--(
	--	ENTITY_CLEARANCE_ID,
	--	REJECTION_REASON_ID,
	--	WORKFLOW_CODE,
	--	CHANGE_CODE,
	--	CHANGE_DATE_TIME
	--)
	--select 
	--	l.ENTITY_CLEARANCE_ID,
	--	l.REJECTION_REASON_ID,		
	--	'L',
	--	'U',
	--	@timestamp 
	--from 
	--	DRA.LoadEntityRejectionReason l
	--	inner join DRA.EntityRejectionReason t 
	--		on l.ENTITY_CLEARANCE_ID = t.ENTITY_CLEARANCE_ID and l.REJECTION_REASON_ID = t.REJECTION_REASON_ID
	--where
	--	l.CHANGE_CODE <> 'D' AND l.WORKFLOW_CODE = 'LT'	
		
	--set @rowcount = @rowcount + @@rowcount						

	-- mark as deleted (i.e. set CHANGE_CODE = 'UD') those records that have been deleted from the source table
	insert into DRA.LoadEntityRejectionReasonDriver 
	(
		ENTITY_CLEARANCE_ID,
		REJECTION_REASON_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.ENTITY_CLEARANCE_ID,
		l.REJECTION_REASON_ID,		
		'L',
		'UD',
		@timestamp 
	from
		DRA.LoadEntityRejectionReason l
	where
		l.CHANGE_CODE = 'D' and l.WORKFLOW_CODE = 'LT'

	set @rowcount = @rowcount + @@rowcount		

	-- mark as deleted (i.e. set CHANGE_CODE = 'UD') those records that have been removed from the clearance set.
	insert into DRA.LoadEntityRejectionReasonDriver 
	(
		ENTITY_CLEARANCE_ID,
		REJECTION_REASON_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		t.ENTITY_CLEARANCE_ID,
		t.REJECTION_REASON_ID,		
		'L',
		'UD',
		@timestamp 
	from 
		(
			-- this gets all records in LoadEntityRejectionReason for ENTITY_CLEARANCE_ID that also exist in EntityRejectionReason
			select distinct t.ENTITY_CLEARANCE_ID, t.REJECTION_REASON_ID
			from 
				DRA.EntityRejectionReason t 
				inner join DRA.LoadEntityRejectionReason l
					on t.ENTITY_CLEARANCE_ID = l.ENTITY_CLEARANCE_ID
			where 
				l.WORKFLOW_CODE = 'LT'					
		)as t
		-- left join to LoadEntityRejectionReason on all fields to see which records are not in LoadEntityRejectionReason
		-- those records will have to be deleted from EntityRejectionReason
		left outer join DRA.LoadEntityRejectionReason l 
			on t.ENTITY_CLEARANCE_ID = l.ENTITY_CLEARANCE_ID and t.REJECTION_REASON_ID = l.REJECTION_REASON_ID
	where
		(l.ENTITY_CLEARANCE_ID is null) and (l.REJECTION_REASON_ID is null)
		
	set @rowcount = @rowcount + @@rowcount		
	return @rowcount
	
END
GO

IF @@ERROR <> 0 OR @@TRANCOUNT = 0 BEGIN IF @@TRANCOUNT > 0 ROLLBACK SET NOEXEC ON END
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Valentin Kantchev
-- Create date: 05/20/2009
-- Description:	Inserts records in DRA.LoadEntityRightsPeriodDriver
-- =============================================
ALTER PROCEDURE [DRA].[EntityRightsPeriodLoadDriverLoad] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingJobRows = count(*) from DRA.LoadEntityRightsPeriodDriver where WORKFLOW_CODE = 'L'
	if (@existingJobRows > 0)
		return @existingJobRows;
		
	declare @timestamp datetime
	set @timestamp = getdate()

	declare @rowcount int
	set @rowcount = 0
	
	-- New Records
	insert into DRA.LoadEntityRightsPeriodDriver 
	(
		ENTITY_CLEARANCE_SET_ID,
		RIGHTS_PERIOD_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.ENTITY_CLEARANCE_SET_ID,
		l.RIGHTS_PERIOD_ID,
		'L',
		'I',
		@timestamp 
	from 
		DRA.LoadEntityRightsPeriod l
		left outer join DRA.EntityRightsPeriod t 
			on l.ENTITY_CLEARANCE_SET_ID = t.ENTITY_CLEARANCE_SET_ID and l.RIGHTS_PERIOD_ID = t.RIGHTS_PERIOD_ID
	where 		
		(t.ENTITY_CLEARANCE_SET_ID is null) and (t.RIGHTS_PERIOD_ID is null)
		and
		l.WORKFLOW_CODE = 'LT'
		
	set @rowcount = @rowcount + @@rowcount

	/*
	RDx-360:	AlmadaA
				Verify rows flagged as changes are being set correctly 
				and only when change in source system occurs
	*/
	-- Updates
	insert into DRA.LoadEntityRightsPeriodDriver 
	(
		ENTITY_CLEARANCE_SET_ID,
		RIGHTS_PERIOD_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.ENTITY_CLEARANCE_SET_ID,
		l.RIGHTS_PERIOD_ID,
		'L',
		CASE
			WHEN t.CHANGE_CODE = 'UD' THEN 'U'
			WHEN (ISNULL(t.EXPIRY_DATE, getdate()) <> ISNULL(l.EXPIRY_DATE, getdate())) THEN 'U'
			ELSE 'Z'
		END,
		@timestamp 
	from 
		DRA.LoadEntityRightsPeriod l
		inner join DRA.EntityRightsPeriod t 
			on l.ENTITY_CLEARANCE_SET_ID = t.ENTITY_CLEARANCE_SET_ID 
		   and l.RIGHTS_PERIOD_ID = t.RIGHTS_PERIOD_ID
	where
		l.CHANGE_CODE <> 'D' and l.WORKFLOW_CODE = 'LT'
		
	set @rowcount = @rowcount + @@rowcount						

	-- mark as deleted (i.e. set CHANGE_CODE = 'UD') those records that have been deleted from the source table
	insert into DRA.LoadEntityRightsPeriodDriver 
	(
		ENTITY_CLEARANCE_SET_ID,
		RIGHTS_PERIOD_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.ENTITY_CLEARANCE_SET_ID,
		l.RIGHTS_PERIOD_ID,		
		'L',
		'UD',
		@timestamp 
	from
		DRA.LoadEntityRightsPeriod l
	where
		l.CHANGE_CODE = 'D' and l.WORKFLOW_CODE = 'LT'

	set @rowcount = @rowcount + @@rowcount		

	-- mark as deleted (i.e. set CHANGE_CODE = 'UD') those records that have been removed from the clearance set.
	insert into DRA.LoadEntityRightsPeriodDriver 
	(
		ENTITY_CLEARANCE_SET_ID,
		RIGHTS_PERIOD_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		t.ENTITY_CLEARANCE_SET_ID,
		t.RIGHTS_PERIOD_ID,		
		'L',
		'UD',
		@timestamp 
	from 
		(
			-- this gets all records in LoadEntityRightsPeriod for ENTITY_CLEARANCE_SET_ID that also exist in EntityRightsPeriod
			select distinct t.ENTITY_CLEARANCE_SET_ID, t.RIGHTS_PERIOD_ID
			from 
				DRA.EntityRightsPeriod t 
				inner join DRA.LoadEntityRightsPeriod l
					on t.ENTITY_CLEARANCE_SET_ID = l.ENTITY_CLEARANCE_SET_ID
			where 
				l.WORKFLOW_CODE = 'LT'					
		)as t
		-- left join to LoadEntityRightsPeriod on all fields to see which records are not in LoadEntityRightsPeriod
		-- those records will have to be deleted from EntityRightsPeriod
		left outer join DRA.LoadEntityRightsPeriod l 
			on t.ENTITY_CLEARANCE_SET_ID = l.ENTITY_CLEARANCE_SET_ID and t.RIGHTS_PERIOD_ID = l.RIGHTS_PERIOD_ID
	where
		(l.ENTITY_CLEARANCE_SET_ID is null) and (l.RIGHTS_PERIOD_ID is null)
		
	set @rowcount = @rowcount + @@rowcount		
	return @rowcount
	
END
GO

IF @@ERROR <> 0 OR @@TRANCOUNT = 0 BEGIN IF @@TRANCOUNT > 0 ROLLBACK SET NOEXEC ON END
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Valentin Kantchev
-- Create date: 05/20/2009
-- Description:	Inserts records in DRA.LoadEntityTerritoryRightDriver
-- =============================================
ALTER PROCEDURE [DRA].[EntityTerritoryRightLoadDriverLoad] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingJobRows = count(*) from DRA.LoadEntityTerritoryRightDriver where WORKFLOW_CODE = 'L'
	--print @existingJobRows
	if (@existingJobRows > 0)
		return @existingJobRows;
		
	declare @timestamp datetime
	set @timestamp = getdate()

	declare @rowcount int
	set @rowcount = 0
	
	-- New Records
	insert into DRA.LoadEntityTerritoryRightDriver 
	(
		ENTITY_CLEARANCE_SET_ID,
		TERRITORY_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.ENTITY_CLEARANCE_SET_ID,
		l.TERRITORY_ID,
		'L',
		'I',
		@timestamp 
	from 
		DRA.LoadEntityTerritoryRight l
		left outer join DRA.EntityTerritoryRight t 
			on l.ENTITY_CLEARANCE_SET_ID = t.ENTITY_CLEARANCE_SET_ID and l.TERRITORY_ID = t.TERRITORY_ID
	where 		
		(t.ENTITY_CLEARANCE_SET_ID is null) and (t.TERRITORY_ID is null)
		and
		l.WORKFLOW_CODE = 'LT' and l.CHANGE_CODE <> 'D'
		
	set @rowcount = @rowcount + @@rowcount

	/*
	RDx-360:	AlmadaA
				Verify rows flagged as changes are being set correctly 
				and only when change in source system occurs
	*/
	-- Updates
	insert into DRA.LoadEntityTerritoryRightDriver 
	(
		ENTITY_CLEARANCE_SET_ID,
		TERRITORY_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.ENTITY_CLEARANCE_SET_ID,
		l.TERRITORY_ID,		
		'L',
		CASE
			WHEN t.CHANGE_CODE = 'UD' THEN 'U'
			WHEN (ISNULL(t.MEMBERSHIP_STATE, 'null') <> ISNULL(l.MEMBERSHIP_STATE, 'null')) THEN 'U'
			ELSE 'Z'
		END,
		@timestamp 
	from 
		DRA.LoadEntityTerritoryRight l
		inner join DRA.EntityTerritoryRight t 
			on (l.ENTITY_CLEARANCE_SET_ID = t.ENTITY_CLEARANCE_SET_ID 
			and l.TERRITORY_ID = t.TERRITORY_ID)
	where
		l.WORKFLOW_CODE = 'LT' and l.CHANGE_CODE <> 'D'
		
	set @rowcount = @rowcount + @@rowcount						

	-- mark as deleted (i.e. set CHANGE_CODE = 'UD') those records that have been deleted from the source table
	-- select * from DRA.LoadEntityTerritoryRightDriver where ENTITY_CLEARANCE_SET_ID = 1037507
	insert into DRA.LoadEntityTerritoryRightDriver 
	(
		ENTITY_CLEARANCE_SET_ID,
		TERRITORY_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.ENTITY_CLEARANCE_SET_ID,
		l.TERRITORY_ID,		
		'L',
		'UD',
 		@timestamp 
	from
		DRA.LoadEntityTerritoryRight l
	where
		l.CHANGE_CODE = 'D'   and l.WORKFLOW_CODE = 'LT' --Change By JV 9/16
		
	set @rowcount = @rowcount + @@rowcount		
	return @rowcount
	
END
GO

IF @@ERROR <> 0 OR @@TRANCOUNT = 0 BEGIN IF @@TRANCOUNT > 0 ROLLBACK SET NOEXEC ON END
GO

IF @@TRANCOUNT>0 COMMIT TRANSACTION
GO

SET NOEXEC OFF
GO
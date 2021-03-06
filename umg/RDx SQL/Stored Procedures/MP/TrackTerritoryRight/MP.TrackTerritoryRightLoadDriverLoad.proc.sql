﻿-- ============================================
-- Description:	Inserts records in MP.LoadTrackTerritoryRightDriver
-- =============================================
CREATE PROCEDURE [MP].[TrackTerritoryRightLoadDriverLoad] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingJobRows = count(*) from MP.LoadTrackTerritoryRightDriver where WorkflowCode = 'L'
	if (@existingJobRows > 0)
		return @existingJobRows;
		
	declare @timestamp datetime
	set @timestamp = getdate()

	declare @rowcount int
	set @rowcount = 0
	
	-- New Records
	insert into MP.LoadTrackTerritoryRightDriver 
	(
		UPC,
		ISRC,
		RightID,
		TerritoryISOCode,
		WorkflowCode,
		ChangeCode,
		ChangeDatetime
	)
	select 
		l.UPC,
		l.ISRC,
		l.RightID,
		l.TerritoryISOCode,
		'L',
		'I',
		@timestamp 
	from 
		MP.LoadTrackTerritoryRight l
		left outer join MP.TrackTerritoryRight t 
			on l.TerritoryISOCode = t.TerritoryISOCode and l.UPC = t.UPC and l.ISRC = t.ISRC and l.RightID = t.RightID
	where 		
		(t.TerritoryISOCode is null) and (t.UPC is null) and (t.ISRC is null) and (t.RightID is null)
		and
		l.Workflowcode = 'LT'
		
	set @rowcount = @rowcount + @@rowcount

	-- Updates
	insert into MP.LoadTrackTerritoryRightDriver 
	(
		UPC,
		ISRC,
		RightID,
		TerritoryISOCode,
		WorkflowCode,
		ChangeCode,
		ChangeDatetime
	)
	select 
		l.UPC,
		l.ISRC,
		l.RightID,
		l.TerritoryISOCode,
		'L',
		'U',
		@timestamp 
	from 
		MP.LoadTrackTerritoryRight l
		inner join MP.TrackTerritoryRight t 
			on l.TerritoryISOCode = t.TerritoryISOCode and l.UPC = t.UPC and l.ISRC = t.ISRC and l.RightID = t.RightID
	where
		l.Workflowcode = 'LT'	
		
	set @rowcount = @rowcount + @@rowcount						

	-- Deletes
	insert into MP.LoadTrackTerritoryRightDriver 
	(
		UPC,
		ISRC,
		RightID,
		TerritoryISOCode,
		WorkflowCode,
		ChangeCode,
		ChangeDatetime
	)
	select 
		t.UPC,
		t.ISRC,
		t.RightID,
		t.TerritoryISOCode,
		'L',
		'UD',
		@timestamp 
	from 
		(
			-- this gets all records in LoadTrackTerritoryRight for UPC that exist in TrackTerritoryRight
			select distinct t.TerritoryISOCode, t.UPC, t.ISRC, t.RightID
			from 
				MP.TrackTerritoryRight t 
				inner join MP.LoadTrackTerritoryRight l
					on t.UPC = l.UPC
			where 
				l.Workflowcode = 'LT'					
		)as t
		-- left join to LoadTrackTerritoryRight on all fields to see which records are not in LoadTrackTerritoryRight
		-- those records will have to be deleted from TrackTerritoryRight
		left outer join MP.LoadTrackTerritoryRight l 
			on t.TerritoryISOCode = l.TerritoryISOCode and t.UPC = l.UPC and t.ISRC = l.ISRC and t.RightID = l.RightID
	where
		(l.TerritoryISOCode is null) and (l.UPC is null) and (l.ISRC is null) and (l.RightID is null)
		
	set @rowcount = @rowcount + @@rowcount		
	return @rowcount
	
END
GO
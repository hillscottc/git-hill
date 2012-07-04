-- ============================================
-- Description:	Inserts records in MP.TrackTerritoryRight
-- =============================================
CREATE PROCEDURE [MP].[TrackTerritoryRightLoadInsert] 
AS
BEGIN
	insert into MP.TrackTerritoryRight
	select 
		[UPC] = ld.[UPC]
		,[ISRC] = ld.[ISRC]
		,[RightID] = ld.[RightID]
		,[TerritoryISOCode] = ld.[TerritoryISOCode]

		,ChangeCode = ld.ChangeCode
		,ChangeDatetime = getdate()
		,WorkflowCode = 'L'
	from 
		MP.LoadTrackTerritoryRightDriver ld 
	where 
		(ld.ChangeCode = 'I' or ld.ChangeCode = 'ID') and ld.WorkflowCode = 'T'
		
	-- update row counts		
	exec MP.TransformLogTaskInsert 'MP.TrackTerritoryRight', @@rowcount, 'I'
		
END

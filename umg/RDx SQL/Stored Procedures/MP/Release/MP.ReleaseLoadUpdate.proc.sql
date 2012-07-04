-- ============================================
-- Description:	Updates records in MP.Release
-- =============================================
CREATE PROCEDURE MP.ReleaseLoadUpdate
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

		,ChangeCode = ld.ChangeCode
		,ChangeDatetime = getdate()
		,WorkflowCode = 'L'
	from 
		MP.Release t
		inner join MP.LoadRelease l 
			on l.UPC = t.UPC and l.CompanyID = t.CompanyID
		inner join MP.LoadReleaseDriver ld 
			on l.UPC = ld.UPC and l.CompanyID = ld.CompanyID
	where
		(ld.ChangeCode = 'U' or ld.ChangeCode = 'UD') and ld.WorkflowCode = 'T'
		and 
		l.WorkflowCode = 'LT'
		
	-- update row counts		
	exec MP.TransformLogTaskInsert 'MP.Release', @@rowcount, 'U'
		
END

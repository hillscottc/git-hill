-- ============================================
-- Description:	Inserts records in MP.Release
-- =============================================
CREATE PROCEDURE [MP].[ReleaseLoadInsert] 
AS
BEGIN
	insert into MP.Release
	select 
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
		MP.LoadRelease l 
		inner join MP.LoadReleaseDriver ld 
			on l.UPC = ld.UPC and l.CompanyID = ld.CompanyID
	where 
		(ld.ChangeCode = 'I' or ld.ChangeCode = 'ID') and ld.WorkflowCode = 'T'
		and
		l.WorkflowCode = 'LT' 
		
	-- update row counts		
	exec MP.TransformLogTaskInsert 'MP.Release', @@rowcount, 'I'
		
END

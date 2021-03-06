﻿-- ============================================
-- Description:	Reserves all extracted records (E) in MP.LoadRelease for Loading / Transformation (LT).
-- =============================================
CREATE PROCEDURE [MP].[ReleaseLoadJobUpdate] 
AS
BEGIN
	UPDATE MP.LoadRelease
	SET WorkflowCode = 'C' 
	from MP.LoadRelease l 
		inner join MP.LoadReleaseDriver ld 
			on l.UPC = ld.UPC and l.CompanyID = ld.CompanyID
	where 
		l.WorkflowCode = 'LT'
		and
		ld.WorkflowCode = 'T'
END
GO
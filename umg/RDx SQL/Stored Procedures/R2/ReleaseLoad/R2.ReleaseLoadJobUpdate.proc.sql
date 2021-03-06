﻿-- ============================================
-- Description:	Reserves all extracted records (E) in R2.LoadRelease for Loading / Transformation (LT).
-- =============================================
CREATE PROCEDURE [R2].[ReleaseLoadJobUpdate] 
AS
BEGIN
	UPDATE R2.LoadRelease
	SET WORKFLOW_CODE = 'C' 
	from R2.LoadRelease l 
		inner join R2.LoadReleaseDriver ld 
			on l.[RELEASE_ID] = ld.[RELEASE_ID]
	where 
		l.WORKFLOW_CODE = 'LT'
		and
		ld.[WORKFLOW_CODE] = 'T'
END
GO
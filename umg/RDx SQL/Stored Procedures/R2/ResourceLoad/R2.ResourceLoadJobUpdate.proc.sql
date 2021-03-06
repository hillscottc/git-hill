﻿-- ============================================
-- Description:	Reserves all extracted records (E) in R2.LoadResource for Loading / Transformation (LT).
-- =============================================
CREATE PROCEDURE [R2].[ResourceLoadJobUpdate] 
AS
BEGIN
	UPDATE R2.LoadResource
	SET WORKFLOW_CODE = 'C' 
	from R2.LoadResource l 
		inner join R2.LoadResourceDriver ld 
			on l.[Resource_ID] = ld.[Resource_ID]
	where 
		l.WORKFLOW_CODE = 'LT'
		and
		ld.[WORKFLOW_CODE] = 'T'
END
GO
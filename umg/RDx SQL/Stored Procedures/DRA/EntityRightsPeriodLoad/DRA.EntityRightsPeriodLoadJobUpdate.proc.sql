﻿-- ============================================
-- Description:	Reserves all extracted records (E) in DRA.LoadEntityRightsPeriod for Loading / Transformation (LT).
-- =============================================
CREATE PROCEDURE DRA.[EntityRightsPeriodLoadJobUpdate] 
AS
BEGIN
	UPDATE DRA.LoadEntityRightsPeriod
	SET WORKFLOW_CODE = 'C' 
	from DRA.LoadEntityRightsPeriod l 
		inner join DRA.LoadEntityRightsPeriodDriver ld 
			on l.ENTITY_CLEARANCE_SET_ID = ld.ENTITY_CLEARANCE_SET_ID and l.RIGHTS_PERIOD_ID = ld.RIGHTS_PERIOD_ID
	where 
		l.WORKFLOW_CODE = 'LT'
		and
		ld.WORKFLOW_CODE = 'T'
END
GO
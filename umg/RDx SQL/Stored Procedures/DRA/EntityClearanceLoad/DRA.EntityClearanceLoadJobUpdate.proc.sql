﻿-- ============================================
-- Description:	Reserves all extracted records (E) in DRA.LoadEntityClearance for Loading / Transformation (LT).
-- =============================================
CREATE PROCEDURE DRA.[EntityClearanceLoadJobUpdate] 
AS
BEGIN
	UPDATE DRA.LoadEntityClearance
	SET WORKFLOW_CODE = 'C' 
	from DRA.LoadEntityClearance l 
		inner join DRA.LoadEntityClearanceDriver ld 
			on l.ENTITY_CLEARANCE_ID = ld.ENTITY_CLEARANCE_ID
	where 
		l.WORKFLOW_CODE = 'LT'
		and
		ld.WORKFLOW_CODE = 'T'
END
GO
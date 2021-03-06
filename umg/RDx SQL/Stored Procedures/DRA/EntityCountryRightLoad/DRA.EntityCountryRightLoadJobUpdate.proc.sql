﻿-- ============================================
-- Description:	Reserves all extracted records (E) in DRA.LoadEntityCountryRight for Loading / Transformation (LT).
-- =============================================
CREATE PROCEDURE DRA.[EntityCountryRightLoadJobUpdate] 
AS
BEGIN
	UPDATE DRA.LoadEntityCountryRight
	SET WORKFLOW_CODE = 'C' 
	from DRA.LoadEntityCountryRight l 
		inner join DRA.LoadEntityCountryRightDriver ld 
			on l.ENTITY_CLEARANCE_SET_ID = ld.ENTITY_CLEARANCE_SET_ID and l.COUNTRY_ID = ld.COUNTRY_ID
	where 
		l.WORKFLOW_CODE = 'LT'
		and
		ld.WORKFLOW_CODE = 'T'
END
GO
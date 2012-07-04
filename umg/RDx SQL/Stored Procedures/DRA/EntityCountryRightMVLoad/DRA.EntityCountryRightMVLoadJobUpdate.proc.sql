-- ============================================
-- Description:	Reserves all extracted records (E) in DRA.LoadEntityCountryRightMV for Loading / Transformation (LT).
-- =============================================
CREATE PROCEDURE DRA.[EntityCountryRightMVLoadJobUpdate] 
AS
BEGIN
	UPDATE DRA.LoadEntityCountryRightMV
	SET WORKFLOW_CODE = 'C' 
	from DRA.LoadEntityCountryRightMV l 
		inner join DRA.LoadEntityCountryRightMVDriver ld 
			on l.ENTITY_CLEARANCE_SET_ID = ld.ENTITY_CLEARANCE_SET_ID and l.COUNTRY_ID = ld.COUNTRY_ID
	where 
		l.WORKFLOW_CODE = 'LT'
		and
		ld.WORKFLOW_CODE = 'T'
END
GO
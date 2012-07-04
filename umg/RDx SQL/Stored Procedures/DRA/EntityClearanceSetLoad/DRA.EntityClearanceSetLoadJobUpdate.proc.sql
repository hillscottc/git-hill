-- ============================================
-- Description:	Reserves all extracted records (E) in DRA.LoadEntityClearanceSet for Loading / Transformation (LT).
-- =============================================
CREATE PROCEDURE DRA.[EntityClearanceSetLoadJobUpdate] 
AS
BEGIN
	UPDATE DRA.LoadEntityClearanceSet
	SET WORKFLOW_CODE = 'C' 
	from DRA.LoadEntityClearanceSet l 
		inner join DRA.LoadEntityClearanceSetDriver ld 
			on l.[ENTITY_CLEARANCE_SET_ID] = ld.[ENTITY_CLEARANCE_SET_ID]
	where 
		l.WORKFLOW_CODE = 'LT'
		and
		ld.[WORKFLOW_CODE] = 'T'
END
GO
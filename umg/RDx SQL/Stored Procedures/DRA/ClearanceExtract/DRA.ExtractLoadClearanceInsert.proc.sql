-- ============================================
-- Description:	Load records from DRA.CLEARANCE into DRA.LoadClerance
-- =============================================
CREATE PROCEDURE DRA.ExtractLoadClearanceInsert
AS
	insert into DRA.LoadClearance
	select * 
	from openquery 
	(DRA, 
	'
		SELECT 
			C.CLEARANCE_ID, 
			C.NAME, 
			C.ABBREVIATED_NAME, 
			C.SELECTION_TYPE, 
			C.USE_FLAG
		FROM 
			DRA.CLEARANCE C
	');



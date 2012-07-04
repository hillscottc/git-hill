-- ============================================
-- Description:	Load records from DRA.REJECTION_REASON into DRA.LoadRejectionReason
-- =============================================
CREATE PROCEDURE DRA.ExtractLoadRejectionReasonInsert
AS
	insert into DRA.LoadRejectionReason
	select * 
	from openquery 
	(DRA, 
	'
		SELECT 
			R.REJECTION_REASON_ID, 
			R.NAME, 
			R.SEQUENCE_NO
		FROM 
			DRA.REJECTION_REASON R
	');



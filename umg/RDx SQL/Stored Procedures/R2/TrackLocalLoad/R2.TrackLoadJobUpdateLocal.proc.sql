﻿-- ============================================
-- Description:	Reserves all extracted records (E) in R2.LoadTrackLocal for Loading / Transformation (LT).
-- =============================================
CREATE PROCEDURE [R2].[TrackLoadJobUpdateLocal] 
AS
BEGIN
	UPDATE R2.LoadTrackLocal
	SET WORKFLOW_CODE = 'C' 
	from R2.LoadTrackLocal l 
		inner join R2.LoadTrackLocalDriver ld 
			on 
				l.RELEASE_ID = ld.RELEASE_ID and l.RESOURCE_ID = ld.RESOURCE_ID 
				and l.GROUP_SEQUENCE_NO = ld.GROUP_SEQUENCE_NO and l.SEQUENCE_NO = ld.SEQUENCE_NO
				and l.COMPANY_ID = ld.COMPANY_ID 
	where 
		l.WORKFLOW_CODE = 'LT'
		and
		ld.[WORKFLOW_CODE] = 'T'
END
GO
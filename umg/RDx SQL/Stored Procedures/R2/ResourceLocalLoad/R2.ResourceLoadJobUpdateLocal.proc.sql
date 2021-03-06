﻿-- ============================================
-- Description:	Reserves all extracted records (E) in R2.LoadResourceLocal for Loading / Transformation (LT).
-- =============================================
CREATE PROCEDURE [R2].[ResourceLoadJobUpdateLocal] 
AS
BEGIN
	UPDATE R2.LoadResourceLocal
	SET WORKFLOW_CODE = 'C' 
	from R2.LoadResourceLocal l 
		inner join R2.LoadResourceLocalDriver ld 
			on l.[Resource_ID] = ld.[Resource_ID] and l.[COMPANY_ID] = ld.[COMPANY_ID] 
	where 
		l.WORKFLOW_CODE = 'LT'
		and
		ld.[WORKFLOW_CODE] = 'T'
END
GO
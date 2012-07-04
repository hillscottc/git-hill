-- ============================================
-- Description:	Reserves all extracted records (E) in R2.LoadReleaseLocal for Loading / Transformation (LT).
-- =============================================
CREATE PROCEDURE [R2].[ReleaseLoadJobUpdateLocal] 
AS
BEGIN
	UPDATE R2.LoadReleaseLocal
	SET WORKFLOW_CODE = 'C' 
	from R2.LoadReleaseLocal l 
		inner join R2.LoadReleaseLocalDriver ld 
			on l.[RELEASE_ID] = ld.[RELEASE_ID] and l.[COMPANY_ID] = ld.[COMPANY_ID] 
	where 
		l.WORKFLOW_CODE = 'LT'
		and
		ld.[WORKFLOW_CODE] = 'T'
END
GO
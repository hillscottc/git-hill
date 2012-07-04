-- ============================================
-- Description:	Deletes all records from the R2.LoadReleaseDriverLocal table
-- =============================================
CREATE PROCEDURE [R2].[ReleaseLoadLoadReleaseClear]
AS
begin
	truncate table R2.LoadRelease;
end	

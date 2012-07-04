-- ============================================
-- Description:	Deletes all records from the R2.LoadReleasePackageDriver table
-- =============================================
CREATE PROCEDURE [R2].[ReleasePackageClearDriver]
AS
begin
	truncate table R2.LoadReleasePackageDriver;
end	

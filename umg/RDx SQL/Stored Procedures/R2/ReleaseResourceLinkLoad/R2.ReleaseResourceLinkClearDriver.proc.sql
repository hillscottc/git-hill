-- ============================================
-- Description:	Deletes all records from the R2.LoadReleaseResourceLinkDriver table
-- =============================================
CREATE PROCEDURE [R2].[ReleaseResourceLinkClearDriver]
AS
begin
	truncate table R2.LoadReleaseResourceLinkDriver;
end	

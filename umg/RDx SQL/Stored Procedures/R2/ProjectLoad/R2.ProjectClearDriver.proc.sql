-- ============================================
-- Description:	Deletes all records from the R2.LoadProjectDriver table
-- =============================================
CREATE PROCEDURE [R2].[ProjectClearDriver]
AS
begin
	truncate table R2.LoadProjectDriver;
end	

-- ============================================
-- Description:	Deletes all records from the R2.LoadResourceResourceAssocDriver table
-- =============================================
CREATE PROCEDURE [R2].[ResourceResourceAssocClearDriver]
AS
begin
	truncate table R2.LoadResourceResourceAssocDriver;
end	

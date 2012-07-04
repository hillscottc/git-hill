-- ============================================
-- Description:	Deletes all records from the R2.LoadResourceExcerptDriver table
-- =============================================
CREATE PROCEDURE [R2].[ResourceExcerptClearDriver]
AS
begin
	truncate table R2.LoadResourceExcerptDriver;
end	

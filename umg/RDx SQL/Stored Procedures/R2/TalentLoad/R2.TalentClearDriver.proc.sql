-- ============================================
-- Description:	Deletes all records from the R2.LoadTalentDriver table
-- =============================================
CREATE PROCEDURE [R2].[TalentClearDriver]
AS
begin
	truncate table R2.LoadTalentDriver;
end	

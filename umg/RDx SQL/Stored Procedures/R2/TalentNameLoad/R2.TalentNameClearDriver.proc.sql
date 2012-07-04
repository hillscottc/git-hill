-- ============================================
-- Description:	Deletes all records from the R2.LoadTalentNameDriver table
-- =============================================
CREATE PROCEDURE [R2].[TalentNameClearDriver]
AS
begin
	truncate table R2.LoadTalentNameDriver;
end	

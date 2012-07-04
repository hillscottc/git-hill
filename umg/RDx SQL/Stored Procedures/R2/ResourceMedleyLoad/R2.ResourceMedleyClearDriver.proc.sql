-- ============================================
-- Description:	Deletes all records from the R2.LoadResourceMedleyDriver table
-- =============================================
CREATE PROCEDURE [R2].[ResourceMedleyClearDriver]
AS
begin
	truncate table R2.LoadResourceMedleyDriver;
end	

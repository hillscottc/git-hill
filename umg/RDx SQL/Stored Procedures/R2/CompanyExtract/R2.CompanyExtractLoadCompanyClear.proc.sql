-- ============================================
-- Description:	Deletes all records form R2.LoadCompany
-- =============================================
CREATE PROCEDURE R2.CompanyExtractLoadCompanyClear 
AS
	truncate table R2.LoadCompany
GO

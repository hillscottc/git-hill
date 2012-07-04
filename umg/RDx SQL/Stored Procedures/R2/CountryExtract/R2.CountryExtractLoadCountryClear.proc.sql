-- ============================================
-- Description:	Deletes all records form R2.LoadCountry
-- =============================================
CREATE PROCEDURE R2.CountryExtractLoadCountryClear 
AS
	truncate table R2.LoadCountry
GO

-- =============================================
-- Description:	Reserves all extracted records (E) in CPRS.LoadDigitalProductLocal for Loading / Transformation (LT).
-- =============================================
CREATE PROCEDURE [CPRS].[DigitalProductLocalLoadJobUpdate] 
AS
BEGIN
	UPDATE CPRS.LoadDigitalProductLocal
	SET WorkflowCode = 'C' 
	from CPRS.LoadDigitalProductLocal l 
		inner join CPRS.LoadDigitalProductLocalDriver ld 
			on l.ProductID = ld.ProductID and l.CountryISO = ld.CountryISO
	where 
		l.WorkflowCode = 'LT'
		and
		ld.WorkflowCode = 'T'
END
GO
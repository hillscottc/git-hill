-- =============================================
-- Description:	Reserves all extracted records (E) in CPRS.LoadProductTerritoryRight for Loading / Transformation (LT).
-- =============================================
CREATE PROCEDURE [CPRS].[ProductTerritoryRightLoadJobUpdate] 
AS
BEGIN
	UPDATE CPRS.LoadProductTerritoryRight
	SET WorkflowCode = 'C' 
	from CPRS.LoadProductTerritoryRight l 
		inner join CPRS.LoadProductTerritoryRightDriver ld 
			on l.ProductMedium = ld.ProductMedium and l.ProductID = ld.ProductID and l.ISO = ld.ISO
	where 
		l.WorkflowCode = 'LT'
		and
		ld.WorkflowCode = 'T'
END
GO
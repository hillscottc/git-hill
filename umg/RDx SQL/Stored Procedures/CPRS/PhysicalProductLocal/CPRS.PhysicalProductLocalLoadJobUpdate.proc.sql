﻿-- =============================================
-- Description:	Reserves all extracted records (E) in CPRS.LoadPhysicalProductLocal for Loading / Transformation (LT).
-- =============================================
CREATE PROCEDURE [CPRS].[PhysicalProductLocalLoadJobUpdate] 
AS
BEGIN
	UPDATE CPRS.LoadPhysicalProductLocal
	SET WorkflowCode = 'C' 
	from CPRS.LoadPhysicalProductLocal l 
		inner join CPRS.LoadPhysicalProductLocalDriver ld 
			on l.ProductID = ld.ProductID and l.CountryISO = ld.CountryISO
	where 
		l.WorkflowCode = 'LT'
		and
		ld.WorkflowCode = 'T'
END
GO
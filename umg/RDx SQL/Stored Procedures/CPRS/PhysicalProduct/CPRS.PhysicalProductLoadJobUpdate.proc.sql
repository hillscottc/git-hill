﻿-- =============================================
-- Description:	Reserves all extracted records (E) in CPRS.LoadPhysicalProduct for Loading / Transformation (LT).
-- =============================================
CREATE PROCEDURE [CPRS].[PhysicalProductLoadJobUpdate] 
AS
BEGIN
	UPDATE CPRS.LoadPhysicalProduct
	SET WorkflowCode = 'C' 
	from CPRS.LoadPhysicalProduct l 
		inner join CPRS.LoadPhysicalProductDriver ld 
			on l.ProductID = ld.ProductID
	where 
		l.WorkflowCode = 'LT'
		and
		ld.WorkflowCode = 'T'
END
GO
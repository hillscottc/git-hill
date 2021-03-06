﻿-- =============================================
-- Description:	Reserves all extracted records (E) in CPRS.LoadProduct for Loading / Transformation (LT).
-- =============================================
CREATE PROCEDURE [CPRS].[ProductLoadJobUpdate] 
AS
BEGIN
	UPDATE CPRS.LoadProduct
	SET WorkflowCode = 'C' 
	from CPRS.LoadProduct l 
		inner join CPRS.LoadProductDriver ld 
			on l.ProductID = ld.ProductID
	where 
		l.WorkflowCode = 'LT'
		and
		ld.WorkflowCode = 'T'
END
GO
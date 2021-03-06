﻿-- =============================================
-- Description:	Reserves all extracted records (E) in CPRS.LoadDigitalProduct for Loading / Transformation (LT).
-- =============================================
CREATE PROCEDURE [CPRS].[DigitalProductLoadJobUpdate] 
AS
BEGIN
	UPDATE CPRS.LoadDigitalProduct
	SET WorkflowCode = 'C' 
	from CPRS.LoadDigitalProduct l 
		inner join CPRS.LoadDigitalProductDriver ld 
			on l.ProductID = ld.ProductID
	where 
		l.WorkflowCode = 'LT'
		and
		ld.WorkflowCode = 'T'
END
GO
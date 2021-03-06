﻿-- ============================================
-- Description:	Deletes records form R2.Company
-- =============================================
CREATE PROCEDURE R2.CompanyDelete 
AS
BEGIN
	update R2.Company 
	set CHANGE_CODE = 'UD', CHANGE_DATE_TIME = getdate()
	from 
		R2.Company t
		left outer join R2.LoadCompany l on t.company_id = l.company_id
	where
		l.company_id is null
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.LoadCompany', @@rowcount, 'D'
END
GO

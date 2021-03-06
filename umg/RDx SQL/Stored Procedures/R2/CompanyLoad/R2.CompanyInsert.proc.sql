﻿-- ============================================
-- Description:	Inserts records in R2.Company
-- =============================================
CREATE PROCEDURE R2.CompanyInsert 
AS
BEGIN
	insert into R2.Company
	select 
		l.*, 
		CHANGE_CODE = N'I', 
		CHANGE_DATE_TIME = getdate(),
		WORKFLOW_CODE = 'L'
	from 
		R2.Company t
		right outer join R2.LoadCompany l on t.company_id = l.company_id
	where
		t.company_id is null
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.LoadCompany', @@rowcount, 'I'
END
GO
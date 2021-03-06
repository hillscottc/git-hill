﻿-- ============================================
-- Description:	Inserts records in R2.Country
-- =============================================
CREATE PROCEDURE R2.CountryInsert 
AS
BEGIN
	insert into R2.Country
	select 
		l.*, 
		CHANGE_CODE = N'I', 
		CHANGE_DATE_TIME = getdate(),
		WORKFLOW_CODE = 'L'
	from 
		R2.Country t
		right outer join R2.LoadCountry l on t.Country_id = l.Country_id
	where
		t.Country_id is null
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.Country', @@rowcount, 'I'
		
END
GO
﻿-- ============================================
-- Description:	Deletes records form R2.Country
-- =============================================
CREATE PROCEDURE R2.CountryDelete 
AS
BEGIN
	update R2.Country 
	set CHANGE_CODE = 'UD', CHANGE_DATE_TIME = getdate()
	from 
		R2.Country t
		left outer join R2.LoadCountry l on t.Country_id = l.Country_id
	where
		l.Country_id is null
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.Country', @@rowcount, 'D'
		
END
GO

﻿-- ============================================
-- Description:	Updates records in R2.Country
-- =============================================
CREATE PROCEDURE R2.CountryUpdate 
AS
BEGIN
	update R2.Country
	set
		[COUNTRY_ID] = l.COUNTRY_ID,
		[NAME] = l.[NAME],
		[AUDIT_DATE_CHANGED] = l.[AUDIT_DATE_CHANGED],
		[AUDIT_DATE_CREATED] = l.[AUDIT_DATE_CREATED],
		[AUDIT_EMPLOYEE_NO] = l.[AUDIT_EMPLOYEE_NO],
		[STATUS] = l.[STATUS],
		[DATE_LAST_GT] = l.[DATE_LAST_GT],
		[GT_COUNTRY_ID] = l.[GT_COUNTRY_ID],
		[GT_COUNTRY_CODE] = l.[GT_COUNTRY_CODE],
		[UNIQUE_ID] = l.[UNIQUE_ID],

		CHANGE_CODE = N'U', 
		CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		R2.Country t
		inner join R2.LoadCountry l on t.Country_id = l.Country_id
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.Country', @@rowcount, 'U'
		
END
GO
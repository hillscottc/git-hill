﻿-- ============================================
-- Description:	Load records from DRA.RIGHTS_PERIOD into DRA.LoadRightsPeriod
-- =============================================
CREATE PROCEDURE DRA.ExtractLoadRightsPeriodInsert
AS
	insert into DRA.LoadRightsPeriod
	select * 
	from openquery 
	(DRA, 
	'
		SELECT 
			R.RIGHTS_PERIOD_ID, 
			R.DESCRIPTION
		FROM 
			DRA.RIGHTS_PERIOD R
	');



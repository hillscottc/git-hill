﻿-- =============================================
-- Description:	Reserves all extracted records (E) in CTX.LoadDataContract for Loading / Transformation (LT).
-- =============================================
CREATE PROCEDURE [CTX].[DataContractLoadJobUpdate] 
AS
BEGIN
	UPDATE CTX.LoadDataContract
	SET WORKFLOW_CODE = 'C' 
	from CTX.LoadDataContract l 
		inner join CTX.LoadDataContractDriver ld 
			on l.[CONTRACT_ID] = ld.[CONTRACT_ID]
	where 
		l.WORKFLOW_CODE = 'LT'
		and
		ld.[WORKFLOW_CODE] = 'T'
END
GO
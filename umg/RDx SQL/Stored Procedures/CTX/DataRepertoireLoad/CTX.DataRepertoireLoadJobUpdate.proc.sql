-- ============================================
-- Description:	Reserves all extracted records (E) in CTX.LoadDataRepertoire for Loading / Transformation (LT).
-- =============================================
CREATE PROCEDURE CTX.[DataRepertoireLoadJobUpdate] 
AS
BEGIN
	UPDATE CTX.LoadDataRepertoire
	SET WORKFLOW_CODE = 'C' 
	from CTX.LoadDataRepertoire l 
		inner join CTX.LoadDataRepertoireDriver ld 
			on l.CONTRACT_ID = ld.CONTRACT_ID 
				and l.REPERTOIRE_TYPE = ld.REPERTOIRE_TYPE
				and l.UNIQUE_ID = ld.UNIQUE_ID
	where 
		l.WORKFLOW_CODE = 'LT'
		and
		ld.WORKFLOW_CODE = 'T'
END
GO
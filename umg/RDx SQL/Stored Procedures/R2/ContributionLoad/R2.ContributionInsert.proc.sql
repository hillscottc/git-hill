-- ============================================
-- Description:	Inserts records in R2.Contribution
-- =============================================
CREATE PROCEDURE [R2].[ContributionInsert] 
AS
BEGIN
	insert into R2.Contribution
	select 
		l.*, 
		CHANGE_CODE = ld.CHANGE_CODE, 
		CHANGE_DATE_TIME = ld.CHANGE_DATE_TIME,
		WORKFLOW_CODE = 'L'
	from 
		R2.LoadContribution l
		inner join R2.LoadContributionDriver ld 
			on l.CONTRIBUTION_ID = ld.CONTRIBUTION_ID
	where 
		ld.CHANGE_CODE = 'I' and ld.[WORKFLOW_CODE] = 'T'
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.Contribution', @@rowcount, 'I'
		
END

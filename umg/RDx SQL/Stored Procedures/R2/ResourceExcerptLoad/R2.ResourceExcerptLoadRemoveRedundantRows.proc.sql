-- ============================================
-- Description:	Clears duplicate rows from R2.LoadResourceExcerpt. 
-- =============================================
CREATE PROCEDURE [R2].[ResourceExcerptLoadRemoveRedundantRows] 
AS
BEGIN

	-- Clean records with the same RESOURCE_RESOURCE_LINK_ID and different change datetime.
	delete R2.LoadResourceExcerpt
	from 
		R2.LoadResourceExcerpt r
		inner join
		(
			select RESOURCE_RESOURCE_LINK_ID, MAX_CHANGE_DATE_TIME = max(CHANGE_DATE_TIME) 
			from R2.LoadResourceExcerpt 
			where [WORKFLOW_CODE] = 'E'
			group by RESOURCE_RESOURCE_LINK_ID having count(*) > 1
		) as t
		on 
			r.RESOURCE_RESOURCE_LINK_ID = t.RESOURCE_RESOURCE_LINK_ID
		where
			CHANGE_DATE_TIME <> t.MAX_CHANGE_DATE_TIME
			
	-- Clean records with duplicate RELEASE_ID, COMPONENT_RELEASE_ID
	delete R2.LoadResourceExcerpt
	from 
		R2.LoadResourceExcerpt r
		inner join
		(
			select RESOURCE_RESOURCE_LINK_ID, MAX_ID = max(ID) 
			from R2.LoadResourceExcerpt
			where [WORKFLOW_CODE] = 'E'
			group by RESOURCE_RESOURCE_LINK_ID having count(*) > 1
		) as t
		on 
			r.RESOURCE_RESOURCE_LINK_ID = t.RESOURCE_RESOURCE_LINK_ID
		where
			ID <> t.MAX_ID			
			
END
GO
-- selectes the resource_id/company_id of those resources that have been updated, but do not have track updates
CREATE PROCEDURE R2.TrackExtractLoadSourceDriver
AS
begin
	INSERT INTO R2..PARTNER.DRIVER_KEY
	(
		UNIQUE_ID, 
		REPERTOIRE_TYPE,
		LOCAL_DESIGNATION_ID,
		GENERIC_DATE,
		UNIQUE_LOC_ID,
		ACTION_CODE,
		GENERIC_STRING,
		USER_ID,
		ACCOUNT_ID
	)
	SELECT
		r.RESOURCE_ID, 
		'TRACKX',
		r.COMPANY_ID,
		r.CHANGE_DATE_TIME,
		r.RESOURCE_COMPANY_LINK_ID,
		r.CHANGE_CODE,
		'L',
		'RDXUSER',
		0
	FROM 
		R2.LoadResourceLocal r
			left outer join R2.LoadTrackLocal t
				on r.RESOURCE_ID = t.RESOURCE_ID
	where 
		t.RESOURCE_ID is null
		
	return @@rowcount
end;	
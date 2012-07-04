CREATE PROCEDURE R2.ReleaseResourceLinkExtractLoadSourceDriver(@startTime datetime)
AS
begin
	-- style 120 => yyyy-mm-dd hh:mi:ss(24h)
	declare @startTimeString nvarchar(30)
	set @startTimeString  = convert(nvarchar(30), @startTime, 120)

	execute 
	('
		INSERT INTO PARTNER.DRIVER_KEY
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
			T.RELEASE_RESOURCE_LINK_ID, 
			''RELRES'',
			0,
			T.AUDIT_DATE_CHANGED,
			0,
			''C'',
			''L'',
			''RDXUSER'',
			0
		FROM 
			RMS.RELEASE_RESOURCE_LINK T
		WHERE
			T.AUDIT_DATE_CHANGED > to_date (''' + @startTimeString + ''', ''yyyy-mm-dd hh24:mi:ss'')
			
	') at R2	
	
	return @@rowcount
end;	
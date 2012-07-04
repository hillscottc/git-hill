CREATE PROCEDURE R2.ResourceExtractLoadSourceDriver(@startTime datetime)
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
			D.RESOURCE_ID, 
			''RECORD'',
			D.COMPANY_ID,
			D.CHANGE_DATE_TIME,
			D.RESOURCE_COMPANY_LINK_ID,
			D.ACTION_CODE,
			''L'',
			''RDXUSER'',
			0
		FROM 
			IFE.DELTA_RESOURCES D,
			RESOURCE_COMPANY_LINK RCL,
			RESOURCES R
		WHERE
			RCL.RESOURCE_COMPANY_LINK_ID = D.RESOURCE_COMPANY_LINK_ID
			AND RCL.RESOURCE_ID = R.RESOURCE_ID
			AND R.ACCOUNT_ID = ''0''
    
			AND D.CHANGE_DATE_TIME > to_date (''' + @startTimeString + ''', ''yyyy-mm-dd hh24:mi:ss'')
			
	') at R2
	
	return @@rowcount
end;	
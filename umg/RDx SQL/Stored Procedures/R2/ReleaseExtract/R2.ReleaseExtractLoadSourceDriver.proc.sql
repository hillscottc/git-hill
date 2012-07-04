CREATE PROCEDURE R2.ReleaseExtractLoadSourceDriver(@startTime datetime)
AS
begin
	-- keeps the row count
	declare @rowcount int
	set @rowcount = 0

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
			D.RELEASE_ID, 
			''PRODCT'',
			D.COMPANY_ID,
			D.CHANGE_DATE_TIME,
			D.RELEASE_COMPANY_LINK_ID,
			D.ACTION_CODE,
			''L'',
			''RDXUSER'',
			0
		FROM 
			IFE.DELTA_RELEASES D,
			RELEASE_COMPANY_LINK RCL,
			RELEASES R
		WHERE
			RCL.RELEASE_COMPANY_LINK_ID = D.RELEASE_COMPANY_LINK_ID
			AND RCL.RELEASE_ID = R.RELEASE_ID
			AND R.ACCOUNT_ID = ''0''
			AND RCL.STATUS = ''F''

			AND D.CHANGE_DATE_TIME > to_date (''' + @startTimeString + ''', ''yyyy-mm-dd hh24:mi:ss'')
			
	') at R2	
	
	set @rowcount = @rowcount + @@rowcount

	-- Add the UPCs from R2.ExtractTrackDriver to PARTNER.GENERIC_UPCS
	INSERT INTO R2..PARTNER.GENERIC_UPCS
	(
		UPC, 
		INT1,
		TEXT1,
		USER_ID
	)
	SELECT DISTINCT
		UPC = isnull(r.UPC, r.RELEASE_ID),
		INT1 = r.RELEASE_ID,
		TEXT1 = 'PRODCT',
		USER_ID = 'RDXUSER'
	FROM 
		R2.ExtractTrackDriver etd
			inner join R2.Release r
				on etd.RELEASE_ID = r.RELEASE_ID
	where
		etd.WORKFLOW_CODE = 'E'

	-- Add the UPCs of all releases that are not in R2.Release, but are in IFE.RELEASE_DETAIL to PARTNER.GENERIC_UPCS
	INSERT INTO R2..PARTNER.GENERIC_UPCS
	(
		UPC, 
		INT1,
		TEXT1,
		USER_ID
	)
	SELECT
		UPC = isnull(r.UPC, r.RELEASE_ID),
		INT1 = r.RELEASE_ID,
		TEXT1 = 'PRODCT',
		USER_ID = 'RDXUSER'
	from openquery(R2, 
	'
			SELECT DISTINCT
				UPC,
				RELEASE_ID 
			FROM 
				IFE.RELEASE_DETAIL
			WHERE
				STATUS = ''F''
				-- this prevents duplicate records in PARTNER.GENERIC_UPCS			
				AND RELEASE_ID not in (select INT1 from PARTNER.GENERIC_UPCS where TEXT1 = ''PRODCT'' and USER_ID = ''RDXUSER'')
	') r
	where r.RELEASE_ID not in (select RELEASE_ID from R2.Release)
	
	-- then add the releases from PARTNER.GENERIC_UPCS to PARTNER.DRIVER_KEY
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
			RCL.RELEASE_ID, 
			''PRODCT'',
			RCL.COMPANY_ID,
			(select max(CHANGE_DATE_TIME) from IFE.DELTA_RELEASES where RELEASE_COMPANY_LINK_ID = RCL.RELEASE_COMPANY_LINK_ID), 
			RCL.RELEASE_COMPANY_LINK_ID,
			''C'',
			''L'',
			''RDXUSER'',
			0
		FROM 
			PARTNER.GENERIC_UPCS U,
			RELEASE_COMPANY_LINK RCL,
			RELEASES R
		WHERE
			RCL.RELEASE_ID = U.INT1
			AND R.RELEASE_ID = U.INT1 
			AND RCL.STATUS = ''F''
			AND R.ACCOUNT_ID = ''0''
			-- this prevents duplicate records in PARTNER.DRIVER_KEY			
			AND RCL.RELEASE_COMPANY_LINK_ID not in (select UNIQUE_LOC_ID from PARTNER.DRIVER_KEY where REPERTOIRE_TYPE = ''PRODCT'' and USER_ID = ''RDXUSER'')
	') at R2	
	
	set @rowcount = @rowcount + @@rowcount

	-- mark the tracks in ExtractTrackDriver as complete
	update R2.ExtractTrackDriver
	set WORKFLOW_CODE = 'C'
	where WORKFLOW_CODE = 'E'		
		
	return @rowcount
end;	
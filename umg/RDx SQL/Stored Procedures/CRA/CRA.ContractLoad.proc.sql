CREATE PROCEDURE [CRA].[ContractLoad]
	@FileName NVarchar(500),
	@retVal int = -1 OUTPUT 
AS
begin
	DECLARE @DeleteCount integer;
	DECLARE @InsertCount integer;
	SELECT @DeleteCount = COUNT(*) from CRA.CONTRACT;

	TRUNCATE TABLE CRA.CONTRACT;

	INSERT INTO CRA.CONTRACT 
	(CONTRIBUTOR_ID,CRCO_START_DATE,CRCO_END_DATE,CRCO_COMMENTS,GTA_COMPANY_ID_1,GTA_COMPANY_ID_2,CRCO_MASTER_IND,
	 CRCO_NO_RIGHTS_IND,CRCO_UPDATED_DATE,CRCO_MULTI_ARTIST_IND,CRCO_CREATION_DATE,CRCO_CREATED_BY_CONTACT,CRCO_EXP_DATE)
	SELECT CONTRIBUTOR_ID,CRCO_START_DATE,CRCO_END_DATE,CRCO_COMMENTS,GTA_COMPANY_ID_1,GTA_COMPANY_ID_2,CRCO_MASTER_IND,
	 CRCO_NO_RIGHTS_IND,CRCO_UPDATED_DATE,CRCO_MULTI_ARTIST_IND,CRCO_CREATION_DATE,CRCO_CREATED_BY_CONTACT,CRCO_EXP_DATE
	FROM CRA.LOADCONTRACT;  
	
	set @InsertCount = @@rowcount;

	set @filename = RIGHT(@FileName, CHARINDEX('\', REVERSE(@FileName))-1);
	set @filename = substring(@filename,0,24);

	update admin.dataingestion 
	set RecordsInserted = @InsertCount,
		RecordsUpdated = 0,
		RecordsDeleted = @DeleteCount,
		RecordsErrored = 0,
		EndRunDateTime = GetDate()
	where process = @filename
	and ProcessStep = 'CRA.LoadContract';

	return @@rowcount	
END

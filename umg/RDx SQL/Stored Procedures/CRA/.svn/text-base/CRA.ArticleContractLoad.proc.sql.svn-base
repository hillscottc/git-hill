CREATE PROCEDURE [CRA].[ArticleContractLoad]
	@FileName NVarchar(500),
	@retVal int = -1 OUTPUT 
AS
begin
	DECLARE @InsertCount integer;
	DECLARE @DeleteCount integer;

	SELECT @DeleteCount = COUNT(*) from CRA.ARTICLECONTRACT;

	TRUNCATE TABLE CRA.ARTICLECONTRACT;	

	INSERT INTO CRA.ARTICLECONTRACT 
	(CRAR_ID,GTA_COMPANY_ID,CONTRIBUTOR_ID,CREATION_DATETIME,NO_RIGHTS_IND,RMS_ID,PPC)
	SELECT CRAR_ID,GTA_COMPANY_ID,CONTRIBUTOR_ID,CREATION_DATETIME,NO_RIGHTS_IND,RMS_ID,PPC
	FROM CRA.LOADARTICLECONTRACT; 

	set @insertCount = @@rowcount;

	set @filename = RIGHT(@FileName, CHARINDEX('\', REVERSE(@FileName))-1);
	set @filename = substring(@filename,0,24);

	update admin.dataingestion 
	set RecordsInserted = @InsertCount,
		RecordsUpdated = 0,
		RecordsDeleted = @DeleteCount,
		RecordsErrored = 0,
		EndRunDateTime = GetDate()
	where process = @filename
	and ProcessStep = 'CRA.LoadArticleContract';

	update cra.articlecontract 
	set UPC = a.UPC,
		RELEASE_ID = A.RELEASE_ID
	from 
	(SELECT substring(upc,2,12) PPC, UPC, RELEASE_ID
	 from r2.release) a
	where articlecontract.PPC = a.PPC

	return @@rowcount	
END

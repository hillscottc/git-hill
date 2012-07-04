CREATE PROCEDURE [CRA].[ContractTerritoryLinkLoad]
	@FileName NVarchar(500),
	@retVal int = -1 OUTPUT 
AS
begin
	DECLARE @DeleteCount integer;
	DECLARE @InsertCount integer;
	SELECT @DeleteCount = COUNT(*) from CRA.ContractTerritoryLink;

	TRUNCATE TABLE CRA.ContractTerritoryLink;

	INSERT INTO CRA.ContractTerritoryLink 
	(TERRITORY_ID,CONTRIBUTOR_ID,GTA_COMPANY_ID,TERRITORY_TYPE,CREATION_DATETIME,MODIFICATION_DATETIME)
	SELECT TERRITORY_ID,CONTRIBUTOR_ID,GTA_COMPANY_ID,TERRITORY_TYPE,CREATION_DATETIME,MODIFICATION_DATETIME	
	FROM CRA.LoadContractTerritoryLink;  

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
	and ProcessStep = 'CRA.LoadContractTerritoryLink';

	return @@rowcount	
END

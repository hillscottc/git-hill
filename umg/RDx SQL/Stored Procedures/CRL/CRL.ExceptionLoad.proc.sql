create PROCEDURE [CRL].[ExceptionLoad]
	@FileName NVarchar(500),
	@retVal int = -1 OUTPUT 
AS
begin
	DECLARE @InsertCount integer;
	DECLARE @DeleteCount integer;
	SELECT @DeleteCount = COUNT(*) from CRL.Exception;			

	TRUNCATE TABLE CRL.Exception;

	INSERT INTO CRL.Exception
	SELECT * FROM CRL.LoadException;  

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
	and ProcessStep = 'CRL.LoadException';

	return @@rowcount	
END

create PROCEDURE [CRL].[ExceptionTypeLoad]
	@FileName NVarchar(500),
	@retVal int = -1 OUTPUT 
AS
begin
	DECLARE @InsertCount integer;
	DECLARE @DeleteCount integer;
	SELECT @DeleteCount = COUNT(*) from CRL.ExceptionType;		

	TRUNCATE TABLE CRL.ExceptionType;

	INSERT INTO CRL.ExceptionType
	SELECT * FROM CRL.LoadExceptionType;  

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
	and ProcessStep = 'CRL.LoadExceptionType';

	return @@rowcount	
END

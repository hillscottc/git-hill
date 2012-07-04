CREATE PROCEDURE [GDRS].[ExtractLoadRelease] 
	@FileName NVarchar(512),
	@retVal int = -1 OUTPUT 
AS
BEGIN
	truncate table GDRS.LoadRelease;

	delete from gdrs.loadreleasedriver where workflowcode = 'R';

	DECLARE @insertCount integer;
	DECLARE @sSQL nvarchar(300)

	SET @sSQL= "BULK INSERT GDRS.LoadRelease FROM '" +@FileName+ 
	  "' WITH (FIRSTROW = 2, MAXERRORS = 0, FIELDTERMINATOR = '\t', " +
	  " ROWTERMINATOR = '\n',  KEEPNULLS, FORMATFILE='D:\RDx\ETL\Common\GDRSFMT.Xml')";

	EXEC sp_executesql @sSQL 

	set @insertCount = @@rowcount;

	set @filename = RIGHT(@FileName, CHARINDEX('\', REVERSE(@FileName))-1);

	INSERT INTO Admin.DataIngestion (SourceID,RecordsReceived,RecordsInserted,RecordsUpdated,RecordsDeleted,RecordsErrored,StartRunDateTime,EndRunDateTime,ProcessStep,Process)
	values ('GDRS',@insertCount,0,0,0,0,getdate(),getdate(),'GDRS.LoadRelease',@filename);	
		
	return @@rowcount
END

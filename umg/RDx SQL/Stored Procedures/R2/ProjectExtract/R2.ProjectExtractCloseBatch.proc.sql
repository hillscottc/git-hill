CREATE PROCEDURE R2.ProjectExtractCloseBatch
AS
begin
	execute 
	('
		UPDATE PARTNER.DRIVER_KEY
		SET 
			GENERIC_STRING = ''C''
		WHERE
			REPERTOIRE_TYPE = ''PROJCT''
			AND GENERIC_STRING = ''P''
    ') at R2	
end;	


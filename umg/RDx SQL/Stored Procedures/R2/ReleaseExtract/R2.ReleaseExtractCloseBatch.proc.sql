CREATE PROCEDURE R2.ReleaseExtractCloseBatch
AS
begin
	execute 
	('
		UPDATE PARTNER.DRIVER_KEY
		SET 
			GENERIC_STRING = ''C''
		WHERE
			REPERTOIRE_TYPE = ''PRODCT''
			AND GENERIC_STRING = ''P''
    ') at R2	
end;	


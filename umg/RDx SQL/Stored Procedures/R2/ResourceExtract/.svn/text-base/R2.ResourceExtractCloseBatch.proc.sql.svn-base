CREATE PROCEDURE R2.ResourceExtractCloseBatch
AS
begin
	execute 
	('
		UPDATE PARTNER.DRIVER_KEY
		SET 
			GENERIC_STRING = ''C''
		WHERE
			REPERTOIRE_TYPE = ''RECORD''
			AND GENERIC_STRING = ''P''
    ') at R2	
end;	


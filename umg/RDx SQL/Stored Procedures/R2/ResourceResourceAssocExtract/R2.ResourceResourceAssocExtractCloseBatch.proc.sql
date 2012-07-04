CREATE PROCEDURE R2.ResourceResourceAssocExtractCloseBatch
AS
begin
	execute 
	('
		UPDATE PARTNER.DRIVER_KEY
		SET 
			GENERIC_STRING = ''C''
		WHERE
			REPERTOIRE_TYPE = ''RSRSAS''
			AND GENERIC_STRING = ''P''
    ') at R2	
end;	


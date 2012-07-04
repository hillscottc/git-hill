CREATE PROCEDURE R2.TalentNameExtractCloseBatch
AS
begin
	execute 
	('
		UPDATE PARTNER.DRIVER_KEY
		SET 
			GENERIC_STRING = ''C''
		WHERE
			REPERTOIRE_TYPE = ''TALNAM''
			AND GENERIC_STRING = ''P''
    ') at R2	
end;	


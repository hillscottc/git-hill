CREATE PROCEDURE R2.TalentExtractCloseBatch
AS
begin
	execute 
	('
		UPDATE PARTNER.DRIVER_KEY
		SET 
			GENERIC_STRING = ''C''
		WHERE
			REPERTOIRE_TYPE = ''TALENT''
			AND GENERIC_STRING = ''P''
    ') at R2	
end;	


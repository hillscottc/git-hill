CREATE PROCEDURE R2.ContributionExtractCloseBatch
AS
begin
	execute 
	('
		UPDATE PARTNER.DRIVER_KEY
		SET 
			GENERIC_STRING = ''C''
		WHERE
			REPERTOIRE_TYPE = ''CONTRI''
			AND GENERIC_STRING = ''P''
    ') at R2	
end;	


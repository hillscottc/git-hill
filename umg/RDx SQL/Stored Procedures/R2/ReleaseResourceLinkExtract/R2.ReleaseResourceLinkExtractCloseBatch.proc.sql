CREATE PROCEDURE R2.ReleaseResourceLinkExtractCloseBatch
AS
begin
	execute 
	('
		UPDATE PARTNER.DRIVER_KEY
		SET 
			GENERIC_STRING = ''C''
		WHERE
			REPERTOIRE_TYPE = ''RELRES''
			AND GENERIC_STRING = ''P''
    ') at R2	
end;	


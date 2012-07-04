CREATE PROCEDURE R2.TrackExtractCloseBatch
AS
begin
	execute 
	('
		UPDATE PARTNER.DRIVER_KEY
		SET 
			GENERIC_STRING = ''C''
		WHERE
			REPERTOIRE_TYPE = ''TRACKX''
			AND GENERIC_STRING = ''P''
    ') at R2	
end;	


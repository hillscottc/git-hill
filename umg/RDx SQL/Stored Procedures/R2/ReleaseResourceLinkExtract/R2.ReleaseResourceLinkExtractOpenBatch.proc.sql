﻿CREATE PROCEDURE R2.ReleaseResourceLinkExtractOpenBatch(@batchSize int)
AS
begin
	declare @batchSizeString nvarchar(30)
	set @batchSizeString  = convert(nvarchar(30), @batchSize)

	execute 
	('
		UPDATE PARTNER.DRIVER_KEY
		SET 
			GENERIC_STRING = ''P''
		WHERE
			REPERTOIRE_TYPE = ''RELRES'' 
			AND GENERIC_STRING = ''L'' 
			AND ROWNUM <= ' + @batchSizeString			
	) at R2	
	
	return @@rowcount
end;	
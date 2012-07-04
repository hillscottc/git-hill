CREATE PROCEDURE R2.ResourceExtractLoadResourceMedleyClear
AS
	truncate table R2.LoadResourceMedley
RETURN 0;
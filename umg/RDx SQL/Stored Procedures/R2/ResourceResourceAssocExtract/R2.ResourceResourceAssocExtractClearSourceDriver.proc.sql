CREATE PROCEDURE R2.ResourceResourceAssocExtractClearSourceDriver
AS
	execute ('
		DELETE FROM PARTNER.DRIVER_KEY
		WHERE REPERTOIRE_TYPE = ''RSRSAS''
	') at R2
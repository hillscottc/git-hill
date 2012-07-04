CREATE PROCEDURE R2.ReleaseResourceLinkExtractClearSourceDriver
AS
	execute ('
		DELETE FROM PARTNER.DRIVER_KEY
		WHERE REPERTOIRE_TYPE = ''RELRES''
	') at R2
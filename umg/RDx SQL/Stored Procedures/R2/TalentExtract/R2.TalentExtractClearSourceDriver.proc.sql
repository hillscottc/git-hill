﻿CREATE PROCEDURE R2.TalentExtractClearSourceDriver
AS
	execute ('
		DELETE FROM PARTNER.DRIVER_KEY
		WHERE REPERTOIRE_TYPE = ''TALENT''
	') at R2
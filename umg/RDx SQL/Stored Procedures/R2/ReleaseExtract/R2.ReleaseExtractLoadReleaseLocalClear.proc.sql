CREATE PROCEDURE R2.ReleaseExtractLoadReleaseLocalClear
AS
	truncate table R2.LoadReleaseLocal
RETURN 0;
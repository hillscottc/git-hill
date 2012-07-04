CREATE PROCEDURE R2.ResourceExtractLoadResourceExcerptClear
AS
	truncate table R2.LoadResourceExcerpt
RETURN 0;
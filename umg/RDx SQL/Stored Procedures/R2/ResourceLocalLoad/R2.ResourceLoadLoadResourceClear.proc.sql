﻿-- ============================================
-- Description:	Deletes all records from the R2.LoadResourceDriverLocal table
-- =============================================
CREATE PROCEDURE [R2].[ResourceLoadLoadResourceClear]
AS
begin
	truncate table R2.LoadResource;
end	

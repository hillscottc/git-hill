﻿-- ============================================
-- Description:	Deletes all records from the R2.LoadTalentNameRolesDriver table
-- =============================================
CREATE PROCEDURE [R2].[TalentNameRolesClearDriver]
AS
begin
	truncate table R2.LoadTalentNameRolesDriver;
end	

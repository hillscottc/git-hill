CREATE PROCEDURE [GDRS].[LoadReleaseDriverClear]
AS
begin
	truncate table GDRS.LoadReleaseDriver;
end

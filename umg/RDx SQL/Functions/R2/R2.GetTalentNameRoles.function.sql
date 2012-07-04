-- Returns a list of roles associated with a talent name
CREATE FUNCTION R2.GetTalentNameRoles(@TalentNameID numeric(38,0))
RETURNS nvarchar(max)
AS
BEGIN
	declare @RoleList nvarchar(max)
	SET @RoleList = ''	

	SELECT  @RoleList = (
		SELECT distinct rol.NAME + ','
		FROM	
			R2.TalentName AS tn 
			INNER JOIN R2.Contribution AS c ON tn.TALENT_NAME_ID = c.TALENT_NAME_ID 
			INNER JOIN R2.Role AS rol ON c.ROLE_NO = rol.ROLE_NO
		WHERE 
			tn.TALENT_NAME_ID = @TalentNameID
		FOR XML PATH(''))

	--strip out last comma	
	DECLARE @StringLen smallint;
	set @StringLen = LEN(@RoleList)
	if @StringLen > 0
		set @RoleList = SUBSTRING(@RoleList, 1, @StringLen - 1)

	RETURN @RoleList
END
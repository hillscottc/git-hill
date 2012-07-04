CREATE TABLE [R2].[TalentNameRoles](
	[TALENT_NAME_ID] [numeric](38, 0) NOT NULL,
	[ROLES] [nvarchar](max) NOT NULL,
	[CHANGE_CODE] [varchar](2) NOT NULL DEFAULT ('I'),
	[CHANGE_DATE_TIME] [datetime] NOT NULL DEFAULT (getdate()),
	[WORKFLOW_CODE] [varchar](2) NOT NULL DEFAULT ('L')
)
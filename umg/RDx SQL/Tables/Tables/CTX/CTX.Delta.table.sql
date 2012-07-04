CREATE TABLE CTX.Delta(
	ID [bigint] IDENTITY(1,1) NOT NULL,
	CONTAINER_ID numeric (38, 0) NOT NULL,
	CHANGE_TYPE nvarchar(1) NOT NULL,
	DATE_OF_CHANGE datetime default(getdate()) NOT NULL,
	WORKFLOW_CODE varchar(3) default('E') NOT NULL,	
) ON [PRIMARY]
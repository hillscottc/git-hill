CREATE TABLE DRA.ExtractDriverEntityClearanceSet(
	ID bigint IDENTITY(1,1) NOT NULL,
	ENTITY_CLEARANCE_SET_ID numeric (38, 0) NOT NULL,
	CHANGE_CODE varchar(2) NOT NULL DEFAULT ('I'),
	CHANGE_DATE_TIME datetime default(getdate()) NOT NULL,
	WORKFLOW_CODE varchar(3) default('E') NOT NULL,
) ON [PRIMARY]
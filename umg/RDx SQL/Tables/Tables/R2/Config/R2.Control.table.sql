﻿CREATE TABLE [R2].[Control]
(
	[CONTROL_ID] [numeric](38, 0) NOT NULL,
	[TYPE_] [nvarchar](6) NOT NULL,
	[ID] [nvarchar](6) NOT NULL,
	[AUDIT_DATE_CHANGED] [datetime] NOT NULL,
	[AUDIT_DATE_CREATED] [datetime] NOT NULL,
	[AUDIT_EMPLOYEE_NO] [numeric](38, 0) NOT NULL,
	[COMPANY] [nvarchar](6) NOT NULL,
	[COUNTRY] [nvarchar](2) NOT NULL,
	[INT1] [numeric](38, 0) NULL,
	[INT2] [numeric](38, 0) NULL,
	[INT3] [numeric](38, 0) NULL,
	[INT4] [numeric](38, 0) NULL,
	[INT5] [numeric](38, 0) NULL,
	[TEXT1] [nvarchar](max) NULL,
	[TEXT2] [nvarchar](max) NULL,
	[TEXT3] [nvarchar](max) NULL,
	[TEXT4] [nvarchar](max) NULL,
	[TEXT5] [nvarchar](max) NULL,
	[DATE1] [datetime] NULL,
	[DATE2] [datetime] NULL,
	[DATE3] [datetime] NULL,
	[DATE4] [datetime] NULL,
	[DATE5] [datetime] NULL,
	[FLOAT1] [float] NULL,
	[FLOAT2] [float] NULL,
	[FLOAT3] [float] NULL,
	[FLOAT4] [float] NULL,
	[FLOAT5] [float] NULL,
	[CHANGE_CODE] [varchar](2) DEFAULT 'I' NOT NULL,
	[CHANGE_DATE_TIME] [datetime] DEFAULT GETDATE() NOT NULL,
	[WORKFLOW_CODE] [varchar](2) NOT NULL DEFAULT ('L')
) ON [PRIMARY]
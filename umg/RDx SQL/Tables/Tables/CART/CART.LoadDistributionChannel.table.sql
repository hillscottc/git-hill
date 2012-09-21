﻿CREATE TABLE [CART].[LoadDistributionChannel](
	[Isrc] [nvarchar](25) NULL,
	[Upc] [nvarchar](25) NULL,
	[Name] [nvarchar](50) NULL,
	[Status] [nvarchar](50) NULL,
	[WorkflowStatus] [nvarchar](25) NULL,
	[ClearanceComments] [nvarchar](255) NULL,
	[Reason] [nvarchar](255) NULL,
	[Explanation] [nvarchar](255) NULL,
	[Clearance] [nvarchar](25) NULL,
	[LoadCreateDate] [datetime] NULL
) ON [PRIMARY]
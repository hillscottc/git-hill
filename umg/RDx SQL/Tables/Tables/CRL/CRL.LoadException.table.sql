CREATE TABLE [CRL].[LoadException](
	[EXCEPTION_ID] [numeric](38, 0) NULL,
	[FK_EXCEPTION_TYPE_ID] [numeric](38, 0) NULL,
	[COMMENTS] [ntext] NULL,
	[STATUS] [nchar](1) NULL,
	[DATE_REMOVED] [datetime] NULL,
	[OBJ_VER] [int] NULL,
	[TALENT_NO] [bigint] NULL,
	[ACTIVE_PRODUCT_COUNT] [int] NULL,
	[ACTIVE_ASSET_COUNT] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

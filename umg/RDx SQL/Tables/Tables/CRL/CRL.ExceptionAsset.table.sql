CREATE TABLE [CRL].[ExceptionAsset](
	[EXCEPTION_ASSET_ID] [numeric](38, 0) NULL,
	[FK_EXCEPTION_ID] [numeric](38, 0) NULL,
	[FK_RMS_ASSET_ID] [numeric](38, 0) NULL,
	[STATUS] [nchar](1) NULL,
	[DATE_REMOVED] [datetime] NULL,	
	[OBJ_VER] [int] NULL,
	[PROCESSED_IND] [nchar](1) NULL
) ON [PRIMARY]

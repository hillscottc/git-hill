CREATE TABLE [CRL].[LoadExceptionProduct](
	[EXCEPTION_PRODUCT_ID] [numeric](38, 0) NULL,
	[FK_EXCEPTION_ID] [numeric](38, 0) NULL,
	[FK_RMS_PRODUCT_ID] [numeric](38, 0) NULL,
	[STATUS] [nchar](1) NULL,
	[DATE_REMOVED] [datetime] NULL,
	[OBJ_VER] [int] NULL	
) ON [PRIMARY]

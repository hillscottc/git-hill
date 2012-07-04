CREATE TABLE [PO].[Release](
	[PO_Release_ID] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[UPC] [nvarchar](50) NOT NULL,
	[Release_Date] [nvarchar](50) NULL,
	[Release_Rights] [nvarchar](300) NULL
) ON [PRIMARY]

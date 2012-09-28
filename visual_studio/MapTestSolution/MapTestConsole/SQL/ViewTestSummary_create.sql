USE [MapTestResultDb]
GO

/****** Object:  View [dbo].[TestSummary]    Script Date: 09/28/2012 12:02:16 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[TestSummary]'))
DROP VIEW [dbo].[TestSummary]
GO

USE [MapTestResultDb]
GO

/****** Object:  View [dbo].[TestSummary]    Script Date: 09/28/2012 12:02:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[TestSummary]
AS
SELECT     a.Id, d.Address, e.Name AS Vendor1, f.Name AS Vendor2, a.Distance
FROM         dbo.DistanceResults AS a INNER JOIN
                      dbo.VendorTestResults AS b ON a.FirstVendorTestResultId = b.Id INNER JOIN
                      dbo.VendorTestResults AS c ON a.SecondVendorTestResultId = c.Id INNER JOIN
                      dbo.TestItems AS d ON b.TestItemId = d.Id INNER JOIN
                      dbo.Vendors AS e ON e.Id = b.VendorId INNER JOIN
                      dbo.Vendors AS f ON f.Id = c.VendorId

GO

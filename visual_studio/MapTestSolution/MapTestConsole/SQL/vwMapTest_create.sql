USE [Geneva3_Reporting]
GO

/****** Object:  View [dbo].[vwMapTest]    Script Date: 09/21/2012 10:54:21 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vwMapTest]'))
DROP VIEW [dbo].[vwMapTest]
GO

USE [Geneva3_Reporting]
GO

/****** Object:  View [dbo].[vwMapTest]    Script Date: 09/21/2012 10:54:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwMapTest]
AS
SELECT     CG.ID, CG.ResellerID, C.Address1, C.Address2, C.Address3, C.City, C.Region, C.PostalCode, C.CountryCode
FROM         dbo.Campaign AS CG WITH (NOLOCK) INNER JOIN
                      dbo.AdvertiserServiceLocation AS ASL WITH (NOLOCK) ON CG.AdvertiserID = ASL.AdvertiserID INNER JOIN
                      dbo.Contact AS C WITH (NOLOCK) ON C.ID = ASL.ContactID INNER JOIN
                      dbo.CampaignServiceLocation AS CSL WITH (NOLOCK) ON CSL.CampaignID = CG.ID AND CSL.AdvertiserServiceLocationID = ASL.ID
WHERE     (CG.StatusReasonID IN (2, 6, 13))

GO


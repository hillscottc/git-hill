﻿CREATE CLUSTERED INDEX [Clustered_CompanyID_ResourceID_ReleaseID_GroupSequenceNo_SequenceNo]
ON [R2].[LoadTrackLocalDriver]
	(COMPANY_ID, RESOURCE_ID, RELEASE_ID, GROUP_SEQUENCE_NO, SEQUENCE_NO);



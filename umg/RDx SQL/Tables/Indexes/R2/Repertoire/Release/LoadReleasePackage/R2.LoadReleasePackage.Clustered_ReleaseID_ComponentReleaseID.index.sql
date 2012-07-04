CREATE CLUSTERED INDEX [Clustered_ReleaseID_ComponentReleaseID]
ON [R2].[LoadReleasePackage]
	([RELEASE_ID], [COMPONENT_RELEASE_ID] ASC);



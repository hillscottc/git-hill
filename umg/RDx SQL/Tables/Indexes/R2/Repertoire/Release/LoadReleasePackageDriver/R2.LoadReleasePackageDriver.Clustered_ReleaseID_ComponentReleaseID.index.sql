CREATE CLUSTERED INDEX [Clustered_ReleaseID_ComponentReleaseID]
ON [R2].[LoadReleasePackageDriver]
	([RELEASE_ID], [COMPONENT_RELEASE_ID] ASC);



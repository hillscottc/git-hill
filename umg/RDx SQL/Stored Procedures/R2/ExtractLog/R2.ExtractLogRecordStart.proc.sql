CREATE PROCEDURE R2.ExtractLogRecordStart
AS
	declare @snapshot_time datetime

	select @snapshot_time = snapshot_time
	from openquery(R2,
	'
		select (trunc(min(m.last_refresh_date),''hh24'')) snapshot_time
		from 
			all_snapshots s, all_mviews m
		where 
			m.owner = ''RMS''
			and m.owner = s.owner
			and s.refresh_group is not null
			and s.name = m.mview_name
	'
	)

	insert into R2.ExtractLog ( SnapshotTimePDT, StartTime, [Status])
	values ( @snapshot_time, getdate(),  'P')

	RETURN cast(@@identity as int)
;	

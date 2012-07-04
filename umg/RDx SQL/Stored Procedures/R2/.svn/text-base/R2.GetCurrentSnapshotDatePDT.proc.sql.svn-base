CREATE PROCEDURE R2.GetCurrentSnapshotDatePDT(@date datetime output)
AS
	select @date = snapshot_time
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
;
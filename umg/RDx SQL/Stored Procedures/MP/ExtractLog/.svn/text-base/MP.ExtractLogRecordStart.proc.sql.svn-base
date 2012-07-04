CREATE PROCEDURE MP.ExtractLogRecordStart
AS
	insert into MP.ExtractLog ( StartTime, [Status] )
	values ( getdate(),  'P')

	RETURN cast(@@identity as int)
;	

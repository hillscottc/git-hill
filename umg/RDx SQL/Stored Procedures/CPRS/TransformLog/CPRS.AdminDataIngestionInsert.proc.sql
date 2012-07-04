CREATE PROCEDURE CPRS.AdminDataIngestionInsert(@sessionID bigint)
AS
INSERT INTO [Admin].[DataIngestion]
(
	[SourceID]
	,[RecordsReceived]
	,[RecordsInserted]
	,[RecordsUpdated]
	,[RecordsDeleted]
	,[RecordsErrored]
	,[StartRunDateTime]
	,[EndRunDateTime]
	,[ProcessStep]
	,[Process]
)
SELECT 
	SourceID = 'CPRS',
	RecordsReceived = isnull(p.I, 0) + isnull(p.U, 0) + isnull(p.D, 0),
	RecordsInserted = isnull(p.I, 0),
	RecordsUpdated = isnull(p.U, 0),
	RecordsDeleted  = isnull(p.D, 0),
	RecordsErrored  = 0,
	StartRunDateTime = s.StartTime,
	EndRunDateTime = s.EndTime,
	ProcessStep = s.ID,
	Process = s.ID
FROM
( 
	SELECT tlt.SessionID, tlt.WorkflowCode, tlt.Rows FROM CPRS.TransformLogTask tlt where tlt.SessionID = @sessionID		
) AS t
PIVOT 
( 
	SUM(Rows) for WorkflowCode IN ([I], [U], [D]) 
) AS p
INNER JOIN 
	CPRS.TransformLogSession s
		on s.ID = p.SessionID

-- Inserts a record in CPRS.TransformLogTask
-- It will create a pending session in CPRS.TransformLogSession if there is not one available already 
CREATE PROCEDURE CPRS.TransformLogTaskInsert (@logger nvarchar(1000), @rows bigint, @workflowCode varchar(2)) 
AS
	declare @sessionID bigint
	select @sessionID = ID from CPRS.[TransformLogSession] where [Status] = 'P'
	if (@sessionID is null) begin
		
		insert into CPRS.[TransformLogSession] (Logger) 
		values (@logger) 
		
		set @sessionID = @@identity
	end
	
	INSERT INTO CPRS.[TransformLogTask] ([SessionID],[Logger],[Rows],[WorkflowCode])
    VALUES (@sessionID, @logger, @rows, @workflowCode)	
;	

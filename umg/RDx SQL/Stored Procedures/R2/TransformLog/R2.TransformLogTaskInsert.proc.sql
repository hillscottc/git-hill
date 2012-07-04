-- Inserts a record in R2.TransformLogTask
-- It will create a pending session in R2.TransformLogSession if there is not one available already 
CREATE PROCEDURE R2.TransformLogTaskInsert (@logger nvarchar(1000), @rows bigint, @workflowCode varchar(2)) 
AS
	declare @sessionID bigint
	select @sessionID = ID from R2.[TransformLogSession] where [Status] = 'P'
	if (@sessionID is null) begin
		
		insert into R2.[TransformLogSession] (Logger) 
		values (@logger) 
		
		set @sessionID = @@identity
	end
	
	INSERT INTO R2.[TransformLogTask] ([SessionID],[Logger],[Rows],[WorkflowCode])
    VALUES (@sessionID, @logger, @rows, @workflowCode)	
;	

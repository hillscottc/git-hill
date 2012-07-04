-- =============================================
-- Description:	Loads records into CTX.DataContractDeleted
-- =============================================
CREATE PROCEDURE CTX.DataContractDeletedInsert
AS
begin
	-- store the deleted records
	-- the left joins is to prevent duplicate records in DataContractDeleted 
	insert into CTX.DataContractDeleted 
	(
		CONTRACT_ID
	)
	select distinct 
		d.CONTRACT_ID 
	from 
		CTX.ExtractDriver d
		left outer join CTX.DataContractDeleted t 
			on d.CONTRACT_ID = t.CONTRACT_ID
	where 
		t.CONTRACT_ID is null
		and
		(d.CHANGE_CODE = 'D' and d.WORKFLOW_CODE = 'E')
	
	-- mark the records as complete
	update CTX.ExtractDriver
	set WORKFLOW_CODE = 'C' 
	where WORKFLOW_CODE = 'E' and CHANGE_CODE = 'D'
end;	



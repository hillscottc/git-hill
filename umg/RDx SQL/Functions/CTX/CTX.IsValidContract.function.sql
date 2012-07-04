-- Indicates that a contract is valid to transfer to RDxReport
-- Uses the following criteria:
-- 1) TEMPLATE_ID in CTX.DataTemplateFilter AND REQUIRED = 'Y' 
-- 2) CONTRACT_SUMMARY_STATUS must be FINAL
-- 3) When TEMPLATE_ID = 17734428 then CONTRACT_TYPE must be 'Künstlervertrag' or 'Bandübernahme'
-- 4) When TEMPLATE_ID = 17693888 then take any CONTRACT_TYPE, but if CONTRACT_TYPE = 'Licensing Agreement' then UMCLicensee/Licensor must be 'Licensee'
CREATE FUNCTION [CTX].[IsValidContract] (@contractID numeric (38, 0))
RETURNS BIT
AS
BEGIN
RETURN case when exists 
(
	select * from CTX.DataContract 
	where @contractID in 
	(
		-- REQUIRED = 'Y'
		-- CONTRACT_SUMMARY_STATUS = FINAL
		SELECT dc.CONTRACT_ID
		FROM CTX.DataContract dc inner join CTX.DataTemplateFilter dtf on dc.TEMPLATE_ID = dtf.TEMPLATE_ID
		where 
			dtf.[REQUIRED] = 'Y'
			and lower(dc.CONTRACT_SUMMARY_STATUS) = 'final'
			and dc.TEMPLATE_ID <> 17734428 -- 17734428 is handled separately in an UNION below
			and dc.TEMPLATE_ID <> 17693888 -- 17693888 is handled separately in an UNION below
	union
		-- TEMPLATE_ID = 17734428
		-- Contract Type = 'Künstlervertrag' or 'Bandübernahme'
		SELECT dc.CONTRACT_ID
		FROM CTX.DataContract dc
		where
			dc.TEMPLATE_ID = 17734428
			and lower(dc.CONTRACT_SUMMARY_STATUS) = 'final'
			and (dc.CONTRACT_TYPE = 'Künstlervertrag' OR dc.CONTRACT_TYPE = 'Bandübernahme')
	union

		-- TEMPLATE_ID = 17693888
		-- Contract Type = any but if Contract Type = 'Licensing Agreement' then UMCLicensee/Licensor = 'Licensee'
		SELECT dc.CONTRACT_ID
		FROM CTX.DataContract dc
		where
			dc.TEMPLATE_ID = 17693888
			and lower(dc.CONTRACT_SUMMARY_STATUS) = 'final'
			and (dc.CONTRACT_TYPE <> 'Licensing Agreement')
	union

		SELECT dc.CONTRACT_ID
		FROM CTX.DataContract dc
		where
			dc.TEMPLATE_ID = 17693888
			and lower(dc.CONTRACT_SUMMARY_STATUS) = 'final'
			and (dc.CONTRACT_TYPE = 'Licensing Agreement')
	)
)
then 1 else 0 end

END
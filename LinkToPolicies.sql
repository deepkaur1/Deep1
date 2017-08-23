SELECT 
	CC.ID,
	PP.POLICY_ID, 
	CASE WHEN PP.POLICY_ID IS NULL AND (CP.PolicyNumber LIKE 'C%' OR CP.PolicyNumber LIKE 'HO%' OR CP.PolicyNumber LIKE 'F%') THEN 1 ELSE 0 END LegacyPolicy,
	CASE WHEN PP.POLICY_ID IS NULL AND (CP.PolicyNumber LIKE 'C%' OR CP.PolicyNumber LIKE 'HO%' OR CP.PolicyNumber LIKE 'F%') THEN 
		CASE CP.PolicyType 
				WHEN 10001 THEN 'Auto'
				WHEN 10003 THEN 'Home'
				WHEN 10002 THEN 'Fire'
				WHEN 10004 THEN 'Umbrella'
	END END AS LegacyLOB,
	CASE WHEN PP.POLICY_ID IS NULL AND (CP.PolicyNumber LIKE 'C%' OR CP.PolicyNumber LIKE 'HO%' OR CP.PolicyNumber LIKE 'F%') THEN CP.ProducerCode END LegacyProducerCode
FROM
    dbo.cc_policy CP
	INNER JOIN dbo.cc_claim CC ON CC.PolicyID = CP.ID
	LEFT JOIN PS..POL_POLICY PP ON PP.POLICY_NBR_X = CP.PolicyNumber
		AND PP.POLICY_NBR_SEQ = CP.BRMI_PStarModNumber
		AND CP.BRMI_PStarModNumber IS NOT NULL
WHERE
	CC.State != 1
	AND CC.Retired = 0

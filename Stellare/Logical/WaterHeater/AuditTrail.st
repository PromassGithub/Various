
ACTION AuditTrail: 

	// Manage recipe datapoints
	IF (WaterTemp <> _WaterTemp) THEN
		MpAuditValueChangeStatus := MpAuditValueChange(gAuditTrail, _WaterTemp, WaterTemp, '104');
		_WaterTemp := WaterTemp;
	END_IF
	

END_ACTION


ACTION Energy: 
	ActivePower := 1800;
	ForwardActiveEnergy := MpEnergyRegEnergy_0.ForwardActiveEnergy + 0.1*ABS(MTBasicsPID_0.ControlError);

	MpEnergyRegPower_0(
		MpLink := ADR(gEnergyCore), 
		Enable := TRUE, 
		ModuleName := ADR('Waterheater Power'), 
		Mode := mpENERGY_REG_MODE_COLLECT, 
		Units := mpENERGY_POWER_UNIT_W, 
		ActivePower := ActivePower);
	
	MpEnergyRegEnergy_0(
		MpLink := ADR(gEnergyCore), 
		Enable := TRUE, 
		ModuleName := ADR('Waterheater Energy'), 
		Mode := mpENERGY_REG_MODE_COLLECT, 
		Units := mpENERGY_ENERGY_UNIT_WS, 
		ForwardActiveEnergy := ForwardActiveEnergy);
	
END_ACTION

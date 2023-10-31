
ACTION Energy: 
	
	MpEnergyRegPower_0(
		MpLink := ADR(gEnergyCore), 
		Enable := TRUE, 
		ModuleName := ADR('ConveyorCupFeeder'), 
		Mode := mpENERGY_REG_MODE_COLLECT, 
		Units := mpENERGY_POWER_UNIT_W, 
		ActivePower := ActivePowerCupFeeder);
	
	MpEnergyRegPower_1(
		MpLink := ADR(gEnergyCore), 
		Enable := TRUE, 
		ModuleName := ADR('ConveyorTakeout'), 
		Mode := mpENERGY_REG_MODE_COLLECT, 
		Units := mpENERGY_POWER_UNIT_W, 
		ActivePower := ActivePowerTakeout);
	
END_ACTION

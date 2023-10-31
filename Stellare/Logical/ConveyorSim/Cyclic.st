PROGRAM _CYCLIC
//	Cupfeed conveyor simulation
	IF (gCoffeeMainLogic.AxisCupFeeder.Active = TRUE)   THEN		 	 
		IF (gCoffeeMainLogic.AxisCupFeeder.Power = TRUE) THEN
			gCoffeeMainLogic.AxisCupFeeder.PowerOn 	:= TRUE;
			ActivePowerCupFeeder := 30;
			IF (gCoffeeMainLogic.AxisCupFeeder.MoveAdditive = TRUE) THEN
				IF (gCoffeeMainLogic.AxisCupFeeder.Position < 700.0) THEN
					gCoffeeMainLogic.AxisCupFeeder.Position 	:= 
					gCoffeeMainLogic.AxisCupFeeder.Position + 1.5;
					ActivePowerCupFeeder := 80;
				ELSE
					gCoffeeMainLogic.AxisCupFeeder.InPosition := TRUE;
					
					ActivePowerCupFeeder := 30;
				END_IF;
			END_IF;
			Energy;
		ELSE
			gCoffeeMainLogic.AxisCupFeeder.PowerOn 	:= FALSE;
			ActivePowerCupFeeder := 0;
			Energy;
		END_IF;	
	ELSE
		gCoffeeMainLogic.AxisCupFeeder.PowerOn 	:= FALSE;
		
		ActivePowerCupFeeder := 0;
		Energy;
	END_IF;

	//	Takeout conveyor simulation
	IF (gCoffeeMainLogic.AxisTakeout.Active = TRUE)   THEN		 	 
		IF (gCoffeeMainLogic.AxisTakeout.Power = TRUE) THEN
			gCoffeeMainLogic.AxisTakeout.PowerOn 	:= TRUE;
			ActivePowerTakeout := 10;
			IF (gCoffeeMainLogic.AxisTakeout.MoveAdditive = TRUE) THEN
				IF (gCoffeeMainLogic.AxisTakeout.Position < 300.0) THEN
					gCoffeeMainLogic.AxisTakeout.Position 	:= 
					gCoffeeMainLogic.AxisTakeout.Position + 1.5;
					ActivePowerTakeout := 68;
				ELSE
					gCoffeeMainLogic.AxisTakeout.InPosition := TRUE;
					
					ActivePowerTakeout := 10;
				END_IF;
			END_IF;
			Energy;
		ELSE
			gCoffeeMainLogic.AxisTakeout.PowerOn 	:= FALSE;
			ActivePowerTakeout := 0;
			Energy;
		END_IF;	
	ELSE
		gCoffeeMainLogic.AxisTakeout.PowerOn 	:= FALSE;
		
		ActivePowerTakeout := 0;
		Energy;
	END_IF;

END_PROGRAM

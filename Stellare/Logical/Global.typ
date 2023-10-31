
TYPE
	typ_ricetta : 	STRUCT 
		Ora_Inizio : DT;
		Ora_Fine : DT;
		Tempo_Attivita : UDINT;
		Giri_Parziali : UDINT;
		Giri_Totali : UDINT;
	END_STRUCT;
	typ_cont : 	STRUCT 
		Inp_S_Stellare : BOOL;
		S_stellare : BOOL;
		giri_parziali : UDINT;
		giri_totali : UDINT;
		giri_instant : UDINT;
		frequenza : UDINT;
		nome_ricetta1 : UDINT;
		nome_ricetta2 : STRING[80];
		nome_ricetta3 : UDINT;
		nome_ricetta : STRING[80];
	END_STRUCT;
	PackMLModes : 
		(
		PACKML_MODE_PRODUCTION := 1,
		PACKML_MODE_MAINTENANCE := 2
		);
	ReportCoffeeType : 	STRUCT 
		Name : STRING[255];
		Water : INT;
		Sugar : INT;
		Coffee : INT;
		Milk : INT;
	END_STRUCT;
	RefillAlarmType : 	STRUCT 
		Water : BOOL;
		Sugar : BOOL;
		Milk : BOOL;
		Coffee : BOOL;
	END_STRUCT;
	RefillType : 	STRUCT 
		Water : INT;
		Sugar : INT;
		Milk : INT;
		Coffee : INT;
	END_STRUCT;
	CoffeeMainLogicType : 	STRUCT  (*Main logic structure *)
		AxisCupFeeder : CoffeeAxisLogicType; (*Control structure for axis*)
		AxisTakeout : CoffeeAxisLogicType; (*Control structure for axis*)
		cmdAbort : BOOL; (*HMI control to start the brewing process*)
		cmdStop : BOOL; (*HMI control to start the brewing process*)
		cmdClear : BOOL; (*HMI control to start the brewing process*)
		cmdStart : BOOL; (*HMI control to start the brewing process*)
		TemperatureWithinLimit : BOOL; (*HMI control bit *)
		CreateFirstRecipe : BOOL; (*Enable synchronization when creating the default recipes*)
		visPictureIndex : USINT; (*RecipeIndex when creating the default recipes*)
		cmdTakeout : BOOL;
		Refill : RefillType; (*Structure to control the ingredients*)
		AlarmRefill : RefillAlarmType; (*Structure which is controlling the Refill-Alarms*)
		CoffeeState : CoffeeStateEnum;
		ReportCoffee : ARRAY[0..199]OF ReportCoffeeType;
		PackMLState : STRING[80];
		IdleState : BOOL;
	END_STRUCT;
	CoffeeAxisLogicType : 	STRUCT  (*Sub structure for controlling axis*)
		Active : BOOL; (*Axis component is ready*)
		Power : BOOL; (*Power on command*)
		PowerOn : BOOL; (*Power is on*)
		Home : BOOL; (*Homing command *)
		MoveAdditive : BOOL; (*MoveAdditive command*)
		MoveActive : BOOL; (*Move active*)
		InPosition : BOOL; (*Commanded position reached *)
		Position : LREAL; (*Current position*)
	END_STRUCT;
	CoffeeStateEnum : 
		(
		COFFEE_WAIT := 0,
		COFFEE_TAKEWATER := 1,
		COFFEE_TAKECOFFEE := 2,
		COFFEE_TAKECOFFEEMILK := 3,
		COFFEE_RELEASE := 4,
		COFFEE_FINISH := 5
		);
END_TYPE

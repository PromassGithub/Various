
TYPE
	WaterHeaterUIConnectType : 	STRUCT  (*Main logic structure *)
		actTemperature : REAL; (*HMI actual temperature value*)
		setTemperature : REAL; (*HMI set temperature value*)
		visShowCooling : UINT; (*HMI control variable*)
		visShowHeating : UINT; (*HMI control variable*)
	END_STRUCT;
END_TYPE

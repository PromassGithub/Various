
	PROGRAM _CYCLIC
	(* Insert code here *)
	
	
//	life_cycles	UDINT	TRUE	FALSE	FALSE	FALSE		 	 	 	2
//	life_mold_distance	LREAL	FALSE	FALSE	FALSE	TRUE		Distanza totale in metri			3
//	life_auto_mode_wrk_time	typ_work_time	FALSE	FALSE	FALSE	TRUE		 	 	 	4
//	life_loading_1_total_wrk_time	typ_work_time	FALSE	FALSE	FALSE	TRUE		 	 	 	5
//	life_loading_2_total_wrk_time	typ_work_time	FALSE	FALSE	FALSE	TRUE		 	 	 	6
//	life_hydraulic_total_wrk_time	typ_work_time	FALSE	FALSE	FALSE	TRUE		 	 	 	7
//	life_manu_mode_wrk_time	typ_work_time	FALSE	FALSE	FALSE	TRUE		 	 	 	8
//	life_total_wrk_time	typ_work_time	FALSE	FALSE	FALSE	TRUE		 	 	 	9
//	recipe	typ_Recipe	TRUE	FALSE	FALSE	FALSE		 	 	 	10
//	last_recipe	STRING[30]	TRUE	FALSE	FALSE	FALSE	 	 	 	 	11
//	life_total_mold_change	USINT	FALSE	FALSE	FALSE	TRUE		 	 	 	12
//	power_analyzer	typ_Ctr_Master_memory	FALSE	FALSE	FALSE	TRUE		 	 	 	13
//	mac_status	typMacStatus	FALSE	FALSE	FALSE	TRUE	 	 	 	 	14

	//glb_remote_recipe_loading				:= 1;		// used to enable popup and relative 
	
	life_cycles ACCESS ADR(gMAC01.LifeCycles);

	
	//power_analyzer ACCESS ADR(machine.Ctr_MPaster_data.memory);
	//mac_status ACCESS ADR(permanent_ore_auto);
	
	
	
	mac_status.actual_cycle_nr		:= gMAC01.ActualCycleNr;
	mac_status.actual_cycle_time	:= gMAC01.ActualCycleTime;
	//mac_status.commit_cycles		:= 
	mac_status.last_cycle_time		:= gMAC01.LastCycleTime;
	mac_status.auto					:= gMAC01.AutoMode;
	mac_status.man					:= gMAC01.ManMode;
	mac_status.alarm				:= gMAC01.Alarm;
	mac_status.stop					:= gMAC01.Stop;
	mac_status.running				:= gMAC01.Run;
	mac_status.mch_on				:= gMAC01.MCH_on;

	
	
	
END_PROGRAM

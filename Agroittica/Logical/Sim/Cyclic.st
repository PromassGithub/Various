
PROGRAM _CYCLIC
	
	IF Simu_enable THEN
		
		//set variabili per simulazione
		glb_err_sim.Drive1 			:= 0;
	
		glb_err_sim.Drive2 			:= 0;
	
		glb_err_sim.pending_alarms 	:= 0;
	
		glb_err_sim.Air				:= 0;
	
		glb_err_sim.Em_Bt			:= 0;

		//simulatore nastro pesci
		CASE fish_cmd OF
		
			0:
				IF START_Fish AND (NOT STOP_fish) THEN
					fish_cmd := 10;
				END_IF;
			
			10:
				TON_06.IN := 1;
			
				IF TON_06.Q = 1 THEN
					fish_cmd := 20;
				END_IF;
			
				IF STOP_fish THEN
					fish_cmd := 30;
				END_IF;
			
			20:
				glb_io.Di.Si_01 := 1;
				Debugstring		:='on';
				fish_cmd		:= 30;
			
			30:
				glb_io.Di.Si_01 := 0;
				Debugstring1	:='off';
				TON_06.IN		:= 0;
				fish_cmd 		:= 0;
		
		END_CASE;
	
		//Timer
	
		TON_06;
	
		TON_06.PT := T#750ms;
	
		TP_01;
	
		TP_01.PT := T#1s;
	
	
		//Pairing segnali per simulazione
		glb_io.Di.Start 			:= glb_io_sim.Di.Start;
	
		glb_io.Di.Stop 				:= glb_io_sim.Di.Stop;
	
		glb_io.Di.Automatic 		:= glb_io_sim.Di.Automatic;
	
		glb_io.Di.Manual 			:= glb_io_sim.Di.Manual;
	
		glb_io.Di.Reset				:= glb_io_sim.Di.Reset;
	
		glb_io.Di.Forward_Mag_1		:= glb_io_sim.Di.Forward_Mag_1;
	
		glb_io.Di.Backward_Mag_1	:= glb_io_sim.Di.Backward_Mag_1;
	
		glb_io.Di.Forward_Mag_2		:= glb_io_sim.Di.Forward_Mag_2;
	
		glb_io.Di.Backward_Mag_2	:= glb_io_sim.Di.Backward_Mag_2;
	
		glb_err.Drive1 				:= glb_err_sim.Drive1;
	
		glb_err.Drive2 				:= glb_err_sim.Drive2;
	
		glb_err.pending_alarms 		:= glb_err_sim.pending_alarms;
	
		glb_err.Air					:= glb_err_sim.Air;
	
		glb_err.Em_Bt				:= glb_err_sim.Em_Bt;
		
	END_IF;
	
	
	
END_PROGRAM

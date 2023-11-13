
PROGRAM _CYCLIC
	(* Insert code here *)
	 
	CASE Allarm_0.St_allarm OF
		
		0: //START
			IF ( Status = AUTO OR Status = MANUAL) THEN
				Allarm_0.St_allarm := 10;
			END_IF;
		
		10: //IDLE
			IF (glb_err.Drive1) THEN
				Allarm_0.St_allarm := 30100; //allarme M1
			END_IF;
		
			IF (glb_err.Drive2) THEN
				Allarm_0.St_allarm := 30200; // allarme M2
			END_IF;
			
			IF (glb_err.PLC) THEN
				Allarm_0.St_allarm := 30300; // allarme Fungo
			END_IF;
		
			IF (glb_err.Air) THEN
				Allarm_0.St_allarm := 30400; // allarme aria
			END_IF;
		
			IF (glb_err.Fish) THEN
				Allarm_0.St_allarm := 30500; // allarme pesce
			END_IF;
		
		30100: //allarme M1
			
			(*Status := ERR;*)
			glb_err.pending_alarms := glb_err.pending_alarms + 1;
			
			IF (Allarm_0.Ack) THEN
				Allarm_0.St_allarm := 40000;
			END_IF;
			
		
		30200: // allarme M2
			
			(*Status := ERR;*)
			glb_err.pending_alarms := glb_err.pending_alarms + 1;
			
			IF (Allarm_0.Ack) THEN
				Allarm_0.St_allarm := 40000;
			END_IF;
		
		30300: // allarme Fungo
		
			(*Status := ERR;*)
			glb_err.pending_alarms := glb_err.pending_alarms + 1;
			
			IF (Allarm_0.Ack) THEN
				Allarm_0.St_allarm := 40000;
			END_IF;
		
		30400: // allarme aria
		
			(*Status := ERR;*)
			glb_err.pending_alarms := glb_err.pending_alarms + 1;
			
			IF (Allarm_0.Ack) THEN
				Allarm_0.St_allarm := 40000;
			END_IF;
		
		30500: // allarme pesce
		
			(*Status := ERR;*)
			glb_err.pending_alarms := glb_err.pending_alarms + 1;
			glb_io.Do.MainAllarm := 1;
		
			IF (Allarm_0.Ack) THEN
				Allarm_0.St_allarm := 40000;
			END_IF;
		
		40000:
			glb_err.pending_alarms := 0;
			glb_io.Do.MainAllarm := 0;
			Allarm_0.St_allarm := 0;
			
	END_CASE;
	
	
END_PROGRAM

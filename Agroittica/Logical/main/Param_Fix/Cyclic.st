
PROGRAM _CYCLIC
	(* Insert code here *)
	IF Pesi_0.Max_Weight_B < Pesi_0.Min_Weight_B THEN Pesi_0.Max_Weight_B := Pesi_0.Min_Weight_B; END_IF
	IF Pesi_0.Max_Weight_A < Pesi_0.Min_Weight_A THEN Pesi_0.Max_Weight_A := Pesi_0.Min_Weight_A; END_IF
	IF Pesi_0.Min_Weight_B < Pesi_0.Max_Weight_A THEN Pesi_0.Min_Weight_B := Pesi_0.Max_Weight_A; END_IF
END_PROGRAM

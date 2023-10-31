
ACTION AuditTrail: 

	
	// Watch for changes in coffee
	IF (CoffeeIngredients.Coffee <> _Coffee) THEN
		MpAuditValueChangeStatus := MpAuditValueChange(gAuditTrail, _Coffee, CoffeeIngredients.Coffee, '100');
		_Coffee 				 := CoffeeIngredients.Coffee;
	END_IF
	
	// Watch for changes in milk
	IF (CoffeeIngredients.Milk <> _Milk) THEN
		MpAuditValueChangeStatus := MpAuditValueChange(gAuditTrail, _Milk, CoffeeIngredients.Milk, '101');
		_Milk 					 := CoffeeIngredients.Milk;
	END_IF
	
	// Watch for changes in sugar
	IF (CoffeeIngredients.Sugar <> _Sugar) THEN
		MpAuditValueChangeStatus := MpAuditValueChange(gAuditTrail, _Sugar, CoffeeIngredients.Sugar, '102');
		_Sugar 					 := CoffeeIngredients.Sugar;
	END_IF
	
	// Watch for changes in water
	IF (CoffeeIngredients.Water <> _Water) THEN
		MpAuditValueChangeStatus := MpAuditValueChange(gAuditTrail, _Water, CoffeeIngredients.Water, '103');
		_Water 					 := CoffeeIngredients.Water;
	END_IF
	
	//Load new recipe set recipe parameters
	IF MpRecipeUIConnect.Recipe.List.SelectedIndex <> _SelectedIndex THEN
		_SelectedIndex := MpRecipeUIConnect.Recipe.List.SelectedIndex;
		MpRecipeUIConnect.Recipe.Load := TRUE;

	END_IF
	
	gCoffeeMainLogic.Refill.Coffee := CoffeeIngredients.Coffee ;
	gCoffeeMainLogic.Refill.Milk := CoffeeIngredients.Milk ;
	gCoffeeMainLogic.Refill.Sugar := CoffeeIngredients.Sugar ;
	gCoffeeMainLogic.Refill.Water := CoffeeIngredients.Water ;

END_ACTION

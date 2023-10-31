
TYPE
	RecipeCreateSteps : 
		( (*Steps for creating recipes*)
		IDLE := 0, (*Idle State *)
		CREATE_1 := 10, (*Create coffee mappRegular*)
		DONE_1 := 11, (*mappRegular was created*)
		CREATE_2 := 20, (*Create coffee mappEspresso*)
		DONE_2 := 21, (*mappEspresso was created*)
		CREATE_3 := 30, (*Create coffee mappCappuccino*)
		DONE_3 := 31, (*mappCappuccino was created*)
		CREATE_4 := 40, (*Create coffee mappMilkCoffee*)
		DONE_4 := 41, (*mappMilkCoffee was created*)
		ALL_DONE := 50 (*All recipes were created*)
		);
	CoffeeIngredientsType : 	STRUCT  (*Main ingredients structure*)
		Milk : INT; (*Amount of milk per cup*)
		Water : INT; (*Amount of water per cup*)
		Sugar : INT; (*Amount of sugar per cup*)
		Coffee : INT; (*Amount of coffee per cup*)
	END_STRUCT;
END_TYPE


TYPE
	typMacStatus : 	STRUCT 
		stop : BOOL;
		man : BOOL;
		running : BOOL;
		auto : BOOL;
		alarm : BOOL;
		mch_on : BOOL;
		commit_cycles : UDINT;
		actual_cycle_nr : UDINT;
		last_cycle_time : UDINT;
		actual_cycle_time : UDINT;
	END_STRUCT;
END_TYPE

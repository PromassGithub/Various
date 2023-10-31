
TYPE
	TONType : 	STRUCT 
		AxisLeft : TON := (PT:=T#3S);
		TakeOutCup : TON := (PT:=T#3S);
		Coffee : TON := (PT:=T#3S);
		AxisRight : TON := (PT:=T#3S);
		Wait : TON := (PT:=T#3S);
		Start : TON := (PT:=T#1S);
		Stop : TON := (PT:=T#1S);
		ExecuteWait : TON := (PT:=T#2S);
		StopButton : TON;
		CoffeeWait : TON;
	END_STRUCT;
	SequencerStateEnum : 
		(
		IDLE,
		MOVE_AXIS_LEFT,
		MOVE_AXIS_RIGHT,
		WAIT,
		COFFEE,
		STOP,
		TAKE_OUT,
		START
		);
	SequencerCommandType : 	STRUCT 
		AxisLeft : MpSequencerCommandType;
		Stop : MpSequencerCommandType;
		TakeOutCup : MpSequencerCommandType;
		Coffee : MpSequencerCommandType;
		AxisRight : MpSequencerCommandType;
		Wait : MpSequencerCommandType;
		Start : MpSequencerCommandType;
		End : MpSequencerCommandType;
	END_STRUCT;
END_TYPE

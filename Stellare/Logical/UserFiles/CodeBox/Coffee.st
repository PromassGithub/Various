//MpCodeBox Program File (http:://www.br-automation.com)
//$Name:Coffee
//$Version:1.00.0
//$CodeType:MpLD
//$Created:2018-04-20 10:34,Anonymous
//$Changed:2018-04-20 10:34,Anonymous
//$Comment:
PROGRAM _INIT
END_PROGRAM
PROGRAM _CYCLIC
NETWORK 1 (* Add your comment here... *)
0[]:CONTACT:NO:StartPos()
1[0]:COIL:D:LampRed()
END_NETWORK
NETWORK 2 (* Add your comment here... *)
0[]:CONTACT:NO:EndPos()
1[0]:COIL:D:LampGreen()
END_NETWORK
END_PROGRAM
//$Sign:-

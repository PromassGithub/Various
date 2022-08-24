
#include <bur/plctypes.h>

#ifdef _DEFAULT_INCLUDES
	#include <AsDefault.h>
#endif

void _CYCLIC ProgramCyclic(void)
{
	// Genero una variabile pulse da 500ms
	if ((glbClock.cpu_time - pulse_500_start_time > 250) && !gPulse_500)
	{
		pulse_500_start_time 	= glbClock.cpu_time;
		gPulse_500  = 1;
	}	
	else if ((glbClock.cpu_time - pulse_500_start_time > 250) && gPulse_500)
	{
		pulse_500_start_time 	= glbClock.cpu_time;
		gPulse_500  = 0;
	}
	
	
	// Genero una variabile pulse da 100ms
	if ((glbClock.cpu_time - pulse_100_start_time > 50) && !gPulse_100)
	{
		pulse_100_start_time 	= glbClock.cpu_time;
		gPulse_100  = 1;
	}	
	else if ((glbClock.cpu_time - pulse_100_start_time > 50) && gPulse_100)
	{
		pulse_100_start_time 	= glbClock.cpu_time;
		gPulse_100  = 0;
	}
	
}


#include <bur/plctypes.h>

#ifdef _DEFAULT_INCLUDES
	#include <AsDefault.h>
#endif

void _INIT ProgramInit(void)
{
	oil_control_enable 			= 1;
	hmi.cmd.hmi_oil_control_en	= 1;
	REPORT						= 1;
}


#include <bur/plctypes.h>

#ifdef _DEFAULT_INCLUDES
	#include <AsDefault.h>
#endif

void _CYCLIC ProgramCyclic(void)
{
	contatore.nome_ricetta3 = memcpy((&contatore.nome_ricetta2),(&contatore.nome_ricetta),sizeof(contatore.nome_ricetta));

	contatore.nome_ricetta2[0] 		= 'R';
	contatore.nome_ricetta2[1] 		= 'P';
	contatore.nome_ricetta2[16] 	= '_';
	contatore.nome_ricetta2[19] 	= '_';
}

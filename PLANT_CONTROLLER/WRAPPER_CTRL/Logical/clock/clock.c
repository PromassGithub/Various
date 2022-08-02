#ifdef _DEFAULT_INCLUDES
 #include <AsDefault.h>
#endif
/*=============================================================================
                      			PROMASS S.r.l.
=============================================================================*/


/******************************************************************************
    INCLUSIONE HEADER FILES
******************************************************************************/

#include <bur\plctypes.h>
#include <string.h>
#include <AsTime.h>  /* libreria 'AsTime' */

/******************************************************************************
    SIMBOLI
******************************************************************************/

#define CHECK_RAM_CODE    0xA7FF252C     /* per la verifica di validità ram */

/******************************************************************************
    STRUTTURE E TIPI LOCALI (UTILIZZATI SOLO IN QUESTO FILE)
******************************************************************************/

/******************************************************************************
    PROTOTIPI DELLE FUNZIONI AUSILIARIE (DEFINITE IN QUESTO FILE)
******************************************************************************/

/******************************************************************************
    VARIABILI _GLOBAL (AUTOMATION STUDIO)
******************************************************************************/

/******************************************************************************
    VARIABILI _LOCAL (AUTOMATION STUDIO)
******************************************************************************/

/******************************************************************************
    VARIABILI GLOBALI (C ANSI)
******************************************************************************/

/******************************************************************************
    MACRO
******************************************************************************/

/******************************************************************************
    FUNZIONE DI INIZIALIZZAZIONE DELLA TASK
******************************************************************************/

void _INIT TaskInit(void)
{
	/* Azzera sempre le _GLOBAL prodotte in questa task */
	memset(&glbClock, 0, sizeof(glbClock));
	memset(&cmdClock, 0, sizeof(cmdClock));


	/* Verifica la validità della RAM dati */
	if(ulCheckRam != CHECK_RAM_CODE)            /* RAM non valida? */
	{
		/* Azzera le _LOCAL ritentive */
		memset(&locClock, 0, sizeof(locClock));

		/* Registra allarme */
		glbClock.alRamData = 1;

		/* Assegna il codice di validazione RAM */
		ulCheckRam = CHECK_RAM_CODE;
	}


	/* Registra l'orario di spegnimento */
	locClock.rtcShutDown = locClock.rtcRuntime; /* leggo il valore dal dato runtime in memoria */

	if(locClock.rtcShutDown == 0) /* Orario errato? */
	{
		/* Sì: registra l'allarme */
		 glbClock.alRtcShutDown = 1;
	}

	/* Richiesta dell'orario di accensione */
	dataGetTime.enable = 1;
	DTGetTime(&dataGetTime);

	if(dataGetTime.status == 0) /* L'orario di sistema è valido? */
	{
		/* Sì: registra l'orario ottenuto */
		locClock.rtcStartUp = dataGetTime.DT1;

	}
	else
	{
		/* No: registra il valore nullo */
		locClock.rtcStartUp = 0;

		/* Registra allarme */
		glbClock.alRtcStartUp = 1;
	}


	/* Calcolo del tempo di spegnimento [secondi] */
	if( (locClock.rtcStartUp != 0)&&(locClock.rtcShutDown != 0) ) /* Orari di accensione e spegnimento validi? */
	{
		/* Sì: calcola il tempo di spegnimento */
		locClock.ulTimePlcOff =  DiffDT(locClock.rtcStartUp, locClock.rtcShutDown);
	}
	else
	{
		/* No: assegna valore nullo */
		locClock.ulTimePlcOff = 0;
	}


	/* Tempo di spegnimento global */
	if( (locClock.ulTimePlcOff != 0)                           &&  /* E' stato possibile calcolare il tempo di spegnimento? */
		(locClock.ulTimePlcOff != 0xFFFFFFFF)                  )   /* Il tempo di spegnimento è sensato (non negativo)?     */
	{
		glbClock.ulTimePlcOff = locClock.ulTimePlcOff;
	}
	else
	{
		glbClock.ulTimePlcOff = 0;
	}


	/* Orari di accensione e spegnimento in forma 'Calendar' (_GLOBAL)  */

	if(locClock.rtcStartUp != 0) /* orario accensione valido? */
	{
		/* Sì: convertilo in 'Calendar' */
		DT_TO_DTStructure(locClock.rtcStartUp, (unsigned long)&glbClock.calStartUp);
	}
	else
	{
		/* No: azzera la struttura 'Calendar' */
		memset((void*)&glbClock.calStartUp, 0, sizeof(glbClock.calStartUp));
	}

	if(locClock.rtcShutDown != 0) /* orario spegnimento valido? */
	{
		/* Sì: convertilo in 'Calendar' */
		DT_TO_DTStructure(locClock.rtcShutDown, (unsigned long)&glbClock.calShutDown);
	}
	else
	{
		/* No: azzera la struttura 'Calendar' */
		memset((void*)&glbClock.calShutDown, 0, sizeof(glbClock.calShutDown));
	}


} /* fine _INIT */


/******************************************************************************
   FUNZIONE CICLICA DELLA TASK
******************************************************************************/

void _CYCLIC TaskCyclic(void)
{

	/*===== RILIEVO COMANDO DI SETTAGGIO "REAL TIME CLOCK" =====*/

	if(cmdClock.bSetClock) /* E' stato richiesto il settaggio? */
	{
		/* azzera i flag  di risposta */
		cmdClock.bOkSet    = 0;
        cmdClock.bErSet    = 0;

        /* converti l'orario in forma 'date time' */
		locClock.rtcSetTime = DTStructure_TO_DT((UDINT) &cmdClock.calSetTime);

		/* richiedi il settaggio del RealTimeClock*/
		dataSetTime.enable = 1;
		dataSetTime.DT1    = locClock.rtcSetTime;
		DTSetTime(&dataSetTime);

		/* verifica l'esito del settaggio e definisci il flag di risposta */
		if(dataSetTime.status == 0)   cmdClock.bOkSet = 1; /* esito positivo */
  		else                          cmdClock.bErSet = 1; /* esito negativo */

  		/* Annulla il comando */
		cmdClock.bSetClock = 0;
	}

	/*===== RILIEVO ORARIO ATTUALE =====*/

	dataGetTime.enable = 1;
	DTGetTime(&dataGetTime);

	if(dataGetTime.status == 0) /* L'orario di sistema è valido? */
	{
		/* Sì: registra l'orario ottenuto */
		locClock.rtcRuntime = dataGetTime.DT1;

	}
	else
	{
		/* No: assegna il valore nullo */
		locClock.rtcRuntime = 0;

		/* Registra l'allarme */
		glbClock.alRtcRuntime = 1;
	}


	/* Orario _GLOBAL */
	glbClock.rtcRuntime = locClock.rtcRuntime;


	/*===== TEMPO DALLO STARTUP [msec] =====*/

	locClock.myTime      = clock_ms(); /* _LOCAL */
	glbClock.cpu_time    = (UDINT)locClock.myTime;

} /* fine _CYCLIC */


/******************************************************************************
   DEFINIZIONE DELLE FUNZIONI AUSILIARIE
******************************************************************************/



#include <bur/plctypes.h>
#include <string.h>

#ifdef _DEFAULT_INCLUDES
#include <AsDefault.h>
#endif

void _INIT RPT_CSV_Init(void)
{
	/* Pulisco la memoria */
	memset (&DirCreate_03,			 0, sizeof(DirCreate_typ)   );
	memset (&DirCreate_05,			 0, sizeof(DirCreate_typ)   );
	memset (&FileCreate_01,          0, sizeof(FileCreate_typ)  );
	memset (&FileCreate_03,          0, sizeof(FileCreate_typ)  );
	memset (&FileOpen_03,            0, sizeof(FileOpen_typ)    );
	memset (&FileWrite_01,           0, sizeof(FileWrite_typ)   );
	memset (&FileWrite_03,           0, sizeof(FileWrite_typ)   );
	memset (&FileClose_01,           0, sizeof(FileClose_typ)	);
	memset (&FileClose_03,           0, sizeof(FileClose_typ)	);
	memset (string_rpt,				'\0', 	sizeof(string_rpt)  	);
	memset (support_str,			'\0', 	sizeof(support_str)    );
	step_rpt = WAIT;
	RowCounterFile				= 0;

	DirCreate_03.enable  = 1;
	DirCreate_03.pDevice = (UDINT) "CF";
	DirCreate_03.pName   = (UDINT) "DATA";

	DirCreate(&DirCreate_03);

	if ((DirCreate_03.status == 0) ||  (DirCreate_03.status == 20725))	    /* if status ok (0) or dir already exists (20725)		 		*/
	{
		DirCreate_03.status = 0;															/* set status ok											*/
	}
	
	
	DirCreate_05.enable  = 1;
	DirCreate_05.pDevice = (UDINT) "CF";
	DirCreate_05.pName   = (UDINT) "CFG";

	DirCreate(&DirCreate_05);

	if ((DirCreate_05.status == 0) ||  (DirCreate_05.status == 20725))	    /* if status ok (0) or dir already exists (20725)		 		*/
	{
		DirCreate_05.status = 0;															/* set status ok											*/
	}
//	rt_info.enable = 1;     /* enables the function */
//	RTInfo(&rt_info);       /* gets information from the software object */
//	sys_info.enable = 1;    /* enables the function */
//	SysInfo(&sys_info);     /* gets information from the system */
}


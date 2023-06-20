 /*
--------------------------------------------- Recipe library V 2.04 , March 2008	-------------------------------------------------------------------
*/

/* V 2.01 - MD aggiunto pin device per selezionare directory su CF													*/
/* V 2.02 - MD aggiunti step per free_mem su error in Rec_write e Rec_upload										*/
/* V 2.03 - AC eliminato pin device per selezionare directory su CF													*/
/* V 2.04 - AC correzione algoritmo deallocazione memoria in caso di errore su funzioni Rec_Write e Rec_Upload		*/




/* ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::	*/
/*															    I N C L U D E S																	*/
/* ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::	*/
#ifdef _DEFAULT_INCLUDES
 #include <AsDefault.h>
#endif

#include <recipe.h>											/* user library																		*/
#include <sys_lib.h>										/* system library																	*/
#include <asstring.h>										/* system library																	*/
#include <string.h>											/* system library																	*/
#include <asmem.h>											/* system library																	*/
#include <astime.h>											/* system library																	*/

/* ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::	*/
/*																C O N S T A N T S																*/
/* ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::	*/
#define P_INIT_DEVICE			"CF"						/* as configured in "cpu->properties->file devices"									*/
#define P_DEVICE				"CF_RECIPES"				/* as configured in "cpu->properties->file devices"									*/
#define P_USB1					"DEVICE1"					/* as configured in "cpu->properties->file devices"									*/
#define P_USB2					"USB2"						/* as configured in "cpu->properties->file devices"									*/
#define CHR_SEPAR				';'							/* separator char in csv file														*/
#define DEEP_STR 				15 							/* it must be <= to array dimension of variables: dim, cnt_dim, flag_arr_str, cnt_arr_str */
#define LENGTH_RECIPE_NAMES		30
#define	LENGTH_CSV_NAMES		(LENGTH_RECIPE_NAMES+4)		/* LENGTH_RECIPE_NAMES + ".csv"														*/


#define	READ_BUFFER				300							/* max single row length in csv file (length in characters)							*/
#define MAX_ROW_ALLOC			1000						/* max number of row (in csv file) 													*/
#define TOTAL_MEMORY_ALLOC		(READ_BUFFER*MAX_ROW_ALLOC) /* total allocated memory															*/


#define p_usr_data	   ((USINT  *) inst->do_info.pDatObjMem)/* used to point to comments' data module characters								*/


/* ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::	*/
/*																	M A C R O 																	*/
/* ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::	*/

#define SET_ERROR(err_code)	{\
				inst->prevstep  = inst->step;\
				inst->step 		= 100;\
				inst->status    = err_code;\
				Rec_Write_err_msg(inst->msg_err, err_code, inst->prevstep);\
}




#define ASCII_TO_VAL(datatype, val, addr)	{																					\
	switch (datatype)																											\
	{																															\
		case PB_DT_BOOL:          /* 1        boolean 				*/															\
			if   (val[0] == '0')  	*(BOOL*) addr = 0;		/* get num value from the string */									\
			else 					*(BOOL*) addr = 1;		/* get num value from the string */									\
			break;																												\
																																\
		case PB_DT_INT8:          /* 2        integer8 				*/															\
			* (SINT* )  addr = atoi((UDINT) &val[0]); 		/* get num value from the string */									\
			break;																												\
																																\
		case PB_DT_BYTE:          /* 5        unsigned integer8 	*/															\
			* (USINT* ) addr = atoi((UDINT) &val[0]); 		/* get num value from the string */									\
			break;																												\
																																\
		case PB_DT_INT16:         /* 3        integer16				*/															\
			* (INT* )   addr = atoi((UDINT) &val[0]); 			/* get num value from the string */								\
			break;																												\
																																\
		case PB_DT_WORD:          /* 6        unsigned integer16	*/															\
			* (UINT* )  addr  = atoi((UDINT) &val[0]); 		/* get num value from the string */									\
			break;																												\
																																\
		case PB_DT_INT32:         /* 4        integer32 			*/															\
			* (DINT* )  addr = atoi((UDINT) &val[0]); 		/* get num value from the string */									\
			break;																												\
																																\
		case PB_DT_LONG :         /* 7        unsigned integer32 	*/															\
			* (UDINT* ) addr = atoi((UDINT) &val[0]); 		/* get num value from the string */	     							\
		break;																													\
																																\
		case PB_DT_FLOAT:         /* 8        floating point 		*/															\
			* (REAL *) addr  = atof ((UDINT) &val[0]);		/* get num value from the string */	 								\
			break;																												\
																																\
		case PB_DT_VIS:           	/* 9        visible string 		*/															\
			strcpy((USINT *) addr, &val[0]);																					\
			break;											/* get string from the string 	 */	 								\
																																\
		default:																												\
			/* return */																										\
			break;																												\
																																\
	} /* end switch (inst->var_data_type)*/																						\
}

#define VAL_TO_ASCII(datatype,ascii_val, addr)	{																			  	\
        memset(&ascii_val, 0, sizeof(ascii_val));                                                                               \
	switch (datatype)																									  		\
	{																														  	\
		case PB_DT_BOOL:          /* 1        boolean 				*/														  	\
			if   (* (BOOL*) (addr) == 1)				ascii_val[0] = '1';													  	\
			else 										ascii_val[0] = '0';											  			\
			break;																											  	\
																															  	\
		case PB_DT_INT8:          /* 2        integer8 				*/														  	\
			inst->gs.len= itoa(* (SINT*) (addr), (UDINT) &ascii_val); /*write int value in string	*/			  				\
			break;																											  	\
																															  	\
		case PB_DT_BYTE:          /* 5        unsigned integer8 	*/														  	\
			inst->gs.len= itoa(* (USINT*) (addr), (UDINT) &ascii_val); /*write int value in string	*/			  				\
			break;																											  	\
																															  	\
		case PB_DT_INT16:         /* 3        integer16				*/														  	\
			inst->gs.len= itoa(* (INT*) (addr), (UDINT) &ascii_val); /*write int value in string	*/			  				\
			break;																											  	\
																															  	\
																															  	\
		case PB_DT_WORD:          /* 6        unsigned integer16	*/														  	\
			inst->gs.len= itoa(* (UINT*) (addr), (UDINT) &ascii_val); /*write int value in string	*/			  				\
			break;																											  	\
																															  	\
																															  	\
		case PB_DT_LONG :         /* 7        unsigned integer32 	*/														  	\
			inst->gs.len= itoa(* (UDINT*) (addr), (UDINT) &ascii_val); /*write int value in string	*/			  				\
			break;																											  	\
																															  	\
		case PB_DT_INT32:         /* 4        integer32 			*/														  	\
			inst->gs.len= itoa(* (DINT*) (addr), (UDINT) &ascii_val); /*write int value in string	*/			  				\
			break;																											  	\
																															  	\
		case PB_DT_FLOAT:         /* 8        floating point 		*/														  	\
			inst->gs.len= ftoa(* (REAL*) addr, (UDINT) &ascii_val); 	/* write real value in string 	*/		  				\
			break;																											  	\
																															  	\
		case PB_DT_VIS:           /* 9        visible string 		*/														  	\
			strcpy(&ascii_val[0], (USINT *) (addr));														  					\
			break;																											  	\
																															  	\
		default:																											  	\
			/*return;*/																										  	\
			break;																											  	\
	}																														  	\
}



/* ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::	*/
/*																P R O T O T Y P E S 															*/
/* ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::	*/
void clear		       (USINT *str, USINT car);
void Rec_Write_err_msg (USINT p_chr[80], UINT status, UINT prevstep);
void Get_value	       (Rec_Write_typ* inst);




/*______________________________________________________________________________________*/
/*																						*/
/*	Function:	:	Rec_get_comm()														*/
/*	File name	:	recipe.c															*/
/*	Version		:	2.00																*/
/*	Date		:	18.01.2005															*/
/*	Author		:	Alessandro Cazzola													*/
/*	Description	:	it gives comments (row of datamodule "comments"						*/
/*                  This function is internal: it doesn't compare in the library		*/
/*	Changes		:   added "enable" input, name changed in "Rec_get_comm()"				*/
/*______________________________________________________________________________________*/
 void Rec_get_comm(Rec_get_comm_typ *inst)
{
	if (inst->enable == 0)
	{
		memset (&inst->do_info , 0, sizeof(inst->do_info));
		memset (&inst->comm[0] , 0, sizeof(inst->comm)   );
		inst->step 			= 0;
		inst->k 			= 0;
		inst->j 			= 0;
		inst->start 		= 0;
		inst->count_comm	= 0;
		inst->prevstep 		= 0;
		return;
	}

	switch (inst->step)
	{
		case 0:
			inst->status          = 65535;										/* set fub busy											*/
			inst->do_info.enable  = 1;											/* enable DatObjInfo									*/
		 	inst->do_info.pName	  = (UDINT) "comments";							/* data module name to search							*/
		 	DatObjInfo(&inst->do_info);											/* call fub												*/

		 	if (inst->do_info.status == 0)										/* if status ok...										*/
		 	{
		 		inst->j=0;														/* reset index (to point to data module characters)		*/
				memset (&inst->comm[0], 0, sizeof(inst->comm));					/* reset string											*/

				for (inst->k = inst->start; (p_usr_data[inst->k]!= (STRING) 0); inst->k++)
			 	{
			 		inst->comm[inst->j] = p_usr_data[inst->k];					/* get string											*/
			 		inst->j++;													/* */
			 	}
			 	inst->start = inst->start+inst->j + 1;							/* next string will start at this index					*/

			 	if (p_usr_data[inst->k] == (STRING) 0)							/* if end-of-string...									*/
			 	{
					inst->comm[inst->j] = p_usr_data[inst->k];					/* ...copy end-of-string char							*/
					inst->count_comm++;											/* increment comments (strigns) counter					*/
			 		inst->status = 1;											/* set status: other rows (comments) present			*/
			 	}
			 	if ((p_usr_data[inst->k + 1] == (STRING) 0) || (p_usr_data[inst->k + 1] == (STRING) 43) )	/* end of file 	*/
			 	{
			 		inst->status = 0;											/* ...end 												*/
			 		inst->step   = 1;											/* reset status											*/
			 	}
		 	}
		 	else
		 	{
				if (inst->do_info.status == doERR_MODULNOTFOUND)				/* if data module with comments not found...			*/
				{
					inst->status = 0;											/* ...end 												*/
					memset (&inst->comm[0], 0, sizeof(inst->comm));				/* reset string											*/
					inst->comm[0] = '/';										/* if no other comments present put a '/' as comment 	*/
					inst->step   = 1;											/* set always a '/' as comment (2nd column of csv file	*/
				}
				else															/* any other error code is an error	for this function	*/
				{
		 			inst->prevstep  = inst->step;								/* remember the step									*/
					inst->step 		= 100;										/* go to error speed									*/
					inst->status    = inst->do_info.status;						/* copy in output status								*/
		 		}
		 	}
		break;


		case 1:
			memset (&inst->comm[0], 0, sizeof(inst->comm));						/* reset status											*/
			inst->comm[0] = '/';												/* if no other comments present put a '/' as comment 	*/
		break;


		case 100:
			/* error step */
		break;

	} /* end swtitch (inst->step) */

} /* end Rec_get_comm() */



/*______________________________________________________________________________________*/
/*																						*/
/*	Function:	:	Rec_Init()															*/
/*	File name	:	recipe.c															*/
/*	Version		:	2.00																*/
/*	Date		:	01.12.2004															*/
/*	Author		:	Alessandro Cazzola													*/
/*	Description	:	- partition creation (for AsMemPartAlloc used in Rec_Write)			*/
/*					- check if recipes dir exists (if not it's created)					*/
/*	Changes		:   /																	*/
/*______________________________________________________________________________________*/
void Rec_Init(Rec_Init_typ *inst)
{

	if (inst->enable == 0)
	{
		inst->step 		= 0;
		memset(&inst->dir_create , 0, sizeof(inst->dir_create ));
		memset (&inst->mem_part_create , 0, sizeof(inst->mem_part_create));
		inst->prevstep 	= 0;
		inst->status 	= 0;
		strcpy (&inst->msg_err[0], (STRING) 0);
		inst->ident 	= 0;
		return;
	}

	inst->status = 65535;

	switch (inst->step)
	{

												/* ========================================================	*/
												/*				    CREATE MEMORY PARTITION					*/ /* NEW V2.00 */
												/* ========================================================	*/
		case 0:
			inst->mem_part_create.enable = 1;												/* enable fub												*/
	 		inst->mem_part_create.len 	 = TOTAL_MEMORY_ALLOC + 300;						/* alloc memory (important overhead = 300)					*/
		 	AsMemPartCreate(&inst->mem_part_create);										/* call fub													*/
		 	if (inst->mem_part_create.status == 0)											/* if status ok...											*/
		 	{
		 		inst->step = 1;																/* ...go to next step										*/
		 	}
		 	else																			/* if status not ok...										*/
		 	{
		 		SET_ERROR(inst->mem_part_create.status);									/* ...go to error step										*/
		 	}
		break;

												/* ========================================================	*/
												/*			 CHECK DIRECTORY "RECIPE" EXISTENCE				*/
												/* ========================================================	*/

		case 1:
			inst->dir_create.enable 	= 1;												/* enable fub												*/
			inst->dir_create.pDevice	= (UDINT) P_INIT_DEVICE;							/* set device												*/

			inst->dir_create.pName 		= (UDINT) "recipes";								/* create dir "recipe"										*/
			DirCreate(&inst->dir_create);													/* call fub													*/
			if ((inst->dir_create.status == 0) ||  (inst->dir_create.status == 20725))	    /* if status ok (0) or dir already exists (20725)		 		*/
			{
				inst->status = 0;															/* set status ok											*/
				inst->ident  = inst->mem_part_create.ident;									/* save ident												*/
			}
			else if (inst->dir_create.status != 65535)										/* if fub not ok and not busy...							*/
			{
				SET_ERROR(inst->dir_create.status);											/* ...go to error step										*/
			}
		break;

												/* ========================================================	*/
												/*         				ERROR STEP							*/
												/* ========================================================	*/
		case 100:
			/* function in error, it has to be called with enable = 0 in order to reset it */
		break;
	}

} /*  end *Rec_Init() */




/*______________________________________________________________________________________*/
/*																						*/
/*	Function:	:	Rec_NameRead()														*/
/*	File name	:	recipe.c															*/
/*	Version		:	2.00																*/
/*	Date		:	18.01.2005															*/
/*	Author		:	B&R																	*/
/*	Description	:	get recipes' single name, total_rec is the total number of recipes	*/
/*                  file_cntr is the actual, in order to have all names the function	*/
/*                  has to be called "total_rec" times 									*/
/*				    status: 0 */
/*						    1 */
/*							2 */
/*							3 */
/*	Changes		:   /																	*/
/*______________________________________________________________________________________*/

void Rec_NameRead(Rec_NameRead_typ *inst)
{
	if (inst->enable == 0)
	{
		inst->step 		    = 0;
		inst->set_device  	= 0;
		memset(&inst->DInfo   , 0, sizeof(inst->DInfo));
		memset(&inst->DRead   , 0, sizeof(inst->DRead));
		memset(&inst->ReadData, 0, sizeof(inst->ReadData));
		inst->get_sys_err 	= 0;
		inst->prevstep 	   	= 0;
		inst->tot_files 	= 0;
		inst->file_counter 	= 0;
		inst->len_name      = 0;
		strcpy (inst->recipe, "");
		inst->status        = 0;
		strcpy (inst->msg_err, "");
		inst->not_valid_csv  = 0;
		inst->nr_csv_read    = 0;
		return;
	}


	switch (inst->step)
	{

		case 0:
			memset(&inst->DInfo   , 0, sizeof(inst->DInfo));								/* reset internal structure									*/
			memset(&inst->DRead   , 0, sizeof(inst->DRead));								/* reset internal structure									*/
			memset(&inst->ReadData, 0, sizeof(inst->ReadData));								/* reset internal structure									*/
			strcpy (inst->recipe, "");														/* reset output												*/
			inst->get_sys_err 	= 0;														/* reset internal variable									*/
			inst->prevstep 	   	= 0;														/* reset internal variable									*/
			inst->file_counter  = 0;														/* reset internal variable									*/
			inst->len_name      = 0;														/* reset internal variable									*/
			inst->nr_csv_read   = 0;														/* reset internal variable									*/

			inst->status = 65535;															/* set fub busy												*/
			/* MD 1/12/2005 */
		/*	if (inst->set_device == 0)
			{
				inst->DInfo.pDevice	= (UDINT) &(inst->device);								 device: compact flash
			}	*/
			if (inst->set_device == 0)	inst->DInfo.pDevice	= (UDINT) P_DEVICE;				/* device: compact flash									*/
			if (inst->set_device == 1)	inst->DInfo.pDevice	= (UDINT) P_USB1;				/* device: USB 1											*/
			inst->tot_files   = 0;
			strcpy(inst->recipe, "");														/* reset recipe name										*/
			inst->step 		    = 1;
		break;

		case 1:
			inst->DInfo.enable 	= 1;														/* enable fub												*/
			inst->DInfo.pPath 	= 0;														/* path 0													*/
			DirInfo(&inst->DInfo);															/* call fub													*/

			if (inst->DInfo.status == 0)													/* if status ok...											*/
			{
				inst->DRead.pDevice		= (UDINT) inst->DInfo.pDevice;						/* set for DRead() device the same as DirInfo() 				*/
				inst->tot_files	        = inst->DInfo.filenum;								/* put in output the total files							*/
				if (inst->tot_files >= 1)													/* if there's at least one file...							*/
				{
					inst->step = 2;															/* ...go to next step										*/
				}
				else																		/* if there isn't any file...								*/
				{
					inst->status = 0;														/* set status ok...(no operation performed)					*/
				}
			}
			else if((inst->DInfo.status == 20723)||(inst->DInfo.status == 20709 /*OS 2.71*/))/* maybe usb key inserted in port usb 2				 	*/
			{
				if (inst->DInfo.pDevice	== (UDINT) P_USB1)
				{
					inst->DInfo.pDevice	= (UDINT) P_USB2;
				}
				else if (inst->DInfo.pDevice	== (UDINT) P_USB2)
				{
					SET_ERROR(inst->DInfo.status);
				}
			}
			else if (inst->DInfo.status  != 65535)											/* if status not ok and fub not busy...						*/
			{
				if (inst->DInfo.status  == 20799)											/* ...if general error occurred								*/
				{
					inst->get_sys_err = FileIoGetSysError();								/* ... get code error										*/
				}
				SET_ERROR(inst->DInfo.status);												/* go to error step											*/
			}
		break;


		case 2:
			inst->status 			= 65535;												/* set fub busy												*/
			strcpy(inst->recipe, "");														/* reset recipe name										*/
			inst->DRead.enable 		= 1;													/* enable fub												*/
			inst->DRead.pPath 		= 0;													/* path 0													*/
			inst->DRead.entry 		= inst->file_counter;									/* set actual index to scan all files present					*/
			inst->DRead.option 		= FILE_FILE;											/* select option											*/
			inst->DRead.pData 		= (UDINT) &inst->ReadData;								/* data buffer												*/
			inst->DRead.data_len 	= sizeof (inst->ReadData);								/* size of buffer											*/
			DirRead(&inst->DRead);															/* call fub													*/

			if (inst->DRead.status == 0)													/* if status ok...											*/
			{
				inst->file_counter ++;														/* ...increment index to scan all files present				*/

				inst->len_name = strlen(&inst->ReadData.Filename[0]);						/* get legth of file name									*/

				if (																		/* check if csv extension exists...							*/
					((inst->ReadData.Filename[inst->len_name - 1] == 'v') || (inst->ReadData.Filename[inst->len_name - 1] == 'V'))	&&
					((inst->ReadData.Filename[inst->len_name - 2] == 's') || (inst->ReadData.Filename[inst->len_name - 2] == 'S'))	&&
					((inst->ReadData.Filename[inst->len_name - 3] == 'c') || (inst->ReadData.Filename[inst->len_name - 3] == 'C'))
				   )
				{
					if (inst->len_name <= (LENGTH_CSV_NAMES - 1))
					{
						memcpy (&inst->recipe[0], &inst->ReadData.Filename[0], sizeof(inst->recipe));/* get file name (with csv extension)				*/
						clear(&inst->recipe[0],'.');										/* show file name without extension ".csv" 					*/
						inst->status        = 1;											/* other files are present									*/
						inst->not_valid_csv = 0; 											/* at the moment set csv as valid							*/
						inst->nr_csv_read++;
					}
					else
					{
						inst->file_counter ++;												/* ignore this file and update the index					*/
						inst->not_valid_csv = 1; 											/* notify warning: file not imported due name too long			*/
					}
				}
				else																		/* if csv extension doesn't exist...						*/
				{
					inst->file_counter ++;													/* ignore this file and update the index					*/
					inst->not_valid_csv = 2; 												/* notify warning: file not imported due name too long			*/						}
			}
			else if (inst->DRead.status != 65535)											/* if status not ok and fub not busy...						*/
			{
				if (inst->DRead.status == 20799)											/* ...if general error occurred								*/
				{
					inst->get_sys_err = FileIoGetSysError();								/* ... get code error										*/
				}
				SET_ERROR(inst->DRead.status);												/* go to error step											*/
			}

		if (inst->file_counter >= inst->tot_files)											/* if all files scanned...									*/
		{
			inst->step = 3;																	/* ...go to end step										*/
		}
		break;


		case 3:
			inst->status 	  = 0;															/* reset status (ok)								 		*/
			inst->step        = 0;															/* return to init state 									*/
		break;


		case 100:
				/* function in error, it has to be called with enable = 0 in order to reset it */
		break;
	}

} /* end Rec_NameRead() */




/*______________________________________________________________________________________*/
/*																						*/
/*	Function:	:	Rec_Delete()														*/
/*	File name	:	recipe.c															*/
/*	Version		:	2.00																*/
/*	Date		:	18.01.2005															*/
/*	Author		:	B&R																	*/
/*	Description	:	it deletes a single recipe											*/
/*	Changes		:   /																	*/
/*______________________________________________________________________________________*/

void Rec_Delete(Rec_Delete_typ *inst)
{
	if (inst->enable == 0)
	{
		strcpy(inst->recipecsv, "");
		inst->step		     = 0;
		memset(&inst->FDelete, 0 ,sizeof(inst->FDelete));
		inst->get_sys_err    = 0;
		inst->prevstep		 = 0;
		inst->status		 = 0;
		strcpy(inst->msg_err, "");
		return;
	}


	switch (inst->step)
	{
												/* ========================================================	*/
												/*         				DELETE STEP							*/
												/* ========================================================	*/

		case 0:
			inst->status = 65535;														/* set fub busy												*/
			strcpy(&inst->recipecsv[0], &inst->recipe[0]);								/* copy recipe name											*/
			strcat(&inst->recipecsv[0], ".csv"          );								/* strcat csv extension										*/

			inst->FDelete.enable 	= 1;												/* enable fub												*/

			/*MD 1/12/2005*/
			/* inst->FDelete.pDevice = (UDINT) &(inst->device);							 pointer to device						 				*/

			inst->FDelete.pDevice = (UDINT) P_DEVICE;									/* set device: compact flash									*/
			inst->FDelete.pName 	= (UDINT) inst->recipecsv;							/* set file name to delete									*/
			FileDelete(&inst->FDelete);													/* call fub													*/

			if (inst->FDelete.status == 0)												/* if status ok...											*/
			{
				inst->status = 0;														/* ...set status ok											*/
			}
			else if (inst->FDelete.status  != 65535)									/* if status not ok and fub not busy...						*/
			{
				if (inst->FDelete.status   == 20799)									/* ...if general error occurred								*/
				{
					inst->get_sys_err = FileIoGetSysError();							/* ... get code error										*/
				}
				SET_ERROR(inst->FDelete.status );										/* go to error step											*/
			}
		break;

												/* ========================================================	*/
												/*         				ERROR STEP							*/
												/* ========================================================	*/
		case 100:
				/* function in error, it has to be called with enable = 0 in order to reset it */
		break;
	}

} /* end Rec_Delete() */





/*______________________________________________________________________________________*/
/*																						*/
/*	Function:	:	Rec_Write()															*/
/*	File name	:	recipe.c															*/
/*	Version		:	2.00																*/
/*	Date		:	01.12.2004															*/
/*	Author		:	Alessandro Cazzola													*/
/*	Description	:	write data from struct into a (txt or csv) file    					*/
/*	Changes		:   /																	*/
/*______________________________________________________________________________________*/
/*

	The function writes the names of the variables in column, on the right of each variable the value is placed, so the file appears as
	(CR is Carriage Return):

	var1.field1;10;30;50 CR
	var1.field2;20;40;80 CR

	Every variable could reach 14 sublevels, so it's possible to have: a.b.c.d.e.f.g.h.i.j.l.m.n.o.p (limit given by variable declaration,
	it not depends by the algorithm used).
	To create the names levels and dimemsions for each level have to be considered (see "Examples" below).
	When the variable name is available then it's possible to know the value with B&R function libraries (PV_xgetadr and PV_ninfo)

	The names are created (and written with their values) into the file only if the file doesn't exist; this is performed in the steps:
	STEP_WST_INFO_DATA
	STEP_WST_GET_DATA
	STEP_WST_WRITE_NAME

	If the file exits the names are already available: every name is simply read; this is performed from the step
	STEP_WST_CREATE_TEMP
	ahead.

	Examples
						Example nr.1										|							Example nr.2
																			|
	 typedef struct                         typedef struct					| typedef struct 		  typedef struct
	 {										{								| {						  {
	 	USINT	a;								UINT	d;					|	USINT	a;				UINT	d;
	 	UINT	b;								UINT	e;					|	t_subs	b[2];			UINT	e;
	 	t_subs  c;							} t_subs;						|						  } t_subs;
	 } t_str																| } t_str
	 																		|
	 																		|
				str              ---------> level 0, dim[0] = 3				|		str					   ---------> level 0, dim[0] = 2
				/|\															|		/ \
			   / | \														|	   /   \
			  /  |  \														|	  /     \
			 a   b   c 			 ---------> level 1, dim[1] = 1,1 and 2     |     a	     b				   ---------> level 1, dim[1] = 1 and 2
	  		   	    / \														|			/ \
	  		   	   /   \													|		   /   \
				  d     e        ---------> level 2, dim[2] = 1 and 1	    |		b[0]    b[1]           ---------> level 2, dim[2] = 2 and 2
			     			  												|	   / \      / \
																			|	  d   e	   d   e	       ---------> level 3, dim[3] = 1, 1, 1 and 1
*/


void Rec_Write(Rec_Write_typ* inst)
{

	#define DEEP_STR 		15 /* it must be equal to array dimension of variables: dim, cnt_dim, flag_arr_str, cnt_arr_str */


	/* Rec_Write() steps */
	#define STEP_WST_INIT						0
	#define STEP_WST_ALLOC						5 		/* NEW V2.00 */
	#define STEP_WST_OPEN						10
	#define STEP_WST_INFO_DATA					15
	#define STEP_WST_WRITE_DATA					20
	#define STEP_WST_CREATE						25
	#define STEP_WST_CLOSE						30
	#define STEP_WST_FILE_EXIST					35
	#define STEP_WST_FREE_MEMORY				40		/* NEW V2.00 */
	#define STEP_WST_FREE_MEM_ERR_CAUSE			99		/* NEW V2.04 */
	#define STEP_WST_ERROR 						100

	#define BUFFER(offset)						(*((USINT *)(inst->mem_part_all.mem + offset)))

	/* NEW V2.04 */
	#define SET_ERROR_WRITE(err_code)	{\
				inst->prevstep  	= inst->step;\
				inst->step 			= STEP_WST_FREE_MEM_ERR_CAUSE;\
				inst->tmp_status    = err_code;\
				Rec_Write_err_msg(inst->msg_err, err_code, inst->prevstep);\
	}


	if (inst->enable == 0)
	{
		strcpy(inst->recipecsv, "");
		inst->firstrow_written	   = 0;
		inst->step				   = 0;
		inst->k					   = 0;
		inst->fileio_id			   = 0;
		inst->offset			   = 0;
		memset(&inst->gs       , 0, sizeof(inst->gs));
		memset(&inst->get_comm , 0, sizeof(inst->get_comm));
		memset(&inst->FOpen	   , 0, sizeof(inst->FOpen));
		memset(&inst->FClose   , 0, sizeof(inst->FClose));
		memset(&inst->FCreate  , 0, sizeof(inst->FCreate));
		memset(&inst->FWrite   , 0, sizeof(inst->FWrite));
		memset(&inst->FDelete  , 0, sizeof(inst->FDelete));
		inst->get_sys_err		   = 0;
		inst->prevstep			   = 0;
		inst->status			   = 0;
		strcpy(inst->msg_err, "");
		inst->repeat_switch		   = 0;
		memset(&inst->mem_part_all  , 0, sizeof(inst->mem_part_all));
		inst->mem_allocated = 0;
		memset(&inst->mem_part_free , 0, sizeof(inst->mem_part_free));
		inst->limit_repeat_cntr    = 0;
		inst->tmp_status = 0;
		return;
	}


	do
	{
		inst->repeat_switch = 0;											/* disable do-while statement								*/
		switch (inst->step)
		{
												/* ========================================================	*/
												/*						 INIT STEP							*/
												/* ========================================================	*/
			case STEP_WST_INIT:
				inst->status     = 65535;									/* set fub busy												*/
				inst->gs.idx_lev = 0;										/* reset level-index of structure (recipe)					*/
				inst->chr_separ  = CHR_SEPAR;								/* set character separator (usual ";" fo csv files)			*/
				strcpy(&inst->recipecsv[0], &inst->recipe[0]);				/* copy recipe name											*/
				strcat(&inst->recipecsv[0], ".csv"          );				/* strcat csv extension										*/
				strcpy(&inst->gs.name[0], &inst->structure[0]);				/* copy name of structure									*/
				memset (&(inst->get_comm), 0, sizeof (Rec_get_comm_typ));	/* reset comment's buffer 									*/
				inst->step    = STEP_WST_ALLOC;								/* go to next step											*/
			break;


												/* ========================================================	*/
												/*				       MEMORY ALLOCATION					*/ /* NEW V2.00 */
												/* ========================================================	*/

			case STEP_WST_ALLOC:
				inst->mem_part_all.enable 	= 1;								/* enable fub											*/
				inst->mem_part_all.ident  	= inst->ident;       				/* set ident											*/
				inst->mem_part_all.len	 	= TOTAL_MEMORY_ALLOC;				/* length of memory 									*/
				AsMemPartAlloc(&inst->mem_part_all);							/* call fub												*/
				if (inst->mem_part_all.status == 0)								/* if status ok...										*/
				{
					inst->step = STEP_WST_OPEN;									/* ...go to step in order to open the file				*/
					inst->mem_allocated = 1;									/* memry allocated flag									*/
					strcpy( (USINT *) inst->mem_part_all.mem, "");
				}
				else															/* if status not ok...									*/
				{
					SET_ERROR(inst->mem_part_all.status);						/* ...go to error step									*/
				}
			break;


												/* ========================================================	*/
												/*						 OPEN FILE							*/
												/* ========================================================	*/
			case STEP_WST_OPEN:
				inst->FOpen.enable 	= 1;										/* enable fub											*/

				/*MD 1/12/2005*/
				/*inst->FOpen.pDevice = (UDINT) &(inst->device);					 pointer to device					 				*/

				inst->FOpen.pDevice = (UDINT) P_DEVICE;							/* pointer to device (see CPU properties)				*/
				inst->FOpen.pFile   = (UDINT) inst->recipecsv;					/* file name											*/
				inst->FOpen.mode 	= FILE_RW; 									/* read and write access 								*/
				FileOpen(&inst->FOpen);											/* call fub												*/

				inst->fileio_id      = inst->FOpen.ident;						/* get ident											*/

				if (inst->FOpen.status== 20708)									/* if file not present on device...						*/
				{
					inst->step = STEP_WST_CREATE;								/* ...it has to be created								*/
				}
				else if (inst->FOpen.status== 0)								/* else if it is present on device...					*/
				{
					inst->step = STEP_WST_FILE_EXIST;							/* ...ask if you want overwrite 						*/
				}
				else if (inst->FOpen.status!= 65535)							/* in any other case and fub not busy...				*/
				{
					SET_ERROR_WRITE(inst->FOpen.status);						/* ...go to error step									*/
				}
			break;


												/* ========================================================	*/
												/*         				CREATE FILE							*/
												/* ========================================================	*/
			case STEP_WST_CREATE:
				inst->FCreate.enable 	= 1;									/* enable fub											*/

				/*MD 1/12/2005*/
				/*inst->FCreate.pDevice = (UDINT) &(inst->device);				 pointer to device					 				*/

				inst->FCreate.pDevice 	= (UDINT) P_DEVICE;						/* pointer to device (see CPU properties)				*/
				inst->FCreate.pFile     = (UDINT) &inst->recipecsv;				/* file name											*/
				FileCreate(&inst->FCreate);										/* call fub												*/

				inst->fileio_id = inst->FCreate.ident;							/* get ident											*/

				if (inst->FCreate.status == 0)									/* if status ok...										*/
				{
					/* ----------------------------------------- add first row in buffer ------------------------------------------------ */
					inst->offset 	= 0;												/* reset index in buffer						*/
					strcpy ((USINT *)inst->mem_part_all.mem + inst->offset, "APPLICATION VAR    ;COMMENT    ; VALUE    ;");
					inst->offset = strlen((USINT *) inst->mem_part_all.mem);			/* calculate actual buffer legth				*/
					BUFFER(inst->offset    ) = 13;										/* put carriage return 							*/
					BUFFER(inst->offset + 1) = 10; 										/* put line feed 								*/
		 			inst->offset = inst->offset + 2;									/* calculate actual buffer legth				*/
					/* ------------------------------------------------------------------------------------------------------------------ */

					inst->step = STEP_WST_INFO_DATA;
				}
				else if (inst->FCreate.status != 65535)
				{
					SET_ERROR_WRITE(inst->FCreate.status);
				}
			break;

												/* ========================================================	*/
												/*				   GET INFO ABOUT DATA TYPE					*/
												/* ========================================================	*/
			case STEP_WST_INFO_DATA:

				inst->gs.st_ninfo = PV_ninfo (&inst->gs.name[0], &inst->gs.data_typ, &inst->gs.var_len, &inst->gs.dim[inst->gs.idx_lev]);/*nr structure's elements*/

				if (inst->gs.st_ninfo == 0)																				/* if returned value ok...			*/
				{
					switch (inst->gs.data_typ)
					{
						case 0:																							/* if data type is a "structure"		*/

							inst->gs.st_item  = PV_item(&inst->gs.name[0], inst->gs.cnt_dim[inst->gs.idx_lev], &inst->gs.field[0]);/* get field name			*/
							strcat(&inst->gs.name[0], ".");																/* strcat "." after struct name		*/
							strcat(&inst->gs.name[0], &inst->gs.field[0]);												/* strcat field name				*/
							inst->gs.idx_lev++;																			/* increment level-index of structure	*/
							inst->gs.flag_arr_str[inst->gs.idx_lev] = 0;												/* save it's not an array of structures	*/

							/* --------------------------- force switch repetition in order to speed the function -----------------------------------------------	*/
							if (inst->speed_option == 1)
							{
								if (inst->limit_repeat_cntr <= 4)								/* the number of maximum repetition is 4...				*/
								{																/* in a 10 ms task until "38" has been tested without problems	*/
									inst->repeat_switch = 1;									/* force switch repetition enabling the do-while			*/
									inst->limit_repeat_cntr++;									/* count the number of repetition						*/
								}
								else															/* if do-while cycled 5 times...						*/
								{
									inst->repeat_switch = 0;									/* ...this time cycle disabled (to avoid time-violation)		*/
									inst->limit_repeat_cntr = 0;								/* reset counter repetitions							*/
								}
							}
							/* ----------------------------------------------------------------------------------------------------------------------------------	*/
						break;


						case 15: 																						/* if data type is an array of struct 	*/

							inst->gs.st_item = PV_item(&inst->gs.name[0], inst->gs.cnt_dim[inst->gs.idx_lev], &inst->gs.field[0]);/* get nr of array elements	*/

							inst->gs.flag_arr_str[inst->gs.idx_lev] = 1;												/* save it's an array of structures		*/

							strcat(&inst->gs.name[0], "[");																/* strcat open bracket				*/
							inst->gs.len = itoa(inst->gs.cnt_arr_str[inst->gs.idx_lev] , (UDINT) &inst->gs.ascii_value);/* write int value in string			*/
							strcat(&inst->gs.name[0], &inst->gs.ascii_value[0]);										/* strcat name of element			*/
							strcat(&inst->gs.name[0], "]");																/* strcat close bracket				*/
							inst->gs.idx_lev++;																			/* increment level-index of structure	*/

							/* --------------------------- force switch repetition in order to speed the function -----------------------------------------------	*/
							if (inst->speed_option == 1)
							{
								if (inst->limit_repeat_cntr <= 4)								/* the number of maximum repetition is 4...				*/
								{																/* in a 10 ms task until "38" has been tested without problems	*/
									inst->repeat_switch = 1;									/* force switch repetition enabling the do-while			*/
									inst->limit_repeat_cntr++;									/* count the number of repetition						*/
								}
								else															/* if do-while cycled 5 times...						*/
								{
									inst->repeat_switch = 0;									/* ...this time cycle disabled (to avoid time-violation)		*/
									inst->limit_repeat_cntr = 0;								/* reset counter repetitions							*/
								}
							}
							/* ----------------------------------------------------------------------------------------------------------------------------------	*/
						break;



						default:  																						/* if data type is a variable			*/

							if (inst->gs.dim[inst->gs.idx_lev] > 1)														/* if variable dimension > 1...		*/
							{																							/* ...it means it's an array			*/
								strcat(&inst->gs.name[0], "[");															/* write its index in square brackets	*/
								inst->gs.len= itoa(inst->gs.cnt_dim[inst->gs.idx_lev] , (UDINT) &inst->gs.ascii_value); /* write int value (index) in ascii		*/
								strcat(&inst->gs.name[0], &inst->gs.ascii_value[0]);									/* write index in variable name 		*/
								strcat(&inst->gs.name[0], "]");
							}
							Get_value(inst); 																			/* get var value and convert it in ascii 	*/

							/* --------------------------- force switch repetition in order to speed the function -----------------------------------------------	*/
							if (inst->speed_option == 1)
							{
								if (inst->limit_repeat_cntr <= 4)								/* the number of maximum repetition is 4...				*/
								{																/* in a 10 ms task until "38" has been tested without problems	*/
									inst->repeat_switch = 1;									/* force switch repetition enabling the do-while			*/
									inst->limit_repeat_cntr++;									/* count the number of repetition						*/
								}
								else															/* if do-while cycled 5 times...						*/
								{
									inst->repeat_switch = 0;									/* ...this time cycle disabled (to avoid time-violation)		*/
									inst->limit_repeat_cntr = 0;								/* reset counter repetitions							*/
								}
							}
							/* ----------------------------------------------------------------------------------------------------------------------------------	*/
						break;

					} /* end switch (inst->data_typ) */

				}/* end if (inst->gs.st_ninfo == 0) */
				else
				{
					SET_ERROR_WRITE(inst->gs.st_ninfo );											/* if status not ok go to error step					*/
				}
			break;


												/* ========================================================	*/
												/*			WRITE VAR NAME AND VALUE ON FILE				*/
												/* ========================================================	*/
			case STEP_WST_WRITE_DATA:
				inst->FWrite.enable	= 1;														/* enable fub											*/
				inst->FWrite.ident 	= inst->fileio_id;											/* pass ident											*/
				inst->FWrite.offset = 0;														/* start to write from beginning of csv					*/
				inst->FWrite.pSrc 	= (UDINT) inst->mem_part_all.mem;							/* ddress of buffer										*/
				inst->FWrite.len 	=  inst->offset;											/* write entire buffer									*/
				FileWrite(&inst->FWrite);														/* call fub												*/
				if (inst->FWrite.status == 0)													/* if status ok...										*/
				{
					inst->offset  = 0;															/* reset buffer length									*/
					inst->step 	  = STEP_WST_CLOSE;												/* go to step in order to close the csv file				*/
				}
				else if (inst->FWrite.status != 65535)											/* if status not ok and fub not busy....					*/
				{
					SET_ERROR_WRITE(inst->FWrite.status);										/* ...go to step error									*/
					if (inst->FDelete.status   == 20799)										/* ...if general error occurred							*/
					{
						inst->get_sys_err = FileIoGetSysError();								/* ... get code error									*/
					}
				}
			break;


												/* ========================================================	*/
												/*         				CLOSE FILE							*/
												/* ========================================================	*/
			case STEP_WST_CLOSE:
				inst->FClose.enable	= 1;														/* enable fub											*/
				inst->FClose.ident 	= inst->fileio_id;											/* pass ident											*/
				FileClose(&inst->FClose);														/* call fub												*/
				if (inst->FClose.status == 0)													/* if status ok...										*/
				{
					inst->step   = STEP_WST_FREE_MEMORY;										/* ... go to step in order to free the memory				*/
				}
				else if (inst->FClose.status != 65535)											/* if status not ok and fub not busy....					*/
				{
					SET_ERROR_WRITE(inst->FClose.status);											/* ...go to step error									*/
					if (inst->FDelete.status   == 20799)										/* ...if general error occurred							*/
					{
						inst->get_sys_err = FileIoGetSysError();								/* ... get code error									*/
					}
				}
			break;


												/* ========================================================	*/
												/*				         MEMORY FREE						*/ /* NEW V2.00 */
												/* ========================================================	*/

			case STEP_WST_FREE_MEMORY:
				inst->mem_part_free.enable = 1;													/* enable fub											*/
				inst->mem_part_free.ident  = inst->ident;										/* set ident											*/
				inst->mem_part_free.mem    = inst->mem_part_all.mem;							/* memory to free										*/
				AsMemPartFree(&inst->mem_part_free);											/* call fub												*/
				if (inst->mem_part_free.status == 0)											/* if status ok...										*/
				{
					inst->step = STEP_WST_INIT;													/* ...end of fub: return to init step					*/
					inst->status = 0;															/* set status ok								 		*/
				}
				else																			/* if status not ok and fub not busy....					*/
				{
					SET_ERROR(inst->mem_part_free.status);										/* ...go to step error									*/
					if (inst->FDelete.status   == 20799)										/* ...if general error occurred							*/
					{
						inst->get_sys_err = FileIoGetSysError();								/* ... get code error									*/
					}
				}
			break;

												/* ========================================================	*/
												/*         				DELETE FILE							*/
												/* ========================================================	*/
			case STEP_WST_FILE_EXIST:
				/* if (inst->overw == 1)
				{*/
					inst->FDelete.enable   = 1;													/* enable fub											*/
					/*MD 1/12/2005*/
					/*inst->FDelete.pDevice = (UDINT) &(inst->device);				 pointer to device					 				*/

					inst->FDelete.pDevice  = (UDINT) P_DEVICE;									/* pointer to device (see CPU properties)					*/
					inst->FDelete.pName    = (UDINT) inst->recipecsv;							/* file name											*/
					FileDelete(&inst->FDelete);													/* call fub												*/
					if (inst->FDelete.status == 0)												/* if status ok...										*/
					{
						inst->step = STEP_WST_CREATE;											/* go to steo in order to do new creation					*/
	 				}
					else if (inst->FDelete.status  != 65535)									/* if status not ok and fub not busy....					*/
					{
						if (inst->FDelete.status   == 20799)									/* ...if general error occurred							*/
						{
							inst->get_sys_err = FileIoGetSysError();							/* ... get code error									*/
						}
						SET_ERROR_WRITE(inst->FDelete.status );									/* go to error step										*/
					}
				/*}
				else if (inst->overw == 0)
				{
					inst->step   = STEP_WST_CLOSE;
				}*/
			break;


												/* ========================================================	*/
												/*         				ERROR STEP							*/
												/* ========================================================	*/

			case STEP_WST_FREE_MEM_ERR_CAUSE:
				inst->mem_part_free.enable = 1;													/* enable fub											*/
				inst->mem_part_free.ident  = inst->ident;										/* set ident											*/
				inst->mem_part_free.mem    = inst->mem_part_all.mem;							/* memory to free										*/
				AsMemPartFree(&inst->mem_part_free);											/* call fub												*/
				if (inst->mem_part_free.status == 0)											/* if status ok...										*/
				{
				inst->status = inst->tmp_status;
				inst->step = STEP_WST_ERROR;													/* ...end of fub: go to error step						*/
				}
				else																			/* if status not ok and fub not busy....					*/
				{
					inst->status    = inst->tmp_status;
					inst->step = STEP_WST_ERROR;
				}
			break;



			case STEP_WST_ERROR:
				/* function in error, it has to be called with enable = 0 in order to reset it */
				if(inst->mem_allocated == 1)	/*need to free memory*/
				{
					inst->mem_part_free.enable = 1;													/* enable fub											*/
					inst->mem_part_free.ident  = inst->ident;										/* set ident											*/
					inst->mem_part_free.mem    = inst->mem_part_all.mem;							/* memory to free										*/
					AsMemPartFree(&inst->mem_part_free);											/* call fub												*/
					if (inst->mem_part_free.status == 0)											/* if status ok...										*/
					{
						inst->mem_allocated = 0;
					}
				}
			break;

		} /* end switch (inst->step)*/

	} while (inst->repeat_switch == 1);

} /* end Rec_Write() */



/*______________________________________________________________________________________*/
/*																						*/
/*	Function:	:	Rec_Upload()														*/
/*	File name	:	recipe.c															*/
/*	Version		:	2.00																*/
/*	Date		:	01.12.2004															*/
/*	Author		:	Alessandro Cazzola													*/
/*	Description	:	upoload data from recipe(csv file)			    					*/
/*	Changes		:   /																	*/
/*______________________________________________________________________________________*/
void Rec_Upload(Rec_Upload_typ *inst)
{
	#define     STEP_RST_ALLOC			0
	#define 	UPL_INIT				5
	#define 	UPL_FREAD				10
	#define		UPL_FCLOSE				15
	#define		UPL_FREAD_1				20
	#define     UPL_EXTRACT_DATA		25
	#define     STEP_UPL_FREE_MEMORY	30
	#define     STEP_WST_FREE_MEM_ERR_CAUSE 99

	#define BUFFER(offset)						(*((USINT *)(inst->mem_part_all.mem + offset)))

	/* NEW V2.04 */
	#define SET_ERROR_READ(err_code)	{\
				inst->prevstep  	= inst->step;\
				inst->step 			= STEP_WST_FREE_MEM_ERR_CAUSE;\
				inst->tmp_status    = err_code;\
				Rec_Write_err_msg(inst->msg_err, err_code, inst->prevstep);\
	}


	if (inst->enable == 0)
	{
		strcpy(inst->recipecsv, "");
		inst->step 				 = 0;
		inst->offset 			 = 0;
		inst->k 				 = 0;
		inst->j 				 = 0;
		memset(&inst->ascii_infile[0], 0, sizeof(inst->ascii_infile));
		memset(&inst->gs 		     , 0, sizeof(inst->gs));
		memset(&inst->FOpen 	     , 0, sizeof(inst->FOpen));
		memset(&inst->FRead 	     , 0, sizeof(inst->FRead));
		memset(&inst->FClose    	 , 0, sizeof(inst->FClose ));
		memset(&inst->get_sys_err    , 0, sizeof(inst->get_sys_err));
		memset (&inst->mem_part_all  , 0, sizeof(inst->mem_part_all));
		memset (&inst->mem_part_free , 0, sizeof(inst->mem_part_free));
		inst->limit = 0;
		inst->repeat_switch 	  = 0;
		inst->prevstep 			  = 0;
		inst->status 			  = 0;
		strcpy(inst->msg_err, "");
		inst->tmp_status = 0;
		return;
	}


	do
	{
		inst->repeat_switch = 0;													/* disable do-while statement									*/

		switch (inst->step)
		{
													/* ========================================================	*/
													/*				       MEMORY ALLOCATION					*/ /* NEW V2.00 */
													/* ========================================================	*/

				case STEP_RST_ALLOC:
					inst->status = 65535;											/* set fub busy													*/

					inst->mem_part_all.enable 	= 1;								/* enable fub													*/
					inst->mem_part_all.ident  	= inst->ident;						/* set ident													*/
					inst->mem_part_all.len	 	= TOTAL_MEMORY_ALLOC;				/* length of memory 											*/
					AsMemPartAlloc(&inst->mem_part_all);							/* call fub														*/
					if (inst->mem_part_all.status == 0)								/* if status ok...												*/
					{
						inst->step = UPL_INIT;										/* ...go to step in order to open the file						*/
						inst->mem_allocated = 1;									/* memry allocated flag											*/
					}
					else															/* if status not ok...											*/
					{
						SET_ERROR(inst->mem_part_all.status);						/* ...go to error step											*/
					}
				break;



													/* ========================================================	*/
													/*         				OPEN FILE							*/
													/* ========================================================	*/
			case UPL_INIT:
				strcpy(&inst->recipecsv[0], &inst->recipe[0]);						/* strcat recipe name (here without csv extension)				*/
				strcat(&inst->recipecsv[0], ".csv"          );						/* strcat csv extension											*/
				memset(&inst->gs.name[0], 0, sizeof(inst->gs.name));				/* reset buffer for variables names								*/
				inst->gs.idx_lev = 0;												/* reset level-index of structure (recipe)						*/

				inst->FOpen.enable   	= 1;										/* enable fub													*/

				/*MD 1/12/2005*/
				/*inst->FOpen.pDevice = (UDINT) &(inst->device);						 pointer to device					 						*/

				inst->FOpen.pDevice 	= (UDINT) P_DEVICE;							/* pointer to device (see CPU properties)						*/
				inst->FOpen.pFile 		= (UDINT) inst->recipecsv;					/* file name													*/
				inst->FOpen.mode 	    = FILE_R; 									/* read access 													*/
				FileOpen(&inst->FOpen);

				if (inst->FOpen.status == 20708)									/* if file not present....										*/
				{
					SET_ERROR_READ(inst->FOpen.status );							/* ...set "file (recipe) doesn' exist" error					*/
				}
				else if (inst->FOpen.status  == 0)									/* if staus ok...												*/
				{
					inst->step 			= UPL_FREAD;								/* ...go to step FREAD (they are already present)				*/
					inst->offset 		= 0;										/* reset offset													*/
				}
				else if (inst->FOpen.status  != 65535)								/* if status not ok and fub not busy....						*/
				{
					SET_ERROR_READ(inst->FOpen.status);								/* ...go to error step 											*/

					if (inst->FOpen.status  == 20799)								/* ...if general error occurred									*/
					{
						inst->get_sys_err = FileIoGetSysError();					/* ... get code error											*/
					}
				}
			break;


													/* ========================================================	*/
													/*         				READ FILE							*/
													/* ========================================================	*/
			case UPL_FREAD:
				inst->FRead.enable	= 1;											/* set fub busy													*/
				inst->FRead.ident 	= inst->FOpen.ident;							/* get ident													*/
				inst->FRead.offset 	= inst->offset;									/* set offset where start to read								*/
				inst->FRead.pDest 	= inst->mem_part_all.mem; 						/* address of buffer 											*/
				inst->FRead.len 	= inst->FOpen.filelen;    						/* size of csv file												*/
				FileRead(&inst->FRead);												/* call fub														*/
				if (inst->FRead.status == 0)										/* if staus ok...												*/
				{
					for (inst->k = 0; (BUFFER(inst->k) != 10) && (inst->k < inst->FOpen.filelen); inst->k++) /* search end of 1st row				*/
					{
						/* */														/* no instructions in this for									*/
					}
					inst->offset = inst->offset + inst->k + 1;						/* find end of 1st row (no data in this row)					*/

					inst->step   = UPL_EXTRACT_DATA;								/* ... go to step in order to extract data						*/
				}
				else if (inst->FRead.status != 65535)								/* if status not ok and fub not busy....						*/
				{
					SET_ERROR_READ(inst->FRead.status);								/* ... go to error step											*/

					if (inst->FRead.status == 20799)								/* ...if general error occurred									*/
					{
						inst->get_sys_err = FileIoGetSysError();					/* ... get code error											*/
					}
				}
			break;



			case UPL_EXTRACT_DATA:
					for (inst->k = inst->offset; (BUFFER(inst->k) != CHR_SEPAR) && (inst->k < inst->FOpen.filelen); inst->k++) /* search until ";" found	*/
				 	{
				 		inst->gs.name[inst->k-inst->offset] = BUFFER(inst->k);		/* get variable name											*/
				 	}
				 	inst->offset = inst->k + 1;										/* remember ";" position										*/

					for (inst->k = inst->offset ; (BUFFER(inst->k) != CHR_SEPAR) && (inst->k < inst->FOpen.filelen); inst->k++)/* skip comments column 	*/
				 	{
				 		/* */
				 	}
					inst->offset = inst->k + 1;										/* remember ";" position										*/

					/* get ascii value from csv file (it has to be converted (in the next steps...) */
					inst->j = 0;
					for (inst->k = inst->offset; (BUFFER(inst->k) != 10) && (inst->k < inst->FOpen.filelen); inst->k++)/* serach end of row 			*/
					{
						if ((BUFFER(inst->k) != 10) && (BUFFER(inst->k) != 13) && (BUFFER(inst->k) != CHR_SEPAR) ) /* get ascii value				*/
						{
							inst->ascii_infile[inst->j++] = BUFFER(inst->k);		 /* get asci value												*/
						}
					}
					inst->offset = inst->k + 1;										/* update offset												*/

					inst->gs.ret_pvixgetadr  = PV_xgetadr(&inst->gs.name[0], &inst->gs.var_addr, &inst->gs.var_len);/* get variable address			*/

					if (inst->gs.ret_pvixgetadr == 0)								/* if returned value ok...										*/
					{
						inst->gs.st_ninfo = PV_ninfo  (&inst->gs.name[0], &inst->gs.data_typ, &inst->gs.var_len, &inst->gs.var_dim);/* get data type		*/

						if (inst->gs.st_ninfo == 0)												/* if returned value ok...							*/
						{
							ASCII_TO_VAL(inst->gs.data_typ, inst->ascii_infile, inst->gs.var_addr); /* convert from num to ascii value				*/
							memset (&inst->gs.ascii_value[0], 0, sizeof (inst->gs.ascii_value) );	/* reset buffer 								*/
							memset (&inst->ascii_infile     ,0 , sizeof(inst->ascii_infile)    );	/* reset buffer									*/
							memset (&inst->gs.name[0]       ,0 , sizeof(inst->gs.name)         );	/* reset buffer									*/

							/* --------------------------- force switch repetition in order to speed the function ----------------------------------------	*/
							if (inst->speed_option == 1)
							{
								if (inst->limit <= 5	)										/* the number of maximum repetition is 4...			*/
								{																/* in a 10 ms task until "50" has been tested with success	*/
									inst->repeat_switch = 1;									/* force switch repetition enabling the do-while		*/
									inst->limit++;												/* count the number of repetition					*/
								}
								else															/* if do-while cycled 5 times...					*/
								{
									inst->repeat_switch = 0;									/* ...this time cycle disabled (to avoid time-violation)	*/
									inst->limit = 0;											/* reset counter repetitions						*/
								}
							}
							/* ----------------------------------------------------------------------------------------------------------------------------	*/
						}
						else																	/* if returned value not ok...						*/
						{
							SET_ERROR_READ(inst->gs.st_ninfo);									/* ... go to error step								*/
						}
					}
					else																		/* if returned value ok...							*/
					{
						SET_ERROR_READ(inst->gs.ret_pvixgetadr);								/* ... go to error step								*/
					}

					if (inst->offset >= inst->FOpen.filelen)									/* if offset greater or equal length of file...			*/
					{
						inst->step = UPL_FCLOSE;												/* ... file completely scanned: go to step to close file	*/
						inst->repeat_switch = 0;												/* do-while disabled								*/
						inst->limit = 0;														/* reset counter repetitions						*/
					}
				break;

													/* ========================================================	*/
													/*         				CLOSE FILE							*/
													/* ========================================================	*/

			case UPL_FCLOSE:

				inst->FClose.enable	= 1;															/* set fub busy									*/
				inst->FClose.ident 	= inst->FOpen.ident;											/* get ident									*/
				FileClose(&inst->FClose);															/* call fub										*/
				if (inst->FClose.status == 0)														/* if staus ok...								*/
				{
					inst->step   = STEP_UPL_FREE_MEMORY;											/* ...go to step in order to free memory	 		*/
				}
				else if (inst->FClose.status != 65535)												/* if status not ok and fub not busy....			*/
				{
					SET_ERROR_READ(inst->FClose.status);											/* ... go to error step							*/
				}
			break;

													/* ========================================================	*/
													/*				         MEMORY FREE						*/ /* NEW V2.00 */
													/* ========================================================	*/

				case STEP_UPL_FREE_MEMORY:
					memset ((USINT*) inst->mem_part_all.mem, 0, sizeof (TOTAL_MEMORY_ALLOC) );		/* reset buffer 								*/
					inst->mem_part_free.enable = 1;													/* enable fub									*/
					inst->mem_part_free.ident  = inst->ident;										/* pass ident									*/
					inst->mem_part_free.mem    = inst->mem_part_all.mem;							/* memory to free								*/
					AsMemPartFree(&inst->mem_part_free);											/* call fub										*/
					if (inst->mem_part_free.status == 0)											/* if status ok...								*/
					{
						inst->step = 0;																/* ...end of fub: return to init step				*/
						inst->status = 0;															/* set status ok						 		*/
					}
					else																			/* if status not ok and fub not busy....			*/
					{
						SET_ERROR(inst->mem_part_free.status);										/* ...go to step error							*/
					}
				break;


													/* ========================================================	*/
													/*         				ERROR STEP							*/
													/* ========================================================	*/

			case STEP_WST_FREE_MEM_ERR_CAUSE:
				inst->mem_part_free.enable = 1;													/* enable fub											*/
				inst->mem_part_free.ident  = inst->ident;										/* set ident											*/
				inst->mem_part_free.mem    = inst->mem_part_all.mem;							/* memory to free										*/
				AsMemPartFree(&inst->mem_part_free);											/* call fub												*/
				if (inst->mem_part_free.status == 0)											/* if status ok...										*/
				{
				inst->status = inst->tmp_status;
				inst->step = STEP_WST_ERROR;													/* ...end of fub: go to error step						*/
				}
				else																			/* if status not ok and fub not busy....					*/
				{
					inst->status    = inst->tmp_status;
					inst->step = STEP_WST_ERROR;
				}
			break;


			case 100:
				/* function in error, it has to be called with enable = 0 in order to reset it */
				if(inst->mem_allocated == 1)	/*need to free memory*/
				{
					inst->mem_part_free.enable = 1;													/* enable fub											*/
					inst->mem_part_free.ident  = inst->ident;										/* set ident											*/
					inst->mem_part_free.mem    = inst->mem_part_all.mem;							/* memory to free										*/
					AsMemPartFree(&inst->mem_part_free);											/* call fub												*/
					if (inst->mem_part_free.status == 0)											/* if status ok...										*/
					{
						inst->mem_allocated = 0;
					}
				}
			break;

		} /* end switch (inst->step) */
	}
	while (inst->repeat_switch == 1);


} /* end of Rec_Upload()*/



/*______________________________________________________________________________________*/
/*																						*/
/*	Function:	:	Rec_Export()														*/
/*	File name	:	recipe.c															*/
/*	Version		:	2.00																*/
/*	Date		:	01.12.2004															*/
/*	Author		:	Alessandro Cazzola													*/
/*	Description	:	Single recipe exported to usb key									*/
/*	Changes		:   /																	*/
/*______________________________________________________________________________________*/
void Rec_Export(Rec_Export_typ *inst)
{
	if (inst->enable == 0)
	{
	 	inst->step 		   = 0;
		inst->get_sys_err  = 0;
		inst->prevstep 	   = 0;
		inst->status 	   = 0;
		strcpy(inst->recipecsv,"");
		memset (&inst->FCopy, 0, sizeof(inst->FCopy));
		strcpy(inst->msg_err, "");
		return;
	}

	switch(inst->step)
	{
		case 0:
			inst->status = 65535;														/* set fub busy												*/
			strcpy(&inst->recipecsv[0], &inst->recipe[0]);								/* copy recipe name											*/
			strcat(&inst->recipecsv[0], ".csv"          );								/* strcat csv extension										*/

			/*MD 1/12/2005*/
			/*inst->FCopy.pSrcDev = (UDINT) &(inst->device);								 pointer to device					 					*/

			inst->FCopy.pSrcDev  = (UDINT) P_DEVICE;									/*source device: compact flash								*/
			inst->FCopy.pDestDev = (UDINT) P_USB1;										/* destination device: USB 1								*/

			inst->FCopy.enable   = 1;													/* enable fub												*/
			inst->FCopy.pSrc	 = (UDINT) inst->recipecsv;								/* source file name											*/
			inst->FCopy.pDest    = (UDINT) inst->recipecsv;								/* destination file name									*/
			inst->FCopy.option   = FILE_OW_DETMEM;										/* option overwrite											*/
			FileCopy (&inst->FCopy);													/* call fub													*/

			if (inst->FCopy.status == 0)												/* if status ok...											*/
			{
				inst->status = 0;														/* ...set status = 0										*/
			}
		 	else if ((inst->FCopy.status == 20709/* V2.67*/) || (inst->FCopy.status == 20726/* V2.68*/))/* maybe USB key inserted in the 2nd USB port...  	*/
			{
				inst->FCopy.pDestDev =  (UDINT) P_USB2;									/*  destination device: USB 2								*/
				inst->step 			 = 1;												/* go to step to try try in USB 2							*/
			}
			else if (inst->FCopy.status != 65535)										/* if status not ok and fub not busy....					*/
			{
				SET_ERROR(inst->FCopy.status );											/* ...go to error step										*/
			}
		break;



		case 1:
			FileCopy (&inst->FCopy);													/* call fub													*/
			if (inst->FCopy.status == 0)												/* if status ok...											*/
			{
				inst->status = 0;														/* ...set status = 0										*/
				inst->step   = 0;														/* return to init step										*/
			}
			else if (inst->FCopy.status != 65535)										/* if status not ok and fub not busy....					*/
			{
				SET_ERROR(inst->FCopy.status );											/* ...go to error step										*/
			}
		break;



		case 100:
			/* function in error, it has to be called with enable = 0 in order to reset it */
		break;

	} /* end switch(inst->step)*/

} /*end Rec_Export() */




/*______________________________________________________________________________________*/
/*																						*/
/*	Function:	:	Rec_Import()														*/
/*	File name	:	recipe.c															*/
/*	Version		:	2.00																*/
/*	Date		:	01.12.2004															*/
/*	Author		:	Alessandro Cazzola													*/
/*	Description	:	Single recipe imported from usb key									*/
/*	Changes		:   /																	*/
/*______________________________________________________________________________________*/
void Rec_Import(Rec_Import_typ *inst)
{
	if (inst->enable == 0)
	{
		inst->step 			= 0;
		inst->get_sys_err 	= 0;
		inst->prevstep 		= 0;
		memset (&inst->FCopy,0, sizeof(inst->FCopy));
		strcpy(inst->recipecsv, "");
		inst->status 		= 0;
		strcpy(inst->msg_err, "");
		return;
	}

	switch(inst->step)
	{
		case 0:
			inst->status 		 = 65535;												/* set fub busy												*/

			strcpy(&inst->recipecsv[0], &inst->recipe[0]);								/* copy recipe name											*/
			strcat(&inst->recipecsv[0], ".csv"          );								/* strcat csv extension										*/

			inst->FCopy.pSrcDev  = (UDINT) P_USB1;										/* source devices: USB 1									*/

			/*MD 1/12/2005*/
		/*	inst->FCopy.pDestDev = (UDINT) &(inst->device);								 pointer to device					 					*/

			inst->FCopy.pDestDev = (UDINT) P_DEVICE;									/* destination device: compact flash						*/
			inst->FCopy.enable   = 1;													/* enable fub												*/
			inst->FCopy.pSrc	 = (UDINT) inst->recipecsv;								/* source file name											*/
			inst->FCopy.pDest    = (UDINT) inst->recipecsv;								/* destination file name									*/
			inst->FCopy.option   = FILE_OW_DETMEM;										/* option overwrite											*/
			FileCopy (&inst->FCopy);													/* call fub													*/

			if (inst->FCopy.status == 0)												/* if status ok...											*/
			{
				inst->status = 0;														/* ...set status = 0										*/
			}
		 	else if ((inst->FCopy.status == 20709/* V2.67*/) || (inst->FCopy.status == 20726/* V2.68*/))/* maybe the USB key inserted in the 2nd USB port...*/
			{
				inst->FCopy.pSrcDev = (UDINT) P_USB2;									/* source devices: USB 2									*/
				inst->step 		 	= 1;												/* go to next step											*/
			}
			else if (inst->FCopy.status != 65535)										/* if status not ok and fub not busy....					*/
			{
				SET_ERROR(inst->FCopy.status );											/* ...go to error step										*/
			}
		break;


		case 1:
			FileCopy (&inst->FCopy);													/* call fub													*/
			if (inst->FCopy.status == 0)												/* if status ok...											*/
			{
				inst->status = 0;														/* ...set status = 0										*/
				inst->step   = 0;														/* return to init step										*/
			}
			else if (inst->FCopy.status != 65535)										/* if status not ok and fub not busy....					*/
			{
				SET_ERROR(inst->FCopy.status );											/* ...go to error step										*/
			}
		break;


		case 100:
			/* function in error, it has to be called with enable = 0 in order to reset it */
		break;

	} /* end switch(inst->step)*/

} /*end Rec_Import() */




/*______________________________________________________________________________________*/
/*																						*/
/*	Function:	:	Rec_Exp_All()														*/
/*	File name	:	recipe.c															*/
/*	Version		:	2.00																*/
/*	Date		:	01.12.2004															*/
/*	Author		:	Alessandro Cazzola													*/
/*	Description	:	All recipes exported to usb key										*/
/*	Changes		:   /																	*/
/*______________________________________________________________________________________*/
void Rec_Exp_All(Rec_Exp_All_typ *inst)
{
	if (inst->enable == 0)
	{
		memset(&inst->recipe[0]  , 0, sizeof (inst->recipe));
		memset(&inst->read_name  , 0, sizeof(inst->read_name));
		memset(&inst->rec_exp    , 0, sizeof(inst->rec_exp));
		inst->step 			   = 0;
		inst->get_sys_err 	   = 0;
		inst->prevstep 		   = 0;
		inst->status 		   = 0;
		strcpy(inst->msg_err, "");
		return;
	}

	switch(inst->step)
	{
		case 0:
			inst->status 			= 65535;											/* set fub busy												*/
			inst->read_name.enable  = 1;												/* enable fub												*/
			/*memcpy(&(inst->read_name.device), &(inst->device), sizeof(inst->read_name.device));*/
			Rec_NameRead(&inst->read_name);												/* call fub													*/

			if (inst->read_name.status == 0)											/* if status ok...											*/
			{
				inst->status = 0;														/* set status ok											*/
			}
			else if (inst->read_name.status == 1)										/* if status ok...											*/
			{
				inst->step = 1;															/* ... go to next step										*/
			}
			else if (inst->read_name.status != 65535)									/* if status not ok and fub not busy....					*/
			{
				SET_ERROR(inst->read_name.status);										/* ...go to error step										*/
			}
		break;


		case 1:
			inst->rec_exp.enable = 1;													/* enable fub												*/

			/*MD 1/12/2005*/
			/*memcpy (&inst->rec_exp.device[0], &inst->device, sizeof (inst->rec_exp.device) );	 pointer to device					 			*/

			memcpy (&inst->rec_exp.recipe[0], &inst->read_name.recipe[0], sizeof (inst->rec_exp.recipe) );/*CONTROLLA! FILENAME è LUNGO 260!! TROPPO 		*/
			Rec_Export(&inst->rec_exp);													/* call fub													*/

			if (inst->rec_exp.status == 0)												/* if status ok...											*/
			{
				inst->step   = 0;											   			/* return to init step										*/
			}
			else if (inst->rec_exp.status != 65535)										/* if status not ok and fub not busy....					*/
			{
				SET_ERROR(inst->rec_exp.status);										/* ...go to error step										*/
			}
		break;


		case 100:
			/* function in error, it has to be called with enable = 0 in order to reset it */
		break;

	} /* end switch(inst->step)*/
}



/*______________________________________________________________________________________*/
/*																						*/
/*	Function:	:	Rec_Imp_All()														*/
/*	File name	:	recipe.c															*/
/*	Version		:	2.00																*/
/*	Date		:	01.12.2004															*/
/*	Author		:	Alessandro Cazzola													*/
/*	Description	:	All recipes exported to usb key										*/
/*	Changes		:   /																	*/
/*______________________________________________________________________________________*/

void Rec_Imp_All(Rec_Imp_All_typ *inst)
{
	if (inst->enable == 0)
	{
		memset(&inst->recipe[0], 0, sizeof (inst->recipe));
		memset(&inst->read_name, 0, sizeof(inst->read_name)) ;
		memset(&inst->rec_imp  , 0, sizeof(inst->rec_imp)) ;
		inst->step 			   = 0;
		inst->get_sys_err 	   = 0;
		inst->prevstep 		   = 0;
		inst->status 		   = 0;
		strcpy(inst->msg_err, "");
		strcpy(inst->recipe_imp, "");
		inst->nr_csv_imported  = 0;
		return;
	}

	switch(inst->step)
	{
		case 0:
			inst->status 			= 65535;											/* set fub busy												*/
			inst->nr_csv_imported  	= 0;												/* reset total csv files imported							*/
			memset(&inst->recipe[0], 0, sizeof (inst->recipe));							/* reset internal structure									*/
			memset(&inst->read_name, 0, sizeof(inst->read_name)) ;						/* reset internal structure									*/
			memset(&inst->rec_imp  , 0, sizeof(inst->rec_imp)) ;						/* reset internal structure									*/
			strcpy(inst->recipe_imp, "");												/* reset output												*/
			inst->get_sys_err 	    = 0;												/* reset internal variable									*/
			inst->step 				= 1;												/* ... go to next step										*/
		break;


		case 1:
			inst->status 			    = 65535;										/* set fub busy												*/
			inst->read_name.enable 		= 1;											/* enable fub												*/
			inst->read_name.set_device 	= 1;											/* device set is usb key (import from usb to cf)				*/
			Rec_NameRead(&inst->read_name);												/* call fub													*/

			if (inst->read_name.status == 0)											/* if status ok (0 means no file name present and fub finished)	*/
			{
				inst->status = 0;
				inst->step   = 0;
			}
			else if (inst->read_name.status == 1)										/* if status ok (1 means other file name present)				*/
			{
				inst->step   = 2;
			}
			else if (inst->read_name.status != 65535) 									/* if status is not "fub busy"...							*/
			{
				SET_ERROR(inst->read_name.status);										/* ...go to error step										*/
			}
		break;


		case 2:
			inst->rec_imp.enable = 1;													/* enable fub												*/

			/*MD 1/12/2005*/
			/*memcpy(&(inst->rec_imp.device),&(inst->device),sizeof(inst->rec_imp.device));	 pointer to device				 					*/

			memcpy (&inst->rec_imp.recipe[0], &inst->read_name.recipe[0], sizeof (inst->rec_imp.recipe) );	/* copy recipe name						*/
			Rec_Import(&inst->rec_imp);													/* call fub													*/
			if (inst->rec_imp.status == 0)												/* if status ok...											*/
			{
				inst->step   = 1;														/* ...return to previous step 								*/
				inst->status = 1;
				memcpy (&inst->recipe_imp[0], &inst->rec_imp.recipe[0], sizeof (inst->rec_imp.recipe) ); /* copy in output name of recipe				*/
				inst->nr_csv_imported++;
			}
			else if (inst->rec_imp.status != 65535)										/* if status not ok and fub not busy....					*/
			{
				SET_ERROR(inst->rec_imp.status);										/* ...go to error step										*/
			}
		break;


		case 100:
			/* function in error, it has to be called with enable = 0 in order to reset it */
		break;

	} /* end switch(inst->step)*/

} /* end Rec_ImportAll() */



/*______________________________________________________________________________________*/
/*																						*/
/*	Function:	:	clear()																*/
/*	File name	:	recipe.c															*/
/*	Version		:	2.00																*/
/*	Date		:	01.12.2004															*/
/*	Author		:	Alessandro Cazzola													*/
/*	Description	:	it clears a string from char passed as argument (var "car") ahead	*/
/*					example: "var.field" becomes "var" if char passed is '.'			*/
/*                  This function is internal: it doesn't compare in the library		*/
/*	Changes		:   /																	*/
/*______________________________________________________________________________________*/

void clear(USINT *str, USINT car)
{
	UINT 	 len, j;
	USINT    rev[100], new_rev[100];

	len = strlen(&str[0]) ;

	for (j=0; j<len ; j++)
	{
		rev[j] 		 = str[len-j-1];
		str[len-j-1] = (STRING) 0;
	}
	rev[j] = (STRING) 0;

	for (j=0; j<len && rev[j]!= car; j++)		/* find character in the string */
	{
		/* */
	}

	strcpy(&new_rev[0], &rev[j+1]);

	len = strlen(&new_rev[0]) ;

	for (j=0; j<len ; j++)
	{
		str[j] = new_rev[len-j-1];
	}

} /* end clear() */






/*______________________________________________________________________________________*/
/*																						*/
/*	Function:	:	Rec_Write_err_msg()													*/
/*	File name	:	recipe.c															*/
/*	Version		:	2.00																*/
/*	Date		:	28.01.2005															*/
/*	Author		:	B&R																	*/
/*	Description	:	write error message on variable "inst->msg_err"						*/
/*	Changes		:   /																	*/
/*______________________________________________________________________________________*/

void Rec_Write_err_msg(USINT p_chr[80], UINT status, UINT prevstep)
{
	STRING	code[5], str_prevstep[6];

	/* SYS_LIB */
	if (status == 2061 )  strcpy (p_chr, "Invalid row entry");
	if (status == 2062 )  strcpy (p_chr, "Invalid column entry");
	if (status == 2063 )  strcpy (p_chr, "Invalid ASCII character");
	if (status == 2073 )  strcpy (p_chr, "RTC not initialized");
	if (status == 3030 )  strcpy (p_chr, "No memory available");
	if (status == 3035 )  strcpy (p_chr, "Memory manager: Semaphor closed");
	if (status == 3104 )  strcpy (p_chr, "Invalid pointer for MEM_free()");
	if (status == 3300 )  strcpy (p_chr, "Incorrect resource number");
	if (status == 3301 )  strcpy (p_chr, "Invalid offset for DA_write()");
	if (status == 3302 )  strcpy (p_chr, "Incorrect module/object status");
	if (status == 3303 )  strcpy (p_chr, "No message for UT_recmsg()");
	if (status == 3304 )  strcpy (p_chr, "SM_attach() has timed out");
	if (status == 3305 )  strcpy (p_chr, "Object already exists");
	if (status == 3306 )  strcpy (p_chr, "Entry/semaphore already exists");
	if (status == 3307 )  strcpy (p_chr, "AVT entry cannot be deleted since the link count is <> 0");
	if (status == 3308 )  strcpy (p_chr, "An error has occurred on DA_burn()/DA_fix()");
	if (status == 3309 )  strcpy (p_chr, "No valid mailbox exists");
	if (status == 3310 )  strcpy (p_chr, "Inactive area accessed");
	if (status == 3311 )  strcpy (p_chr, "Invalid area code");
	if (status == 3312 )  strcpy (p_chr, "Invalid extension bit");
	if (status == 3313 )  strcpy (p_chr, "Invalid version of the SYS_LIB library");
	if (status == 3314 )  strcpy (p_chr, "Invalid length entry");
	if (status == 3315 )  strcpy (p_chr, "Maximum link count (127) reached");
	if (status == 3316 )  strcpy (p_chr, "Link count = 0 (AVT_release())");
	if (status == 3320 )  strcpy (p_chr, "Semaphore deleted during WAIT");
	if (status == 3324 )  strcpy (p_chr, "Object not available");
	if (status == 3328 )  strcpy (p_chr, "Incorrect object type (module type)");
	if (status == 3332 )  strcpy (p_chr, "Object not found");
	if (status == 3333 )  strcpy (p_chr, "PV long names are not supported");
	if (status == 3336 )  strcpy (p_chr, "Invalid ID number");
	if (status == 3560 )  strcpy (p_chr, "Buffer no longer available");
	if (status == 3564 )  strcpy (p_chr, "Semaphore not available");
	if (status == 3568 )  strcpy (p_chr, "Semaphore already deleted");
	if (status == 3584 )  strcpy (p_chr, "No time available");
	if (status == 3588 )  strcpy (p_chr, "Invalid date");
	if (status == 3592 )  strcpy (p_chr, "Invalid time");
	if (status == 3596 )  strcpy (p_chr, "Invalid tick number");
	if (status == 3600 )  strcpy (p_chr, "No memory available");
	if (status == 3601 )  strcpy (p_chr, "No memory available");
	if (status == 3700 )  strcpy (p_chr, "Ivalid pointer for MEM_free()");
	if (status == 3701 )  strcpy (p_chr, "Invalid pointer for TMP_free()");
	if (status == 9133 )  strcpy (p_chr, "Zero pointer used with dynamic PVs");
	if (status == 14700)  strcpy (p_chr, "Invalid PV name");
	if (status == 14702)  strcpy (p_chr, "Invalid array index");
	if (status == 14703)  strcpy (p_chr, "Invalid structure element");
	if (status == 14704)  strcpy (p_chr, "Invalid component");
	if (status == 14710)  strcpy (p_chr, "PV not found");
	if (status == 14713)  strcpy (p_chr, "No PV description available");
	if (status == 14714)  strcpy (p_chr, "Array index too large");
	if (status == 21002)  strcpy (p_chr, "Illegal offset");
	if (status == 21003)  strcpy (p_chr, "CPU type has no fixed memory");


	/* DATAOBJ */
	if (status == 20600) strcpy (p_chr, "Wrong parameter given (NULL pointer)");
	if (status == 20601) strcpy (p_chr, "Object already present");
	if (status == 20602) strcpy (p_chr, "Wrong target memory specified");
	if (status == 20603) strcpy (p_chr, "No memory available for module to be created");
	if (status == 20604) strcpy (p_chr, "Error installing data object");
	if (status == 20605) strcpy (p_chr, "Object not found");
	if (status == 20606) strcpy (p_chr, "Wrong object type (not data object)");
	if (status == 20607) strcpy (p_chr, "Wrong offset specified");
	if (status == 20608) strcpy (p_chr, "Wrong length specified");
	if (status == 20609) strcpy (p_chr, "Data object not found");
	if (status == 20610) strcpy (p_chr, "Wrong date in SetDate (DatObjChangeDate)");
	if (status == 20611) strcpy (p_chr, "Incorrect state of the data object");
	if (status == 20612) strcpy (p_chr, "Error while enabling asynchronous handler (only i386)");
	if (status == 20613) strcpy (p_chr, "Module name too long (max. 10 characters)");
	if (status == 20614) strcpy (p_chr, "Error while saving the data object in Flash memory");


	/*FileIO*/
	if (status == 20700) strcpy (p_chr , "Invalid path");
	if (status == 20701) strcpy (p_chr , "The data length specified is too small (DirRead)");
	if (status == 20702) strcpy (p_chr , "No more file handles available");
	if (status == 20703) strcpy (p_chr , "IOCTL code error (system error)");
	if (status == 20704) strcpy (p_chr , "Invalid type");
	if (status == 20705) strcpy (p_chr , "File already exists");
	if (status == 20706) strcpy (p_chr , "Access not possible using the desired mode");
	if (status == 20707) strcpy (p_chr , "Illegal mode");
	if (status == 20708) strcpy (p_chr , "File (recipe) does not exist");
	if (status == 20709) strcpy (p_chr , "File device not permitted");
	if (status == 20710) strcpy (p_chr , "Not enough memory for file with new write data");
	if (status == 20711) strcpy (p_chr , "Invalid file offset");
	if (status == 20712) strcpy (p_chr , "File not permitted");
	if (status == 20713) strcpy (p_chr , "Not enough virtual memory available to copy file (FileCopy)");
	if (status == 20714) strcpy (p_chr , "General error in FileOpen");
	if (status == 20715) strcpy (p_chr , "General error in FileClose");
	if (status == 20716) strcpy (p_chr , "General error in FileRead");
	if (status == 20717) strcpy (p_chr , "General error in FileWrite");
	if (status == 20718) strcpy (p_chr , "General error in Ioctl");
	if (status == 20719) strcpy (p_chr , "Data pointer specified invalid (NULL)(FileRead,FileWrite,DirRead)");
	if (status == 20720) strcpy (p_chr , "Error in FileIoManager");
	if (status == 20721) strcpy (p_chr , "File not opened");
	if (status == 20722) strcpy (p_chr , "Invalid directory");
	if (status == 20723) strcpy (p_chr , "Directory does not exist (Check USB key presence)");
	if (status == 20724) strcpy (p_chr , "Directory not empty");
	if (status == 20725) strcpy (p_chr , "Directory already exists");
	if (status == 20797) strcpy (p_chr , "Error in DeviceDriver");
	if (status == 20798) strcpy (p_chr , "Error in DeviceManager");
	if (status == 20799) strcpy (p_chr , "General system fault (more info using the FileIOGetSysError()");
	if (status == 65534) strcpy (p_chr , "Enable is FALSE (only if FBK is no longer BUSY)");
	if (status == 20726) strcpy (p_chr , "Check USB key presence");

	/* AsMem */
	if (status == 30500) strcpy (p_chr , "Cannot create memory partition");
	if (status == 30501) strcpy (p_chr , "Cannot free up memory partition");
	if (status == 30502) strcpy (p_chr , "Cannot allocate memory block with requested size");
	if (status == 30503) strcpy (p_chr , "Cannot free up memory block");
	if (status == 30504) strcpy (p_chr , "Information about free memory can not be detected");

	itoa(status, (UDINT) &code); 			/*write int value to the string "code" 				*/
	strcat(p_chr, " (");
	strcat(p_chr, code);
	strcat(p_chr, ", STP");
	itoa(prevstep, (UDINT) &str_prevstep); 	/*	write int value to the string "str_prevstep" 	*/
	strcat(p_chr, str_prevstep);		 	/* it coontains the step where error occurred		*/
	strcat(p_chr, ")");

} /* end Rec_Write_err_msg() */







/*______________________________________________________________________________________*/
/*																						*/
/*	Function:	:	Write_data()														*/
/*	File name	:	recipe.c															*/
/*	Version		:	2.00																*/
/*	Date		:	28.01.2005															*/
/*	Author		:	B&R																	*/
/*	Description	:	write error message on variable "inst->msg_err"						*/
/*	Changes		:   /																	*/
/*______________________________________________________________________________________*/
void Get_value(Rec_Write_typ* inst)
{

	inst->gs.ret_pvixgetadr  = PV_xgetadr(&inst->gs.name[0], &inst->gs.var_addr, &inst->gs.var_len);					/* get variable address			*/

	if (inst->gs.ret_pvixgetadr == 0)																					/* if returned value ok...		*/
	{
		inst->gs.st_ninfo = PV_ninfo  (&inst->gs.name[0], &inst->gs.data_typ, &inst->gs.var_len, &inst->gs.var_dim);  	/* get data type				*/

		if (inst->gs.st_ninfo == 0)																						/* if returned value ok...		*/
		{
			VAL_TO_ASCII(inst->gs.data_typ, inst->gs.ascii_value, inst->gs.var_addr);									/* convert from num to ascii value	*/

			strcpy ( (USINT *)inst->mem_part_all.mem + inst->offset, &inst->gs.name[0]);
			inst->offset = strlen((USINT *) inst->mem_part_all.mem);													/* calculate actual buffer legth	*/
			BUFFER(inst->offset) = inst->chr_separ;																		/* put char separator 			*/
			inst->offset = inst->offset + 1;																			/* calculate actual buffer legth	*/

			inst->get_comm.enable = 1;																					/* enable fub				*/
			Rec_get_comm(&inst->get_comm);																				/* call fub					*/

			if ((inst->get_comm.status == 0) || (inst->get_comm.status == 1))											/* if status ok...			*/
			{
				strcpy ( (USINT *)inst->mem_part_all.mem + inst->offset, &inst->get_comm.comm[0]);						/* ...copy comment			*/
				inst->offset = strlen((USINT *) inst->mem_part_all.mem);												/* calculate actual buffer legth	*/
				BUFFER(inst->offset) = inst->chr_separ;																	/* put char separator 			*/
				inst->offset = inst->offset + 1;																		/* calculate actual buffer legth	*/
			}
			else																										/* if error occurred...			*/
			{
				SET_ERROR(inst->get_comm.status);																		/* ... go to error step			*/
			}
			strcpy ( (USINT *)inst->mem_part_all.mem + inst->offset, inst->gs.ascii_value);								/* copy value (in ascii format)	*/
			inst->offset = strlen((USINT *) inst->mem_part_all.mem);													/* calculate actual buffer legth	*/
			BUFFER(inst->offset    ) = 13;																				/* put carriage return 			*/
			BUFFER(inst->offset + 1) = 10; 																				/* put line feed 				*/
 			inst->offset = inst->offset = inst->offset + 2;																/* calculate actual buffer legth	*/

			memset(&inst->gs.ascii_value, 0, sizeof (inst->gs.ascii_value));											/* reset ascii value buffer		*/

			if (inst->gs.dim[inst->gs.idx_lev] > 1)																		/* if dim > 0 it's an array... 	*/
			{
				clear(&inst->gs.name[0], '[');																			/* ...then delete square brackets 	*/
			}
			if (inst->gs.cnt_dim[inst->gs.idx_lev] < inst->gs.dim[inst->gs.idx_lev] )      								/* if not last element of array... 	*/
			{
				inst->gs.cnt_dim[inst->gs.idx_lev]++;																	/* ...increment index-counter		*/
			}

			for (inst->k = inst->gs.idx_lev;  (inst->gs.cnt_dim[inst->k] == inst->gs.dim[inst->k] && (inst->gs.idx_lev > 0) ); inst->k--)
			{
			 	if (inst->gs.flag_arr_str[inst->k - 1] == 1)															/* if it's an array of structures...*/
				{
					clear(&inst->gs.name[0], '[');																		/* ...delete square brackets		*/
					inst->gs.cnt_arr_str[inst->k-1]++;																	/* increment array of struct counter*/
					if (inst->gs.cnt_arr_str[inst->k-1] >= inst->gs.dim[inst->k - 1] )									/* if array of struct's last element*/
					{
						inst->gs.cnt_arr_str[inst->k-1] = 0;															/* ... reset counter			*/
					}
				}
				else																									/* if field isn't array of structs..*/
				{
					clear(&inst->gs.name[0], '.');																		/* ..delete field name			*/
				}
				inst->gs.cnt_dim[inst->k] = 0;																			/* reset counter for this level	*/
				inst->gs.cnt_dim[inst->k-1] ++;																			/* go ahead for previous level	*/
				inst->gs.idx_lev--;																						/* decrement level 			*/
			}

			if ((inst->gs.idx_lev == 0) &&(inst->gs.cnt_dim[0] == inst->gs.dim[0]))										/* this is the end-condition 		*/
			{
				for (inst->k = 0; inst->k < DEEP_STR; inst->k++)														/* scan all struct (tree)		*/
				{
					inst->gs.cnt_dim[inst->k] = 0;																		/* reset counters about dimensions	*/
					inst->gs.dim[inst->k]     = 0;																		/* reset dimensions			*/
				}
				inst->step = STEP_WST_WRITE_DATA;																		/* ...go again to previous step	*/
			}
			else																										/* if write procedure not finished..*/
			{
				inst->step = STEP_WST_INFO_DATA;																		/* ...go again to previous step	*/
			}
		}
		else																											/* if error occurred...			*/
		{
			SET_ERROR(inst->gs.st_ninfo);																				/* ...go to error step			*/
		}
	}
	else																												/* if error occurred...			*/
	{
	 	SET_ERROR(inst->gs.ret_pvixgetadr);																				/* ...go to error step			*/
	}

} /* end Write_data() */










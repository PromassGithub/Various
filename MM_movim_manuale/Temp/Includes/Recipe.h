/* Automation Studio generated header file */
/* Do not edit ! */
/* Recipe 2.04.0 */

#ifndef _RECIPE_
#define _RECIPE_
#ifdef __cplusplus
extern "C" 
{
#endif
#ifndef _Recipe_VERSION
#define _Recipe_VERSION 2.04.0
#endif

#include <bur/plctypes.h>

#ifndef _BUR_PUBLIC
#define _BUR_PUBLIC
#endif
#ifdef _SG3
		#include "astime.h"
		#include "sys_lib.h"
		#include "FileIO.h"
		#include "DataObj.h"
		#include "AsMem.h"
		#include "asstring.h"
#endif
#ifdef _SG4
		#include "astime.h"
		#include "sys_lib.h"
		#include "FileIO.h"
		#include "DataObj.h"
		#include "AsMem.h"
		#include "asstring.h"
#endif
#ifdef _SGC
		#include "astime.h"
		#include "sys_lib.h"
		#include "FileIO.h"
		#include "DataObj.h"
		#include "AsMem.h"
		#include "asstring.h"
#endif


/* Datatypes and datatypes of function blocks */
typedef struct gs_typ
{	unsigned short st_ninfo;
	unsigned char name[80];
	unsigned long data_typ;
	unsigned long var_len;
	unsigned short dim[15];
	unsigned short st_item;
	unsigned short cnt_dim[15];
	unsigned char field[33];
	signed short idx_lev;
	signed short len;
	plcbit flag_arr_str[15];
	unsigned short cnt_arr_str[15];
	plcstring ascii_value[26];
	unsigned long var_addr;
	unsigned short var_dim;
	unsigned short ret_pvixgetadr;
} gs_typ;

typedef struct Rec_get_comm
{
	/* VAR_OUTPUT (analog) */
	plcstring comm[46];
	unsigned short status;
	/* VAR (analog) */
	unsigned char step;
	unsigned long k;
	unsigned long j;
	unsigned long start;
	struct DatObjInfo do_info;
	unsigned long count_comm;
	unsigned char prevstep;
	/* VAR_INPUT (digital) */
	plcbit enable;
} Rec_get_comm_typ;

typedef struct Rec_Write
{
	/* VAR_INPUT (analog) */
	plcstring structure[16];
	plcstring recipe[21];
	unsigned long ident;
	/* VAR_OUTPUT (analog) */
	unsigned short status;
	plcstring msg_err[81];
	/* VAR (analog) */
	unsigned char overw;
	plcstring recipecsv[25];
	unsigned char chr_separ;
	unsigned char step;
	unsigned long k;
	unsigned long fileio_id;
	unsigned long offset;
	struct gs_typ gs;
	struct Rec_get_comm get_comm;
	struct FileOpen FOpen;
	struct FileCreate FCreate;
	struct FileClose FClose;
	struct FileWrite FWrite;
	struct FileDelete FDelete;
	unsigned short get_sys_err;
	unsigned char prevstep;
	unsigned char repeat_switch;
	struct AsMemPartAlloc mem_part_all;
	struct AsMemPartFree mem_part_free;
	unsigned char limit_repeat_cntr;
	unsigned short tmp_status;
	/* VAR_INPUT (digital) */
	plcbit enable;
	plcbit speed_option;
	/* VAR (digital) */
	plcbit firstrow_written;
	plcbit mem_allocated;
} Rec_Write_typ;

typedef struct Rec_NameRead
{
	/* VAR_OUTPUT (analog) */
	unsigned short status;
	plcstring msg_err[81];
	plcstring recipe[21];
	unsigned long nr_csv_read;
	/* VAR (analog) */
	unsigned char step;
	unsigned char set_device;
	struct DirInfo DInfo;
	struct DirRead DRead;
	struct fiDIR_READ_DATA ReadData;
	unsigned short get_sys_err;
	unsigned char prevstep;
	unsigned short len_name;
	unsigned long file_counter;
	unsigned long tot_files;
	unsigned char not_valid_csv;
	/* VAR_INPUT (digital) */
	plcbit enable;
} Rec_NameRead_typ;

typedef struct Rec_Import
{
	/* VAR_INPUT (analog) */
	plcstring recipe[21];
	/* VAR_OUTPUT (analog) */
	unsigned short status;
	plcstring msg_err[81];
	/* VAR (analog) */
	unsigned char step;
	unsigned short get_sys_err;
	unsigned short prevstep;
	plcstring recipecsv[25];
	struct FileCopy FCopy;
	/* VAR_INPUT (digital) */
	plcbit enable;
} Rec_Import_typ;

typedef struct Rec_Imp_All
{
	/* VAR_OUTPUT (analog) */
	unsigned short status;
	plcstring msg_err[81];
	unsigned long nr_csv_imported;
	plcstring recipe_imp[81];
	/* VAR (analog) */
	plcstring recipe[261];
	struct Rec_NameRead read_name;
	struct Rec_Import rec_imp;
	unsigned char step;
	unsigned short get_sys_err;
	unsigned char prevstep;
	/* VAR_INPUT (digital) */
	plcbit enable;
} Rec_Imp_All_typ;

typedef struct Rec_Export
{
	/* VAR_INPUT (analog) */
	plcstring recipe[21];
	/* VAR_OUTPUT (analog) */
	unsigned short status;
	plcstring msg_err[81];
	/* VAR (analog) */
	unsigned char step;
	unsigned short get_sys_err;
	unsigned short prevstep;
	plcstring recipecsv[25];
	struct FileCopy FCopy;
	/* VAR_INPUT (digital) */
	plcbit enable;
} Rec_Export_typ;

typedef struct Rec_Exp_All
{
	/* VAR_OUTPUT (analog) */
	unsigned short status;
	plcstring msg_err[81];
	/* VAR (analog) */
	plcstring recipe[261];
	struct Rec_NameRead read_name;
	struct Rec_Export rec_exp;
	unsigned char step;
	unsigned short get_sys_err;
	unsigned char prevstep;
	/* VAR_INPUT (digital) */
	plcbit enable;
} Rec_Exp_All_typ;

typedef struct Rec_Upload
{
	/* VAR_INPUT (analog) */
	plcstring structure[16];
	plcstring recipe[21];
	unsigned long ident;
	/* VAR_OUTPUT (analog) */
	unsigned short status;
	plcstring msg_err[81];
	/* VAR (analog) */
	plcstring recipecsv[25];
	unsigned char step;
	unsigned long offset;
	unsigned long k;
	unsigned long j;
	unsigned char ascii_infile[22];
	struct gs_typ gs;
	struct FileOpen FOpen;
	struct FileRead FRead;
	struct FileClose FClose;
	unsigned short get_sys_err;
	unsigned char repeat_switch;
	unsigned char prevstep;
	struct AsMemPartAlloc mem_part_all;
	struct AsMemPartFree mem_part_free;
	unsigned char limit;
	unsigned short tmp_status;
	/* VAR_INPUT (digital) */
	plcbit enable;
	plcbit speed_option;
	/* VAR (digital) */
	plcbit mem_allocated;
} Rec_Upload_typ;

typedef struct Rec_Delete
{
	/* VAR_INPUT (analog) */
	plcstring recipe[21];
	/* VAR_OUTPUT (analog) */
	unsigned short status;
	plcstring msg_err[81];
	/* VAR (analog) */
	plcstring recipecsv[25];
	unsigned char step;
	struct FileDelete FDelete;
	unsigned short get_sys_err;
	unsigned char prevstep;
	/* VAR_INPUT (digital) */
	plcbit enable;
} Rec_Delete_typ;

typedef struct Rec_Init
{
	/* VAR_OUTPUT (analog) */
	unsigned long ident;
	unsigned short status;
	plcstring msg_err[81];
	/* VAR (analog) */
	unsigned char step;
	struct DirCreate dir_create;
	unsigned char prevstep;
	struct AsMemPartCreate mem_part_create;
	/* VAR_INPUT (digital) */
	plcbit enable;
} Rec_Init_typ;



/* Prototyping of functions and function blocks */
_BUR_PUBLIC void Rec_get_comm(struct Rec_get_comm* inst);
_BUR_PUBLIC void Rec_Write(struct Rec_Write* inst);
_BUR_PUBLIC void Rec_NameRead(struct Rec_NameRead* inst);
_BUR_PUBLIC void Rec_Import(struct Rec_Import* inst);
_BUR_PUBLIC void Rec_Imp_All(struct Rec_Imp_All* inst);
_BUR_PUBLIC void Rec_Export(struct Rec_Export* inst);
_BUR_PUBLIC void Rec_Exp_All(struct Rec_Exp_All* inst);
_BUR_PUBLIC void Rec_Upload(struct Rec_Upload* inst);
_BUR_PUBLIC void Rec_Delete(struct Rec_Delete* inst);
_BUR_PUBLIC void Rec_Init(struct Rec_Init* inst);


#ifdef __cplusplus
};
#endif
#endif /* _RECIPE_ */


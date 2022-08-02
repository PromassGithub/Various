export AS_SYSTEM_PATH := C:/Program\ Files/BrAutomation/AS/System
export AS_BIN_PATH := C:/Program Files/BrAutomation/AS49/bin-en
export AS_INSTALL_PATH := C:/Program\ Files/BrAutomation/AS49
export AS_PATH := C:/Program Files/BrAutomation/AS49
export AS_VC_PATH := C:/Program\ Files/BrAutomation/AS49/AS/VC
export AS_GNU_INST_PATH := C:/Program\ Files/BrAutomation/AS49/AS/gnuinst/V4.1.2
export AS_STATIC_ARCHIVES_PATH := C:/projects/MM_movim_manuale/Temp/Archives/Config1/X20CP1301
export AS_CPU_PATH := C:/projects/MM_movim_manuale/Temp/Objects/Config1/X20CP1301
export AS_CPU_PATH_2 := C:/projects/MM_movim_manuale/Temp/Objects/Config1/X20CP1301
export AS_TEMP_PATH := C:/projects/MM_movim_manuale/Temp
export AS_BINARIES_PATH := C:/projects/MM_movim_manuale/Binaries
export AS_PROJECT_CPU_PATH := C:/projects/MM_movim_manuale/Physical/Config1/X20CP1301
export AS_PROJECT_CONFIG_PATH := C:/projects/MM_movim_manuale/Physical/Config1
export AS_PROJECT_PATH := C:/projects/MM_movim_manuale
export AS_PROJECT_NAME := MM_movim_manuale
export AS_PLC := X20CP1301
export AS_TEMP_PLC := X20CP1301
export AS_USER_NAME := giaco
export AS_CONFIGURATION := Config1
export AS_COMPANY_NAME := \ 
export AS_VERSION := 4.9.5.36\ SP
export AS_WORKINGVERSION := 4.9


default: \
	$(AS_CPU_PATH)/Visu.br \
	vcPostBuild_Visu \



include $(AS_CPU_PATH)/Visu/Visu.mak

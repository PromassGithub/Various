export AS_BUILD_MODE := BuildAndCreateCompactFlash
export AS_SYSTEM_PATH := C:/Program\ Files/BrAutomation/AS/System
export AS_BIN_PATH := C:/Program Files/BrAutomation/AS49/bin-en
export AS_INSTALL_PATH := C:/Program\ Files/BrAutomation/AS49
export AS_PATH := C:/Program Files/BrAutomation/AS49
export AS_VC_PATH := C:/Program\ Files/BrAutomation/AS49/AS/VC
export AS_GNU_INST_PATH := C:/Program\ Files/BrAutomation/AS49/AS/gnuinst/V4.1.2
export AS_STATIC_ARCHIVES_PATH := C:/project/GITH_HUB/Various/test33/Temp/Archives/Config1/5PPC2100_BY34_000
export AS_CPU_PATH := C:/project/GITH_HUB/Various/test33/Temp/Objects/Config1/5PPC2100_BY34_000
export AS_CPU_PATH_2 := C:/project/GITH_HUB/Various/test33/Temp/Objects/Config1/5PPC2100_BY34_000
export AS_TEMP_PATH := C:/project/GITH_HUB/Various/test33/Temp
export AS_BINARIES_PATH := C:/project/GITH_HUB/Various/test33/Binaries
export AS_PROJECT_CPU_PATH := C:/project/GITH_HUB/Various/test33/Physical/Config1/5PPC2100_BY34_000
export AS_PROJECT_CONFIG_PATH := C:/project/GITH_HUB/Various/test33/Physical/Config1
export AS_PROJECT_PATH := C:/project/GITH_HUB/Various/test33
export AS_PROJECT_NAME := test33
export AS_PLC := 5PPC2100_BY34_000
export AS_TEMP_PLC := 5PPC2100_BY34_000
export AS_USER_NAME := giaco
export AS_CONFIGURATION := Config1
export AS_COMPANY_NAME := \ 
export AS_VERSION := 4.9.6.42\ SP
export AS_WORKINGVERSION := 4.9


default: \
	$(AS_CPU_PATH)/Visu.br \



include $(AS_CPU_PATH)/Visu/Visu.mak

export AS_SYSTEM_PATH := C:/BrAutomation/AS/System
export AS_BIN_PATH := C:/BrAutomation/AS49/bin-en
export AS_INSTALL_PATH := C:/BrAutomation/AS49
export AS_PATH := C:/BrAutomation/AS49
export AS_VC_PATH := C:/BrAutomation/AS49/AS/VC
export AS_GNU_INST_PATH := C:/BrAutomation/AS49/AS/gnuinst/V4.1.2
export AS_STATIC_ARCHIVES_PATH := C:/projects/GitH/Various/PLANT_CONTROLLER/WRAPPER_CTRL/Temp/Archives/Errepi_P00936/X20CP1301
export AS_CPU_PATH := C:/projects/GitH/Various/PLANT_CONTROLLER/WRAPPER_CTRL/Temp/Objects/Errepi_P00936/X20CP1301
export AS_CPU_PATH_2 := C:/projects/GitH/Various/PLANT_CONTROLLER/WRAPPER_CTRL/Temp/Objects/Errepi_P00936/X20CP1301
export AS_TEMP_PATH := C:/projects/GitH/Various/PLANT_CONTROLLER/WRAPPER_CTRL/Temp
export AS_BINARIES_PATH := C:/projects/GitH/Various/PLANT_CONTROLLER/WRAPPER_CTRL/Binaries
export AS_PROJECT_CPU_PATH := C:/projects/GitH/Various/PLANT_CONTROLLER/WRAPPER_CTRL/Physical/Errepi_P00936/X20CP1301
export AS_PROJECT_CONFIG_PATH := C:/projects/GitH/Various/PLANT_CONTROLLER/WRAPPER_CTRL/Physical/Errepi_P00936
export AS_PROJECT_PATH := C:/projects/GitH/Various/PLANT_CONTROLLER/WRAPPER_CTRL
export AS_PROJECT_NAME := WRAPPER_CTRL
export AS_PLC := X20CP1301
export AS_TEMP_PLC := X20CP1301
export AS_USER_NAME := Stefano
export AS_CONFIGURATION := Errepi_P00936
export AS_COMPANY_NAME := \ 
export AS_VERSION := 4.9.5.36\ SP
export AS_WORKINGVERSION := 4.9


default: \
	$(AS_CPU_PATH)/Visu.br \
	vcPostBuild_Visu \



include $(AS_CPU_PATH)/Visu/Visu.mak

SHELL := cmd.exe
CYGWIN=nontsec
export PATH := C:\Program Files (x86)\Schneider Electric\EcoStruxure Machine SCADA Expert 2020\Bin;C:\app\edomi\product\11.2.0\client_1\bin;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Program Files (x86)\NVIDIA Corporation\PhysX\Common;C:\Program Files\NVIDIA Corporation\NVIDIA NvDLISR;C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.0\;C:\Program Files (x86)\OMRON\Communications Middleware\assembly\;C:\Program Files (x86)\Schneider Electric\EcoStruxure Machine Expert - Basic\;C:\Program Files\WireGuard\;C:\Users\edomi\AppData\Local\Microsoft\WindowsApps;C:\Users\edomi\AppData\Local\GitHubDesktop\bin;C:\Program Files (x86)\Common Files\Hilscher GmbH\TLRDecode;C:\Users\edomi\AppData\Local\Microsoft\WindowsApps;C:\Users\edomi\AppData\Local\GitHubDesktop\bin;C:\Program Files (x86)\Common Files\Hilscher GmbH\TLRDecode;C:\BrAutomation\AS49\Bin-en\4.9;C:\BrAutomation\AS49\Bin-en\4.8;C:\BrAutomation\AS49\Bin-en\4.7;C:\BrAutomation\AS49\Bin-en\4.6;C:\BrAutomation\AS49\Bin-en\4.5;C:\BrAutomation\AS49\Bin-en\4.4;C:\BrAutomation\AS49\Bin-en\4.3;C:\BrAutomation\AS49\Bin-en\4.2;C:\BrAutomation\AS49\Bin-en\4.1;C:\BrAutomation\AS49\Bin-en\4.0;C:\BrAutomation\AS49\Bin-en
export AS_BUILD_MODE := BuildAndTransfer
export AS_VERSION := 4.9.6.42 SP
export AS_WORKINGVERSION := 4.9
export AS_COMPANY_NAME :=  
export AS_USER_NAME := edomi
export AS_PATH := C:/BrAutomation/AS49
export AS_BIN_PATH := C:/BrAutomation/AS49/Bin-en
export AS_PROJECT_PATH := C:/projects/GIT_HUB/Various/ModbusMST
export AS_PROJECT_NAME := ModbusMST
export AS_SYSTEM_PATH := C:/BrAutomation/AS/System
export AS_VC_PATH := C:/BrAutomation/AS49/AS/VC
export AS_TEMP_PATH := C:/projects/GIT_HUB/Various/ModbusMST/Temp
export AS_CONFIGURATION := 1382
export AS_BINARIES_PATH := C:/projects/GIT_HUB/Various/ModbusMST/Binaries
export AS_GNU_INST_PATH := C:/BrAutomation/AS49/AS/GnuInst/V4.1.2
export AS_GNU_BIN_PATH := C:/BrAutomation/AS49/AS/GnuInst/V4.1.2/4.9/bin
export AS_GNU_INST_PATH_SUB_MAKE := C:/BrAutomation/AS49/AS/GnuInst/V4.1.2
export AS_GNU_BIN_PATH_SUB_MAKE := C:/BrAutomation/AS49/AS/GnuInst/V4.1.2/4.9/bin
export AS_INSTALL_PATH := C:/BrAutomation/AS49
export WIN32_AS_PATH := "C:\BrAutomation\AS49"
export WIN32_AS_BIN_PATH := "C:\BrAutomation\AS49\Bin-en"
export WIN32_AS_PROJECT_PATH := "C:\projects\GIT_HUB\Various\ModbusMST"
export WIN32_AS_SYSTEM_PATH := "C:\BrAutomation\AS\System"
export WIN32_AS_VC_PATH := "C:\BrAutomation\AS49\AS\VC"
export WIN32_AS_TEMP_PATH := "C:\projects\GIT_HUB\Various\ModbusMST\Temp"
export WIN32_AS_BINARIES_PATH := "C:\projects\GIT_HUB\Various\ModbusMST\Binaries"
export WIN32_AS_GNU_INST_PATH := "C:\BrAutomation\AS49\AS\GnuInst\V4.1.2"
export WIN32_AS_GNU_BIN_PATH := "C:\BrAutomation\AS49\AS\GnuInst\V4.1.2\bin"
export WIN32_AS_INSTALL_PATH := "C:\BrAutomation\AS49"

.suffixes:

ProjectMakeFile:

	@'$(AS_BIN_PATH)/4.9/BR.AS.AnalyseProject.exe' '$(AS_PROJECT_PATH)/ModbusMST.apj' -t '$(AS_TEMP_PATH)' -c '$(AS_CONFIGURATION)' -o '$(AS_BINARIES_PATH)'   -sfas -buildMode 'BuildAndTransfer'   


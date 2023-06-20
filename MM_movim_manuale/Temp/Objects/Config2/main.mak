SHELL := cmd.exe
CYGWIN=nontsec
export PATH := C:\Program Files (x86)\VMware\VMware Player\bin\;C:\app\giaco\product\11.2.0\client_1\bin;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Program Files (x86)\NVIDIA Corporation\PhysX\Common;C:\Program Files\NVIDIA Corporation\NVIDIA NvDLISR;C:\DeltaTau\PowerPMACSim\opt\ppmac\MinGW\bin;C:\Program Files\PuTTY\;C:\Users\giaco\AppData\Local\Microsoft\WindowsApps;C:\Users\giaco\AppData\Local\GitHubDesktop\bin;C:\Program Files (x86)\Common Files\Hilscher GmbH\TLRDecode;C:\Users\giaco\AppData\Local\Microsoft\WindowsApps;C:\Users\giaco\AppData\Local\GitHubDesktop\bin;C:\Program Files (x86)\Common Files\Hilscher GmbH\TLRDecode;C:\Program Files\BrAutomation\AS49\bin-en\4.9;C:\Program Files\BrAutomation\AS49\bin-en\4.8;C:\Program Files\BrAutomation\AS49\bin-en\4.7;C:\Program Files\BrAutomation\AS49\bin-en\4.6;C:\Program Files\BrAutomation\AS49\bin-en\4.5;C:\Program Files\BrAutomation\AS49\bin-en\4.4;C:\Program Files\BrAutomation\AS49\bin-en\4.3;C:\Program Files\BrAutomation\AS49\bin-en\4.2;C:\Program Files\BrAutomation\AS49\bin-en\4.1;C:\Program Files\BrAutomation\AS49\bin-en\4.0;C:\Program Files\BrAutomation\AS49\bin-en
export AS_BUILD_MODE := BuildAndTransfer
export AS_VERSION := 4.9.5.36 SP
export AS_WORKINGVERSION := 4.9
export AS_COMPANY_NAME :=  
export AS_USER_NAME := giaco
export AS_PATH := C:/Program Files/BrAutomation/AS49
export AS_BIN_PATH := C:/Program Files/BrAutomation/AS49/bin-en
export AS_PROJECT_PATH := C:/project/GITH_HUB/Various/MM_movim_manuale
export AS_PROJECT_NAME := MM_movim_manuale
export AS_SYSTEM_PATH := C:/Program\ Files/BrAutomation/AS/System
export AS_VC_PATH := C:/Program\ Files/BrAutomation/AS49/AS/VC
export AS_TEMP_PATH := C:/project/GITH_HUB/Various/MM_movim_manuale/Temp
export AS_CONFIGURATION := Config2
export AS_BINARIES_PATH := C:/project/GITH_HUB/Various/MM_movim_manuale/Binaries
export AS_GNU_INST_PATH := C:/Program\ Files/BrAutomation/AS49/AS/GnuInst/V4.1.2
export AS_GNU_BIN_PATH := C:/Program\ Files/BrAutomation/AS49/AS/GnuInst/V4.1.2/4.9/bin
export AS_GNU_INST_PATH_SUB_MAKE := C:/Program Files/BrAutomation/AS49/AS/GnuInst/V4.1.2
export AS_GNU_BIN_PATH_SUB_MAKE := C:/Program Files/BrAutomation/AS49/AS/GnuInst/V4.1.2/4.9/bin
export AS_INSTALL_PATH := C:/Program\ Files/BrAutomation/AS49
export WIN32_AS_PATH := "C:\Program Files\BrAutomation\AS49"
export WIN32_AS_BIN_PATH := "C:\Program Files\BrAutomation\AS49\bin-en"
export WIN32_AS_PROJECT_PATH := "C:\project\GITH_HUB\Various\MM_movim_manuale"
export WIN32_AS_SYSTEM_PATH := "C:\Program Files\BrAutomation\AS\System"
export WIN32_AS_VC_PATH := "C:\Program Files\BrAutomation\AS49\AS\VC"
export WIN32_AS_TEMP_PATH := "C:\project\GITH_HUB\Various\MM_movim_manuale\Temp"
export WIN32_AS_BINARIES_PATH := "C:\project\GITH_HUB\Various\MM_movim_manuale\Binaries"
export WIN32_AS_GNU_INST_PATH := "C:\Program Files\BrAutomation\AS49\AS\GnuInst\V4.1.2"
export WIN32_AS_GNU_BIN_PATH := "$(WIN32_AS_GNU_INST_PATH)\\bin"
export WIN32_AS_INSTALL_PATH := "C:\Program Files\BrAutomation\AS49"

.suffixes:

ProjectMakeFile:

	@'$(AS_BIN_PATH)/4.9/BR.AS.AnalyseProject.exe' '$(AS_PROJECT_PATH)/MM_movim_manuale.apj' -t '$(AS_TEMP_PATH)' -c '$(AS_CONFIGURATION)' -o '$(AS_BINARIES_PATH)'   -sfas -buildMode 'BuildAndTransfer'   


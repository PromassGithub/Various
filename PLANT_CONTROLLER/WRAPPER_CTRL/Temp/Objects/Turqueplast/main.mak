SHELL := cmd.exe
CYGWIN=nontsec
export PATH := C:\Program Files (x86)\VMware\VMware Workstation\bin\;C:\Program Files\Microsoft\jdk-11.0.12.7-hotspot\bin;C:\app\steve\product\11.2.0\client_1\bin;Z:\app\stefa\product\11.2.0\client_1\bin;Z:\app\stefa\product\11.2.0\client_1;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Program Files (x86)\NVIDIA Corporation\PhysX\Common;C:\Program Files\NVIDIA Corporation\NVIDIA NvDLISR;C:\DeltaTau\PowerPMACSim\opt\ppmac\MinGW\bin;C:\Program Files\WireGuard\;C:\Program Files\dotnet\;C:\Program Files\Calibre2\;C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.0\;C:\Program Files (x86)\AOMEI\AOMEI Backupper\6.9.1;C:\Program Files (x86)\dotnet\;C:\Program Files (x86)\OMRON\Communications Middleware\assembly\;C:\Users\Stefano\AppData\Local\Microsoft\WindowsApps;C:\Users\Stefano\AppData\Local\GitHubDesktop\bin;C:\Users\Stefano\AppData\Local\Programs\Microsoft VS Code\bin;C:\Program Files (x86)\Common Files\Hilscher GmbH\TLRDecode;Z:\app\stefa\product\11.2.0\client_1;C:\Users\Stefano\AppData\Local\Microsoft\WindowsApps;C:\Users\Stefano\AppData\Local\GitHubDesktop\bin;C:\Users\Stefano\AppData\Local\Programs\Microsoft VS Code\bin;C:\Program Files (x86)\Common Files\Hilscher GmbH\TLRDecode;C:\BrAutomation\AS49\bin-en\4.9;C:\BrAutomation\AS49\bin-en\4.8;C:\BrAutomation\AS49\bin-en\4.7;C:\BrAutomation\AS49\bin-en\4.6;C:\BrAutomation\AS49\bin-en\4.5;C:\BrAutomation\AS49\bin-en\4.4;C:\BrAutomation\AS49\bin-en\4.3;C:\BrAutomation\AS49\bin-en\4.2;C:\BrAutomation\AS49\bin-en\4.1;C:\BrAutomation\AS49\bin-en\4.0;C:\BrAutomation\AS49\bin-en
export AS_BUILD_MODE := BuildAndTransfer
export AS_VERSION := 4.9.5.36 SP
export AS_WORKINGVERSION := 4.9
export AS_COMPANY_NAME :=  
export AS_USER_NAME := Stefano
export AS_PATH := C:/BrAutomation/AS49
export AS_BIN_PATH := C:/BrAutomation/AS49/bin-en
export AS_PROJECT_PATH := C:/projects/GitH/Various/PLANT_CONTROLLER/WRAPPER_CTRL
export AS_PROJECT_NAME := WRAPPER_CTRL
export AS_SYSTEM_PATH := C:/BrAutomation/AS/System
export AS_VC_PATH := C:/BrAutomation/AS49/AS/VC
export AS_TEMP_PATH := C:/projects/GitH/Various/PLANT_CONTROLLER/WRAPPER_CTRL/Temp
export AS_CONFIGURATION := Turqueplast
export AS_BINARIES_PATH := C:/projects/GitH/Various/PLANT_CONTROLLER/WRAPPER_CTRL/Binaries
export AS_GNU_INST_PATH := C:/BrAutomation/AS49/AS/GnuInst/V4.1.2
export AS_GNU_BIN_PATH := C:/BrAutomation/AS49/AS/GnuInst/V4.1.2/4.9/bin
export AS_GNU_INST_PATH_SUB_MAKE := C:/BrAutomation/AS49/AS/GnuInst/V4.1.2
export AS_GNU_BIN_PATH_SUB_MAKE := C:/BrAutomation/AS49/AS/GnuInst/V4.1.2/4.9/bin
export AS_INSTALL_PATH := C:/BrAutomation/AS49
export WIN32_AS_PATH := "C:\BrAutomation\AS49"
export WIN32_AS_BIN_PATH := "C:\BrAutomation\AS49\bin-en"
export WIN32_AS_PROJECT_PATH := "C:\projects\GitH\Various\PLANT_CONTROLLER\WRAPPER_CTRL"
export WIN32_AS_SYSTEM_PATH := "C:\BrAutomation\AS\System"
export WIN32_AS_VC_PATH := "C:\BrAutomation\AS49\AS\VC"
export WIN32_AS_TEMP_PATH := "C:\projects\GitH\Various\PLANT_CONTROLLER\WRAPPER_CTRL\Temp"
export WIN32_AS_BINARIES_PATH := "C:\projects\GitH\Various\PLANT_CONTROLLER\WRAPPER_CTRL\Binaries"
export WIN32_AS_GNU_INST_PATH := "C:\BrAutomation\AS49\AS\GnuInst\V4.1.2"
export WIN32_AS_GNU_BIN_PATH := "$(WIN32_AS_GNU_INST_PATH)\\bin"
export WIN32_AS_INSTALL_PATH := "C:\BrAutomation\AS49"

.suffixes:

ProjectMakeFile:

	@'$(AS_BIN_PATH)/4.9/BR.AS.AnalyseProject.exe' '$(AS_PROJECT_PATH)/WRAPPER_CTRL.apj' -t '$(AS_TEMP_PATH)' -c '$(AS_CONFIGURATION)' -o '$(AS_BINARIES_PATH)'   -sfas -buildMode 'BuildAndTransfer'   


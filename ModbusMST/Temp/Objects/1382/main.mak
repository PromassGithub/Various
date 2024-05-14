SHELL := cmd.exe
CYGWIN=nontsec
export PATH := C:\Program Files (x86)\VMware\VMware Workstation\bin\;C:\TwinCAT\Common64;C:\TwinCAT\Common32;C:\Program Files (x86)\Schneider Electric\EcoStruxure Machine SCADA Expert 2023\Bin;C:\Program Files (x86)\Schneider Electric\EcoStruxure Machine SCADA Expert 2020\Bin;C:\app\steve\product\11.2.0\client_1\bin;Z:\app\stefa\product\11.2.0\client_1\bin;Z:\app\stefa\product\11.2.0\client_1;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Program Files\WireGuard\;C:\Program Files\dotnet\;C:\Program Files\Calibre2\;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Program Files (x86)\dotnet\;C:\platform-tools;C:\Program Files (x86)\AOMEI\AOMEI Backupper\7.2.1;C:\Program Files (x86)\Schneider Electric\EcoStruxure Machine Expert - Basic\;C:\ProgramData\chocolatey\bin;C:\Program Files (x86)\OMRON\Communications Middleware\assembly\;C:\Program Files (x86)\Schneider Electric\Schneider Electric Software Installer\;C:\Program Files (x86)\NVIDIA Corporation\PhysX\Common;C:\Program Files\NVIDIA Corporation\NVIDIA NvDLISR;C:\Program Files\Microsoft SQL Server\150\Tools\Binn\;C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\;C:\Program Files (x86)\Windows Kits\10\Windows Performance Toolkit\;C:\Program Files\Arduino PLC IDE Tools\;C:\Users\Stefano\AppData\Local\Programs\Python\Launcher\;C:\Users\Stefano\AppData\Local\Microsoft\WindowsApps;C:\Users\Stefano\AppData\Local\GitHubDesktop\bin;C:\Users\Stefano\AppData\Local\Programs\Microsoft VS Code\bin;C:\Program Files (x86)\Nmap;C:\Users\Stefano\AppData\Local\Programs\Python\Launcher\;Z:\app\stefa\product\11.2.0\client_1;C:\Users\Stefano\AppData\Local\Microsoft\WindowsApps;C:\Users\Stefano\AppData\Local\GitHubDesktop\bin;C:\Users\Stefano\AppData\Local\Programs\Microsoft VS Code\bin;C:\Program Files (x86)\Nmap;C:\BrAutomation\AS49\bin-en\4.9;C:\BrAutomation\AS49\bin-en\4.8;C:\BrAutomation\AS49\bin-en\4.7;C:\BrAutomation\AS49\bin-en\4.6;C:\BrAutomation\AS49\bin-en\4.5;C:\BrAutomation\AS49\bin-en\4.4;C:\BrAutomation\AS49\bin-en\4.3;C:\BrAutomation\AS49\bin-en\4.2;C:\BrAutomation\AS49\bin-en\4.1;C:\BrAutomation\AS49\bin-en\4.0;C:\BrAutomation\AS49\bin-en
export AS_BUILD_MODE := BuildAndTransfer
export AS_VERSION := 4.9.6.42 SP
export AS_WORKINGVERSION := 4.9
export AS_COMPANY_NAME :=  
export AS_USER_NAME := Stefano
export AS_PATH := C:/BrAutomation/AS49
export AS_BIN_PATH := C:/BrAutomation/AS49/bin-en
export AS_PROJECT_PATH := C:/projects/ModbusMST
export AS_PROJECT_NAME := ModbusMST
export AS_SYSTEM_PATH := C:/BrAutomation/AS/System
export AS_VC_PATH := C:/BrAutomation/AS49/AS/VC
export AS_TEMP_PATH := C:/projects/ModbusMST/Temp
export AS_CONFIGURATION := 1382
export AS_BINARIES_PATH := C:/projects/ModbusMST/Binaries
export AS_GNU_INST_PATH := C:/BrAutomation/AS49/AS/GnuInst/V4.1.2
export AS_GNU_BIN_PATH := C:/BrAutomation/AS49/AS/GnuInst/V4.1.2/4.9/bin
export AS_GNU_INST_PATH_SUB_MAKE := C:/BrAutomation/AS49/AS/GnuInst/V4.1.2
export AS_GNU_BIN_PATH_SUB_MAKE := C:/BrAutomation/AS49/AS/GnuInst/V4.1.2/4.9/bin
export AS_INSTALL_PATH := C:/BrAutomation/AS49
export WIN32_AS_PATH := "C:\BrAutomation\AS49"
export WIN32_AS_BIN_PATH := "C:\BrAutomation\AS49\bin-en"
export WIN32_AS_PROJECT_PATH := "C:\projects\ModbusMST"
export WIN32_AS_SYSTEM_PATH := "C:\BrAutomation\AS\System"
export WIN32_AS_VC_PATH := "C:\BrAutomation\AS49\AS\VC"
export WIN32_AS_TEMP_PATH := "C:\projects\ModbusMST\Temp"
export WIN32_AS_BINARIES_PATH := "C:\projects\ModbusMST\Binaries"
export WIN32_AS_GNU_INST_PATH := "C:\BrAutomation\AS49\AS\GnuInst\V4.1.2"
export WIN32_AS_GNU_BIN_PATH := "C:\BrAutomation\AS49\AS\GnuInst\V4.1.2\bin"
export WIN32_AS_INSTALL_PATH := "C:\BrAutomation\AS49"

.suffixes:

ProjectMakeFile:

	@'$(AS_BIN_PATH)/4.9/BR.AS.AnalyseProject.exe' '$(AS_PROJECT_PATH)/ModbusMST.apj' -t '$(AS_TEMP_PATH)' -c '$(AS_CONFIGURATION)' -o '$(AS_BINARIES_PATH)'   -sfas -buildMode 'BuildAndTransfer'   


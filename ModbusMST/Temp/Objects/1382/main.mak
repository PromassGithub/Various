SHELL := cmd.exe
CYGWIN=nontsec
export PATH := C:\Oracle\instantclient\instantclient_23_4;C:\Users\giaco\miniconda3;C:\Python312\;C:\Program Files (x86)\VMware\VMware Player\bin\;C:\app\giaco\product\11.2.0\client_1\bin;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Program Files (x86)\NVIDIA Corporation\PhysX\Common;C:\DeltaTau\PowerPMACSim\opt\ppmac\MinGW\bin;C:\Program Files\PuTTY\;C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.0\;C:\Python312\Scripts\;C:\Program Files\NVIDIA Corporation\NVIDIA NvDLISR;C:\Program Files (x86)\PDFtk\bin\;C:\Program Files\poppler-24.02.0\Library\bin;C:\Python312\Lib\site-packages;C:\Program Files\Tesseract-OCR;D:\Programmi\page;C:\Program Files\WireGuard\;C:\Program Files\dotnet\;C:\Users\giaco\Desktop\trascrizioni\ffmpeg-2024-10-10-git-0f5592cfc7-full_build\bin;C:\Program Files (x86)\VMware\VMware Player\bin\;C:\app\giaco\product\11.2.0\client_1\bin;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Program Files (x86)\NVIDIA Corporation\PhysX\Common;C:\Program Files\NVIDIA Corporation\NVIDIA NvDLISR;C:\DeltaTau\PowerPMACSim\opt\ppmac\MinGW\bin;C:\Program Files\PuTTY\;C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.0\;C:\Users\giaco\AppData\Local\Microsoft\WindowsApps;C:\Users\giaco\AppData\Local\GitHubDesktop\bin;C:\Program Files (x86)\Common Files\Hilscher GmbH\TLRDecode;C:\Users\giaco\AppData\Roaming\Python\Python312\Scripts;C:\Program Files (x86)\VMware\VMware Player\bin\;C:\app\giaco\product\11.2.0\client_1\bin;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Program Files (x86)\NVIDIA Corporation\PhysX\Common;C:\Program Files\NVIDIA Corporation\NVIDIA NvDLISR;C:\DeltaTau\PowerPMACSim\opt\ppmac\MinGW\bin;C:\Program Files\PuTTY\;C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.0\;C:\Users\giaco\AppData\Local\Microsoft\WindowsApps;C:\Users\giaco\AppData\Local\GitHubDesktop\bin;C:\Program Files (x86)\Common Files\Hilscher GmbH\TLRDecode;C:\Users\giaco\AppData\Roaming\Python\Python312\Scripts;C:\Program Files\BrAutomation\AS49\Bin-en\4.9;C:\Program Files\BrAutomation\AS49\Bin-en\4.8;C:\Program Files\BrAutomation\AS49\Bin-en\4.7;C:\Program Files\BrAutomation\AS49\Bin-en\4.6;C:\Program Files\BrAutomation\AS49\Bin-en\4.5;C:\Program Files\BrAutomation\AS49\Bin-en\4.4;C:\Program Files\BrAutomation\AS49\Bin-en\4.3;C:\Program Files\BrAutomation\AS49\Bin-en\4.2;C:\Program Files\BrAutomation\AS49\Bin-en\4.1;C:\Program Files\BrAutomation\AS49\Bin-en\4.0;C:\Program Files\BrAutomation\AS49\Bin-en
export AS_BUILD_MODE := BuildAndTransfer
export AS_VERSION := 4.9.6.42 SP
export AS_WORKINGVERSION := 4.9
export AS_COMPANY_NAME :=  
export AS_USER_NAME := giaco
export AS_PATH := C:/Program Files/BrAutomation/AS49
export AS_BIN_PATH := C:/Program Files/BrAutomation/AS49/Bin-en
export AS_PROJECT_PATH := C:/project/GITH_HUB/Various/ModbusMST
export AS_PROJECT_NAME := ModbusMST
export AS_SYSTEM_PATH := C:/Program\ Files/BrAutomation/AS/System
export AS_VC_PATH := C:/Program\ Files/BrAutomation/AS49/AS/VC
export AS_TEMP_PATH := C:/project/GITH_HUB/Various/ModbusMST/Temp
export AS_CONFIGURATION := 1382
export AS_BINARIES_PATH := C:/project/GITH_HUB/Various/ModbusMST/Binaries
export AS_GNU_INST_PATH := C:/Program\ Files/BrAutomation/AS49/AS/GnuInst/V4.1.2
export AS_GNU_BIN_PATH := C:/Program\ Files/BrAutomation/AS49/AS/GnuInst/V4.1.2/4.9/bin
export AS_GNU_INST_PATH_SUB_MAKE := C:/Program Files/BrAutomation/AS49/AS/GnuInst/V4.1.2
export AS_GNU_BIN_PATH_SUB_MAKE := C:/Program Files/BrAutomation/AS49/AS/GnuInst/V4.1.2/4.9/bin
export AS_INSTALL_PATH := C:/Program\ Files/BrAutomation/AS49
export WIN32_AS_PATH := "C:\Program Files\BrAutomation\AS49"
export WIN32_AS_BIN_PATH := "C:\Program Files\BrAutomation\AS49\Bin-en"
export WIN32_AS_PROJECT_PATH := "C:\project\GITH_HUB\Various\ModbusMST"
export WIN32_AS_SYSTEM_PATH := "C:\Program Files\BrAutomation\AS\System"
export WIN32_AS_VC_PATH := "C:\Program Files\BrAutomation\AS49\AS\VC"
export WIN32_AS_TEMP_PATH := "C:\project\GITH_HUB\Various\ModbusMST\Temp"
export WIN32_AS_BINARIES_PATH := "C:\project\GITH_HUB\Various\ModbusMST\Binaries"
export WIN32_AS_GNU_INST_PATH := "C:\Program Files\BrAutomation\AS49\AS\GnuInst\V4.1.2"
export WIN32_AS_GNU_BIN_PATH := "C:\Program Files\BrAutomation\AS49\AS\GnuInst\V4.1.2\bin"
export WIN32_AS_INSTALL_PATH := "C:\Program Files\BrAutomation\AS49"

.suffixes:

ProjectMakeFile:

	@'$(AS_BIN_PATH)/4.9/BR.AS.AnalyseProject.exe' '$(AS_PROJECT_PATH)/ModbusMST.apj' -t '$(AS_TEMP_PATH)' -c '$(AS_CONFIGURATION)' -o '$(AS_BINARIES_PATH)'   -sfas -buildMode 'BuildAndTransfer'   


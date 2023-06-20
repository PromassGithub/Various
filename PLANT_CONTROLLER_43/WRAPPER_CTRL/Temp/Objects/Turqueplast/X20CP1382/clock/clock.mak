UnmarkedObjectFolder := C:/projects/BR/PLANT_CONTROLLER/WRAPPER_CTRL/Logical/clock
MarkedObjectFolder := C:/projects/BR/PLANT_CONTROLLER/WRAPPER_CTRL/Logical/clock

$(AS_CPU_PATH)/clock.br: \
	$(AS_PROJECT_CPU_PATH)/Cpu.per \
	$(AS_CPU_PATH)/clock/clock.ox
	@'$(AS_BIN_PATH)/BR.AS.TaskBuilder.exe' '$(AS_CPU_PATH)/clock/clock.ox' -o '$(AS_CPU_PATH)/clock.br' -v V0.00.0 -f '$(AS_CPU_PATH)/NT.ofs' -offsetLT '$(AS_BINARIES_PATH)/$(AS_CONFIGURATION)/$(AS_PLC)/LT.ofs' -T SG4  -M IA32  -B O4.34 -extConstants -r Cyclic1 -p 2 -s 'clock' -L 'AsIecCon: V*, astime: V*, FileIO: V*, operator: V*, runtime: V*, standard: V*' -P '$(AS_PROJECT_PATH)' -secret '$(AS_PROJECT_PATH)_br.as.taskbuilder.exe'

$(AS_CPU_PATH)/clock/clock.ox: \
	$(AS_CPU_PATH)/clock/a.out
	@'$(AS_BIN_PATH)/BR.AS.Backend.exe' '$(AS_CPU_PATH)/clock/a.out' -o '$(AS_CPU_PATH)/clock/clock.ox' -T SG4 -r Cyclic1   -G V4.1.2  -B O4.34 -secret '$(AS_PROJECT_PATH)_br.as.backend.exe'

$(AS_CPU_PATH)/clock/a.out: \
	$(AS_CPU_PATH)/clock/clock.c.o \
	$(AS_CPU_PATH)/clock/_bur_pvdef.c.o
	@'$(AS_BIN_PATH)/BR.AS.CCompiler.exe' -link '$(AS_CPU_PATH)/clock/clock.c.o' '$(AS_CPU_PATH)/clock/_bur_pvdef.c.o'  -o '$(AS_CPU_PATH)/clock/a.out'  -G V4.1.2  -T SG4  -M IA32  '-Wl,$(AS_SYSTEM_PATH)/O0434/SG4/IA32/libstandard.a' '-Wl,$(AS_SYSTEM_PATH)/O0434/SG4/IA32/libFileIO.a' '-Wl,$(AS_SYSTEM_PATH)/O0434/SG4/IA32/libAsIecCon.a' '-Wl,$(AS_SYSTEM_PATH)/O0434/SG4/IA32/libastime.a' '-Wl,$(AS_SYSTEM_PATH)/O0434/SG4/IA32/libruntime.a' '-Wl,$(AS_SYSTEM_PATH)/O0434/SG4/IA32/liboperator.a' -specs=I386specs_brelf -secret '$(AS_PROJECT_PATH)_br.as.ccompiler.exe'

$(AS_CPU_PATH)/clock/clock.c.o: \
	$(AS_PROJECT_PATH)/Logical/clock/clock.c \
	$(AS_PROJECT_PATH)/Logical/Libraries/astime/astime.fun \
	$(AS_PROJECT_PATH)/Logical/clock/clock.var \
	$(AS_PROJECT_PATH)/Logical/Global.var \
	$(AS_PROJECT_PATH)/Logical/Libraries/astime/astime.typ \
	$(AS_PROJECT_PATH)/Logical/Global.typ
	@'$(AS_BIN_PATH)/BR.AS.CCompiler.exe' '$(AS_PROJECT_PATH)/Logical/clock/clock.c' -o '$(AS_CPU_PATH)/clock/clock.c.o'  -T SG4  -M IA32  -B O4.34 -G V4.1.2  -s 'clock' -t '$(AS_TEMP_PATH)' -specs=I386specs_brelf -I '$(AS_PROJECT_PATH)/Logical/clock' '$(AS_TEMP_PATH)/Includes/clock' '$(AS_TEMP_PATH)/Includes' '$(AS_PROJECT_PATH)/Logical/GlobalIncludes' -trigraphs -fno-asm -D _DEFAULT_INCLUDES -D _SG4 -fPIC -O0 -g -Wall -include '$(AS_CPU_PATH)/Libraries.h' -x c -P '$(AS_PROJECT_PATH)' -secret '$(AS_PROJECT_PATH)_br.as.ccompiler.exe'

$(AS_CPU_PATH)/clock/_bur_pvdef.c.o: \
	$(AS_PROJECT_PATH)/Logical/Libraries/astime/astime.fun \
	$(AS_PROJECT_PATH)/Logical/clock/clock.var \
	$(AS_PROJECT_PATH)/Logical/Global.var \
	$(AS_PROJECT_PATH)/Logical/Libraries/astime/astime.typ \
	$(AS_PROJECT_PATH)/Logical/Global.typ
	@'$(AS_BIN_PATH)/BR.AS.CCompiler.exe' '$(AS_PATH)/AS/GnuInst/V4.1.2/i386-elf/include/bur/_bur_pvdef.c' -o '$(AS_CPU_PATH)/clock/_bur_pvdef.c.o'  -T SG4  -M IA32  -B O4.34 -G V4.1.2  -s 'clock' -t '$(AS_TEMP_PATH)' -specs=I386specs_brelf -I '$(AS_PROJECT_PATH)/Logical/clock' '$(AS_TEMP_PATH)/Includes/clock' '$(AS_TEMP_PATH)/Includes' '$(AS_PROJECT_PATH)/Logical/GlobalIncludes' -trigraphs -fno-asm -D _DEFAULT_INCLUDES -D _SG4 -fPIC -O0 -g -Wall -include '$(AS_CPU_PATH)/Libraries.h' -P '$(AS_PROJECT_PATH)' 
 -secret '$(AS_PROJECT_PATH)_br.as.ccompiler.exe'

-include $(AS_CPU_PATH)/Force.mak 


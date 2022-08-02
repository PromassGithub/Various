UnmarkedObjectFolder := C:/projects/BR/PLANT_CONTROLLER/WRAPPER_CTRL/Logical/main
MarkedObjectFolder := C:/projects/BR/PLANT_CONTROLLER/WRAPPER_CTRL/Logical/main

$(AS_CPU_PATH)/main.br: \
	$(AS_PROJECT_CPU_PATH)/Cpu.per \
	$(AS_CPU_PATH)/main/main.ox
	@'$(AS_BIN_PATH)/BR.AS.TaskBuilder.exe' '$(AS_CPU_PATH)/main/main.ox' -o '$(AS_CPU_PATH)/main.br' -v V1.00.0 -f '$(AS_CPU_PATH)/NT.ofs' -offsetLT '$(AS_BINARIES_PATH)/$(AS_CONFIGURATION)/$(AS_PLC)/LT.ofs' -T SG4  -M IA32  -B O4.34 -extConstants -d 'runtime: V* - V*,asieccon: V* - V*' -r Cyclic2 -p 2 -s 'main' -L 'AsIecCon: V*, astime: V*, FileIO: V*, operator: V*, runtime: V*, standard: V*' -P '$(AS_PROJECT_PATH)' -secret '$(AS_PROJECT_PATH)_br.as.taskbuilder.exe'

$(AS_CPU_PATH)/main/main.ox: \
	$(AS_CPU_PATH)/main/a.out
	@'$(AS_BIN_PATH)/BR.AS.Backend.exe' '$(AS_CPU_PATH)/main/a.out' -o '$(AS_CPU_PATH)/main/main.ox' -T SG4 -r Cyclic2   -G V4.1.2  -B O4.34 -secret '$(AS_PROJECT_PATH)_br.as.backend.exe'

$(AS_CPU_PATH)/main/a.out: \
	$(AS_CPU_PATH)/main/Cyclic.ld.o \
	$(AS_CPU_PATH)/main/Init.ld.o \
	$(AS_CPU_PATH)/main/Exit.ld.o \
	$(AS_CPU_PATH)/main/_bur_pvdef.st.o
	@'$(AS_BIN_PATH)/BR.AS.CCompiler.exe' -link '$(AS_CPU_PATH)/main/Cyclic.ld.o' '$(AS_CPU_PATH)/main/Init.ld.o' '$(AS_CPU_PATH)/main/Exit.ld.o' '$(AS_CPU_PATH)/main/_bur_pvdef.st.o'  -o '$(AS_CPU_PATH)/main/a.out'  -G V4.1.2  -T SG4  -M IA32  '-Wl,$(AS_SYSTEM_PATH)/O0434/SG4/IA32/libstandard.a' '-Wl,$(AS_SYSTEM_PATH)/O0434/SG4/IA32/libFileIO.a' '-Wl,$(AS_SYSTEM_PATH)/O0434/SG4/IA32/libAsIecCon.a' '-Wl,$(AS_SYSTEM_PATH)/O0434/SG4/IA32/libastime.a' '-Wl,$(AS_SYSTEM_PATH)/O0434/SG4/IA32/libruntime.a' '-Wl,$(AS_SYSTEM_PATH)/O0434/SG4/IA32/liboperator.a' -specs=I386specs_brelf -nostdlib -secret '$(AS_PROJECT_PATH)_br.as.ccompiler.exe'

$(AS_CPU_PATH)/main/Cyclic.ld.o: \
	$(AS_PROJECT_PATH)/Logical/main/Cyclic.ld \
	FORCE 
	@'$(AS_BIN_PATH)/BR.AS.IecCompiler.exe' '$(AS_PROJECT_PATH)/Logical/main/Cyclic.ld' -o '$(AS_CPU_PATH)/main/Cyclic.ld.o'  -T SG4  -M IA32  -B O4.34 -G V4.1.2  -s 'main' -t '$(AS_TEMP_PATH)' -pointers -extComments -extBitAccess -extConstants -D _SG4 -l '$(AS_PROJECT_PATH)/Logical/main/Types.typ' '$(AS_PROJECT_PATH)/Logical/main/Variables.var' -g '$(AS_PROJECT_PATH)/Logical/Libraries/operator/operator.typ' '$(AS_PROJECT_PATH)/Logical/Libraries/runtime/runtime.typ' '$(AS_PROJECT_PATH)/Logical/Libraries/astime/astime.typ' '$(AS_PROJECT_PATH)/Logical/Libraries/AsIecCon/AsIecCon.typ' '$(AS_PROJECT_PATH)/Logical/Libraries/FileIO/FileIO.typ' '$(AS_PROJECT_PATH)/Logical/Libraries/standard/standard.typ' '$(AS_PROJECT_PATH)/Logical/Libraries/operator/operator.fun' '$(AS_PROJECT_PATH)/Logical/Libraries/runtime/runtime.fun' '$(AS_PROJECT_PATH)/Logical/Libraries/astime/astime.fun' '$(AS_PROJECT_PATH)/Logical/Libraries/AsIecCon/AsIecCon.fun' '$(AS_PROJECT_PATH)/Logical/Libraries/FileIO/FileIO.fun' '$(AS_PROJECT_PATH)/Logical/Libraries/standard/standard.fun' '$(AS_PROJECT_PATH)/Logical/Libraries/operator/operator.var' '$(AS_PROJECT_PATH)/Logical/Libraries/runtime/runtime.var' '$(AS_PROJECT_PATH)/Logical/Libraries/astime/astime.var' '$(AS_PROJECT_PATH)/Logical/Libraries/AsIecCon/AsIecCon.var' '$(AS_PROJECT_PATH)/Logical/Libraries/FileIO/FileIO.var' '$(AS_PROJECT_PATH)/Logical/Libraries/standard/standard.var' '$(AS_PROJECT_PATH)/Logical/Global.typ' '$(AS_PROJECT_PATH)/Logical/Global.var'  -P '$(AS_PROJECT_PATH)' -secret '$(AS_PROJECT_PATH)_br.as.ieccompiler.exe'

$(AS_CPU_PATH)/main/Init.ld.o: \
	$(AS_PROJECT_PATH)/Logical/main/Init.ld \
	$(AS_PROJECT_PATH)/Logical/Libraries/standard/standard.fun \
	$(AS_PROJECT_PATH)/Logical/Libraries/runtime/runtime.fun \
	$(AS_PROJECT_PATH)/Logical/Global.var \
	$(AS_PROJECT_PATH)/Logical/Global.typ
	@'$(AS_BIN_PATH)/BR.AS.IecCompiler.exe' '$(AS_PROJECT_PATH)/Logical/main/Init.ld' -o '$(AS_CPU_PATH)/main/Init.ld.o'  -T SG4  -M IA32  -B O4.34 -G V4.1.2  -s 'main' -t '$(AS_TEMP_PATH)' -pointers -extComments -extBitAccess -extConstants -D _SG4 -l '$(AS_PROJECT_PATH)/Logical/main/Types.typ' '$(AS_PROJECT_PATH)/Logical/main/Variables.var' -g '$(AS_PROJECT_PATH)/Logical/Libraries/operator/operator.typ' '$(AS_PROJECT_PATH)/Logical/Libraries/runtime/runtime.typ' '$(AS_PROJECT_PATH)/Logical/Libraries/astime/astime.typ' '$(AS_PROJECT_PATH)/Logical/Libraries/AsIecCon/AsIecCon.typ' '$(AS_PROJECT_PATH)/Logical/Libraries/FileIO/FileIO.typ' '$(AS_PROJECT_PATH)/Logical/Libraries/standard/standard.typ' '$(AS_PROJECT_PATH)/Logical/Libraries/operator/operator.fun' '$(AS_PROJECT_PATH)/Logical/Libraries/runtime/runtime.fun' '$(AS_PROJECT_PATH)/Logical/Libraries/astime/astime.fun' '$(AS_PROJECT_PATH)/Logical/Libraries/AsIecCon/AsIecCon.fun' '$(AS_PROJECT_PATH)/Logical/Libraries/FileIO/FileIO.fun' '$(AS_PROJECT_PATH)/Logical/Libraries/standard/standard.fun' '$(AS_PROJECT_PATH)/Logical/Libraries/operator/operator.var' '$(AS_PROJECT_PATH)/Logical/Libraries/runtime/runtime.var' '$(AS_PROJECT_PATH)/Logical/Libraries/astime/astime.var' '$(AS_PROJECT_PATH)/Logical/Libraries/AsIecCon/AsIecCon.var' '$(AS_PROJECT_PATH)/Logical/Libraries/FileIO/FileIO.var' '$(AS_PROJECT_PATH)/Logical/Libraries/standard/standard.var' '$(AS_PROJECT_PATH)/Logical/Global.typ' '$(AS_PROJECT_PATH)/Logical/Global.var'  -P '$(AS_PROJECT_PATH)' -secret '$(AS_PROJECT_PATH)_br.as.ieccompiler.exe'

$(AS_CPU_PATH)/main/Exit.ld.o: \
	$(AS_PROJECT_PATH)/Logical/main/Exit.ld \
	$(AS_PROJECT_PATH)/Logical/Libraries/standard/standard.fun \
	$(AS_PROJECT_PATH)/Logical/Libraries/runtime/runtime.fun \
	$(AS_PROJECT_PATH)/Logical/Global.var \
	$(AS_PROJECT_PATH)/Logical/Global.typ
	@'$(AS_BIN_PATH)/BR.AS.IecCompiler.exe' '$(AS_PROJECT_PATH)/Logical/main/Exit.ld' -o '$(AS_CPU_PATH)/main/Exit.ld.o'  -T SG4  -M IA32  -B O4.34 -G V4.1.2  -s 'main' -t '$(AS_TEMP_PATH)' -pointers -extComments -extBitAccess -extConstants -D _SG4 -l '$(AS_PROJECT_PATH)/Logical/main/Types.typ' '$(AS_PROJECT_PATH)/Logical/main/Variables.var' -g '$(AS_PROJECT_PATH)/Logical/Libraries/operator/operator.typ' '$(AS_PROJECT_PATH)/Logical/Libraries/runtime/runtime.typ' '$(AS_PROJECT_PATH)/Logical/Libraries/astime/astime.typ' '$(AS_PROJECT_PATH)/Logical/Libraries/AsIecCon/AsIecCon.typ' '$(AS_PROJECT_PATH)/Logical/Libraries/FileIO/FileIO.typ' '$(AS_PROJECT_PATH)/Logical/Libraries/standard/standard.typ' '$(AS_PROJECT_PATH)/Logical/Libraries/operator/operator.fun' '$(AS_PROJECT_PATH)/Logical/Libraries/runtime/runtime.fun' '$(AS_PROJECT_PATH)/Logical/Libraries/astime/astime.fun' '$(AS_PROJECT_PATH)/Logical/Libraries/AsIecCon/AsIecCon.fun' '$(AS_PROJECT_PATH)/Logical/Libraries/FileIO/FileIO.fun' '$(AS_PROJECT_PATH)/Logical/Libraries/standard/standard.fun' '$(AS_PROJECT_PATH)/Logical/Libraries/operator/operator.var' '$(AS_PROJECT_PATH)/Logical/Libraries/runtime/runtime.var' '$(AS_PROJECT_PATH)/Logical/Libraries/astime/astime.var' '$(AS_PROJECT_PATH)/Logical/Libraries/AsIecCon/AsIecCon.var' '$(AS_PROJECT_PATH)/Logical/Libraries/FileIO/FileIO.var' '$(AS_PROJECT_PATH)/Logical/Libraries/standard/standard.var' '$(AS_PROJECT_PATH)/Logical/Global.typ' '$(AS_PROJECT_PATH)/Logical/Global.var'  -P '$(AS_PROJECT_PATH)' -secret '$(AS_PROJECT_PATH)_br.as.ieccompiler.exe'

$(AS_CPU_PATH)/main/_bur_pvdef.st.o: \
	FORCE  \
	$(AS_PROJECT_PATH)/Logical/Libraries/standard/standard.fun \
	$(AS_PROJECT_PATH)/Logical/Libraries/runtime/runtime.fun \
	$(AS_PROJECT_PATH)/Logical/Global.var \
	$(AS_PROJECT_PATH)/Logical/Global.typ
	@'$(AS_BIN_PATH)/BR.AS.IecCompiler.exe' '$(AS_PATH)/AS/GnuInst/V4.1.2/i386-elf/include/bur/_bur_pvdef.st' -o '$(AS_CPU_PATH)/main/_bur_pvdef.st.o'  -T SG4  -M IA32  -B O4.34 -G V4.1.2  -s 'main' -t '$(AS_TEMP_PATH)' -pointers -extComments -extBitAccess -extConstants -D _SG4 -l '$(AS_PROJECT_PATH)/Logical/main/Types.typ' '$(AS_PROJECT_PATH)/Logical/main/Variables.var' -g '$(AS_PROJECT_PATH)/Logical/Libraries/operator/operator.typ' '$(AS_PROJECT_PATH)/Logical/Libraries/runtime/runtime.typ' '$(AS_PROJECT_PATH)/Logical/Libraries/astime/astime.typ' '$(AS_PROJECT_PATH)/Logical/Libraries/AsIecCon/AsIecCon.typ' '$(AS_PROJECT_PATH)/Logical/Libraries/FileIO/FileIO.typ' '$(AS_PROJECT_PATH)/Logical/Libraries/standard/standard.typ' '$(AS_PROJECT_PATH)/Logical/Libraries/operator/operator.fun' '$(AS_PROJECT_PATH)/Logical/Libraries/runtime/runtime.fun' '$(AS_PROJECT_PATH)/Logical/Libraries/astime/astime.fun' '$(AS_PROJECT_PATH)/Logical/Libraries/AsIecCon/AsIecCon.fun' '$(AS_PROJECT_PATH)/Logical/Libraries/FileIO/FileIO.fun' '$(AS_PROJECT_PATH)/Logical/Libraries/standard/standard.fun' '$(AS_PROJECT_PATH)/Logical/Libraries/operator/operator.var' '$(AS_PROJECT_PATH)/Logical/Libraries/runtime/runtime.var' '$(AS_PROJECT_PATH)/Logical/Libraries/astime/astime.var' '$(AS_PROJECT_PATH)/Logical/Libraries/AsIecCon/AsIecCon.var' '$(AS_PROJECT_PATH)/Logical/Libraries/FileIO/FileIO.var' '$(AS_PROJECT_PATH)/Logical/Libraries/standard/standard.var' '$(AS_PROJECT_PATH)/Logical/Global.typ' '$(AS_PROJECT_PATH)/Logical/Global.var'  -P '$(AS_PROJECT_PATH)' 
 -secret '$(AS_PROJECT_PATH)_br.as.ieccompiler.exe'

-include $(AS_CPU_PATH)/Force.mak 


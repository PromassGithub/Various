######################################################
#                                                    #
# Automatic generated Makefile for Visual Components #
#                                                    #
#                  Do NOT edit!                      #
#                                                    #
######################################################

VCC:=@'$(AS_BIN_PATH)/br.vc.pc.exe'
LINK:=@'$(AS_BIN_PATH)/BR.VC.Link.exe'
MODGEN:=@'$(AS_BIN_PATH)/BR.VC.ModGen.exe'
VCPL:=@'$(AS_BIN_PATH)/BR.VC.PL.exe'
VCHWPP:=@'$(AS_BIN_PATH)/BR.VC.HWPP.exe'
VCDEP:=@'$(AS_BIN_PATH)/BR.VC.Depend.exe'
VCFLGEN:=@'$(AS_BIN_PATH)/BR.VC.lfgen.exe'
VCREFHANDLER:=@'$(AS_BIN_PATH)/BR.VC.CrossReferenceHandler.exe'
VCXREFEXTENDER:=@'$(AS_BIN_PATH)/BR.AS.CrossRefVCExtender.exe'
RM=CMD /C DEL
PALFILE_Visu=$(AS_PROJECT_PATH)/Logical/HMI/Visu/Palette.vcr
VCCFLAGS_Visu=-server -proj Visu -vc '$(AS_PROJECT_PATH)/Logical/HMI/Visu/VCObject.vc' -prj_path '$(AS_PROJECT_PATH)' -temp_path '$(AS_TEMP_PATH)' -cfg $(AS_CONFIGURATION) -plc $(AS_PLC) -plctemp $(AS_TEMP_PLC) -cpu_path '$(AS_CPU_PATH)'
VCFIRMWARE=4.72.7
VCFIRMWAREPATH=$(AS_VC_PATH)/Firmware/V4.72.7/SG4
VCOBJECT_Visu=$(AS_PROJECT_PATH)/Logical/HMI/Visu/VCObject.vc
VCSTARTUP='vcstart.br'
VCLOD='vclod.br'
VCSTPOST='vcstpost.br'
TARGET_FILE_Visu=$(AS_CPU_PATH)/Visu.br
OBJ_SCOPE_Visu=HMI
PRJ_PATH_Visu=$(AS_PROJECT_PATH)
SRC_PATH_Visu=$(AS_PROJECT_PATH)/Logical/$(OBJ_SCOPE_Visu)/Visu
TEMP_PATH_Visu=$(AS_TEMP_PATH)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/Visu
TEMP_PATH_Shared=$(AS_TEMP_PATH)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/VCShared
TEMP_PATH_ROOT_Visu=$(AS_TEMP_PATH)
VC_LIBRARY_LIST_Visu=$(TEMP_PATH_Visu)/libraries.vci
VC_XREF_BUILDFILE_Visu=$(AS_TEMP_PATH)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/vcxref.build
VC_XREF_CLEANFILE=$(AS_TEMP_PATH)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/vcxref.clean
VC_LANGUAGES_Visu=$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr
CPUHWC='$(TEMP_PATH_Visu)/cpuhwc.vci'
VC_STATIC_OPTIONS_Visu='$(TEMP_PATH_Visu)/vcStaticOptions.xml'
VC_STATIC_OPTIONS_Shared='$(TEMP_PATH_Shared)/vcStaticOptions.xml'
TTFFLAGS_Visu= -P '$(AS_PROJECT_PATH)' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo'

#
# Font lucon
#
ifneq ($(VC_FONT_lucon),1)
VC_FONT_lucon=1
$(AS_CPU_PATH)/VcFntDat/lucon.vco:$(AS_CPU_PATH)/VcFntDat/lucon.vci
	 $(VCC) -f '$<' -o '$@' $(TTFFLAGS_Visu) $(VCCFLAGS_Visu) -sfas

$(AS_CPU_PATH)/VcFntDat/lucon.ccf:$(AS_CPU_PATH)/VcFntDat/lucon.vco
	 $(LINK) '$^' -o '$@' -warningLevel2 -m lucon.ttf -name Visu -profile 'False' -vcr 4727 -sfas

$(AS_CPU_PATH)/lucon.br:$(AS_CPU_PATH)/VcFntDat/lucon.ccf
	 $(MODGEN) -so $(VC_STATIC_OPTIONS_Shared) -fw '$(VCFIRMWAREPATH)' -m $(VCLOD) -f '$<' -o '$@' -d vcgclass -v V1.00.0 -profile False -vc '$(VCOBJECT_Visu)' -b
endif

#
# Font arial
#
ifneq ($(VC_FONT_arial),1)
VC_FONT_arial=1
$(AS_CPU_PATH)/VcFntDat/arial.vco:$(AS_CPU_PATH)/VcFntDat/arial.vci
	 $(VCC) -f '$<' -o '$@' $(TTFFLAGS_Visu) $(VCCFLAGS_Visu) -sfas

$(AS_CPU_PATH)/VcFntDat/arial.ccf:$(AS_CPU_PATH)/VcFntDat/arial.vco
	 $(LINK) '$^' -o '$@' -warningLevel2 -m arial.ttf -name Visu -profile 'False' -vcr 4727 -sfas

$(AS_CPU_PATH)/arial.br:$(AS_CPU_PATH)/VcFntDat/arial.ccf
	 $(MODGEN) -so $(VC_STATIC_OPTIONS_Shared) -fw '$(VCFIRMWAREPATH)' -m $(VCLOD) -f '$<' -o '$@' -d vcgclass -v V1.00.0 -profile False -vc '$(VCOBJECT_Visu)' -b
endif

#
# Font segoeui
#
ifneq ($(VC_FONT_segoeui),1)
VC_FONT_segoeui=1
$(AS_CPU_PATH)/VcFntDat/segoeui.vco:$(AS_CPU_PATH)/VcFntDat/segoeui.vci
	 $(VCC) -f '$<' -o '$@' $(TTFFLAGS_Visu) $(VCCFLAGS_Visu) -sfas

$(AS_CPU_PATH)/VcFntDat/segoeui.ccf:$(AS_CPU_PATH)/VcFntDat/segoeui.vco
	 $(LINK) '$^' -o '$@' -warningLevel2 -m segoeui.ttf -name Visu -profile 'False' -vcr 4727 -sfas

$(AS_CPU_PATH)/segoeui.br:$(AS_CPU_PATH)/VcFntDat/segoeui.ccf
	 $(MODGEN) -so $(VC_STATIC_OPTIONS_Shared) -fw '$(VCFIRMWAREPATH)' -m $(VCLOD) -f '$<' -o '$@' -d vcgclass -v V1.00.0 -profile False -vc '$(VCOBJECT_Visu)' -b
endif

#
# Font segoeuii
#
ifneq ($(VC_FONT_segoeuii),1)
VC_FONT_segoeuii=1
$(AS_CPU_PATH)/VcFntDat/segoeuii.vco:$(AS_CPU_PATH)/VcFntDat/segoeuii.vci
	 $(VCC) -f '$<' -o '$@' $(TTFFLAGS_Visu) $(VCCFLAGS_Visu) -sfas

$(AS_CPU_PATH)/VcFntDat/segoeuii.ccf:$(AS_CPU_PATH)/VcFntDat/segoeuii.vco
	 $(LINK) '$^' -o '$@' -warningLevel2 -m segoeuii.ttf -name Visu -profile 'False' -vcr 4727 -sfas

$(AS_CPU_PATH)/segoeuii.br:$(AS_CPU_PATH)/VcFntDat/segoeuii.ccf
	 $(MODGEN) -so $(VC_STATIC_OPTIONS_Shared) -fw '$(VCFIRMWAREPATH)' -m $(VCLOD) -f '$<' -o '$@' -d vcgclass -v V1.00.0 -profile False -vc '$(VCOBJECT_Visu)' -b
endif

#
# Font segoeuib
#
ifneq ($(VC_FONT_segoeuib),1)
VC_FONT_segoeuib=1
$(AS_CPU_PATH)/VcFntDat/segoeuib.vco:$(AS_CPU_PATH)/VcFntDat/segoeuib.vci
	 $(VCC) -f '$<' -o '$@' $(TTFFLAGS_Visu) $(VCCFLAGS_Visu) -sfas

$(AS_CPU_PATH)/VcFntDat/segoeuib.ccf:$(AS_CPU_PATH)/VcFntDat/segoeuib.vco
	 $(LINK) '$^' -o '$@' -warningLevel2 -m segoeuib.ttf -name Visu -profile 'False' -vcr 4727 -sfas

$(AS_CPU_PATH)/segoeuib.br:$(AS_CPU_PATH)/VcFntDat/segoeuib.ccf
	 $(MODGEN) -so $(VC_STATIC_OPTIONS_Shared) -fw '$(VCFIRMWAREPATH)' -m $(VCLOD) -f '$<' -o '$@' -d vcgclass -v V1.00.0 -profile False -vc '$(VCOBJECT_Visu)' -b
endif

#
# Font arialbd
#
ifneq ($(VC_FONT_arialbd),1)
VC_FONT_arialbd=1
$(AS_CPU_PATH)/VcFntDat/arialbd.vco:$(AS_CPU_PATH)/VcFntDat/arialbd.vci
	 $(VCC) -f '$<' -o '$@' $(TTFFLAGS_Visu) $(VCCFLAGS_Visu) -sfas

$(AS_CPU_PATH)/VcFntDat/arialbd.ccf:$(AS_CPU_PATH)/VcFntDat/arialbd.vco
	 $(LINK) '$^' -o '$@' -warningLevel2 -m arialbd.ttf -name Visu -profile 'False' -vcr 4727 -sfas

$(AS_CPU_PATH)/arialbd.br:$(AS_CPU_PATH)/VcFntDat/arialbd.ccf
	 $(MODGEN) -so $(VC_STATIC_OPTIONS_Shared) -fw '$(VCFIRMWAREPATH)' -m $(VCLOD) -f '$<' -o '$@' -d vcgclass -v V1.00.0 -profile False -vc '$(VCOBJECT_Visu)' -b
endif

#
# Font segoeuiz
#
ifneq ($(VC_FONT_segoeuiz),1)
VC_FONT_segoeuiz=1
$(AS_CPU_PATH)/VcFntDat/segoeuiz.vco:$(AS_CPU_PATH)/VcFntDat/segoeuiz.vci
	 $(VCC) -f '$<' -o '$@' $(TTFFLAGS_Visu) $(VCCFLAGS_Visu) -sfas

$(AS_CPU_PATH)/VcFntDat/segoeuiz.ccf:$(AS_CPU_PATH)/VcFntDat/segoeuiz.vco
	 $(LINK) '$^' -o '$@' -warningLevel2 -m segoeuiz.ttf -name Visu -profile 'False' -vcr 4727 -sfas

$(AS_CPU_PATH)/segoeuiz.br:$(AS_CPU_PATH)/VcFntDat/segoeuiz.ccf
	 $(MODGEN) -so $(VC_STATIC_OPTIONS_Shared) -fw '$(VCFIRMWAREPATH)' -m $(VCLOD) -f '$<' -o '$@' -d vcgclass -v V1.00.0 -profile False -vc '$(VCOBJECT_Visu)' -b
endif

FONT_MODULES_Visu=$(TEMP_PATH_ROOT_Visu)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/lucon.br $(TEMP_PATH_ROOT_Visu)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/arial.br $(TEMP_PATH_ROOT_Visu)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/segoeui.br $(TEMP_PATH_ROOT_Visu)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/segoeuii.br $(TEMP_PATH_ROOT_Visu)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/segoeuib.br $(TEMP_PATH_ROOT_Visu)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/arialbd.br $(TEMP_PATH_ROOT_Visu)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/segoeuiz.br 

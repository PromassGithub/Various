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
PALFILE_Visu_T=$(AS_PROJECT_PATH)/Logical/Hmi/Visu_T30/Palette.vcr
VCCFLAGS_Visu_T=-server -proj Visu_T -vc '$(AS_PROJECT_PATH)/Logical/Hmi/Visu_T30/VCObject.vc' -prj_path '$(AS_PROJECT_PATH)' -temp_path '$(AS_TEMP_PATH)' -cfg $(AS_CONFIGURATION) -plc $(AS_PLC) -plctemp $(AS_TEMP_PLC) -cpu_path '$(AS_CPU_PATH)'
VCFIRMWARE=4.72.6
VCFIRMWAREPATH=$(AS_VC_PATH)/Firmware/V4.72.6/SG4
VCOBJECT_Visu_T=$(AS_PROJECT_PATH)/Logical/Hmi/Visu_T30/VCObject.vc
VCSTARTUP='vcstart.br'
VCLOD='vclod.br'
VCSTPOST='vcstpost.br'
TARGET_FILE_Visu_T=$(AS_CPU_PATH)/Visu_T.br
OBJ_SCOPE_Visu_T=Hmi
PRJ_PATH_Visu_T=$(AS_PROJECT_PATH)
SRC_PATH_Visu_T=$(AS_PROJECT_PATH)/Logical/$(OBJ_SCOPE_Visu_T)/Visu_T30
TEMP_PATH_Visu_T=$(AS_TEMP_PATH)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/Visu_T
TEMP_PATH_Shared=$(AS_TEMP_PATH)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/VCShared
TEMP_PATH_ROOT_Visu_T=$(AS_TEMP_PATH)
VC_LIBRARY_LIST_Visu_T=$(TEMP_PATH_Visu_T)/libraries.vci
VC_XREF_BUILDFILE_Visu_T=$(AS_TEMP_PATH)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/vcxref.build
VC_XREF_CLEANFILE=$(AS_TEMP_PATH)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/vcxref.clean
VC_LANGUAGES_Visu_T=$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr
CPUHWC='$(TEMP_PATH_Visu_T)/cpuhwc.vci'
VC_STATIC_OPTIONS_Visu_T='$(TEMP_PATH_Visu_T)/vcStaticOptions.xml'
VC_STATIC_OPTIONS_Shared='$(TEMP_PATH_Shared)/vcStaticOptions.xml'

DSOFLAGS=-P '$(AS_PROJECT_PATH)' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)'
LIB_SHARED=$(TEMP_PATH_ROOT_Visu_T)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/VCShared/vcshared.vca

#
# Shared Runtime Options
#
VCRS_OBJECT=$(TEMP_PATH_ROOT_Visu_T)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/VCShared/vcrt_s.vco
VCRS_SOURCE=$(AS_PROJECT_PATH)/Logical/VCShared/Package.vcp

# All Shared Source Objects
VCR_SOURCES_Visu_T=$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr 

TXTGRP_SHARED_SOURCES_Visu_T=$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAlarmAcknowledgeState.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAlarmBypassState.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAlarmEvent.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAlarmState.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAlarmSeparator.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAuditEventsOutput.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpFileManagerUIDevices.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpFileManagerUIFiles.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpFileManagerUIMessageBox.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/Mp_httpURL_SDM.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpDateTimeFormats.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUnits.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserDialogHeader.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserUIMessageBox.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserXUIErrorText.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserGroups.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserNoYes.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserRight.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserRightLevel.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserUITexts.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpLanguages.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpFileManagerUIText.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpRecipeUIStatus.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpRecipeUIMessageBox.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpFileManagerUIStatus.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/mappTopics.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpRecipeUIText.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAlarmBasicUIText.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/mappComponents.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAuditTrailUIText.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpPackMLCmds.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpPackMLModesNames.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpPackMLStateNames.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpPackMLBasicUIText.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpPackMLStatisticsText.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpPackMLStatisticsUIText.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpComLoggerUIText.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpOeeTimelineUIProductionState.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpOeeTimelineUIDuration.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpOeeListUIText.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpOeeTimelineUIText.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpOeeTrendUIText.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpOeeCoreText.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpDataTableUIText.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpDataTableUIStatus.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpDataTableHeader.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpRecipeUISize.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAuditUserIDText.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserPasswordCriteria.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAuditUserAction.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAlarmXListUIText.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAlarmXListCode.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAlarmXListState.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAlarmXHistoryUIText.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAlarmXHistoryCode.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAlarmXHistoryState.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAlarmXListStatus.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAlarmXHistoryStatus.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpEnergyCoreUIText.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpEnergyCoreStatus.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpEnergyForwardEnergy.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpEnergyReverseEnergy.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpOeeCoreUIText.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpOeeCoreUITime.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpDataStatisticsUIStatus.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpDataStatisticsUIText.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserXUITexts.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserXDialogHeader.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserXGroups.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserXNoYes.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserXPasswordCriteria.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserXRight.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserXRightLevel.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserUIErrorText.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserXUIMessageBox.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserXRoles.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserXSignUIText.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserXSignUIMessageBox.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserXConfirmText.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserConfirmText.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAuditUIMessageBox.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAuditUIErrorText.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAlarmXListEventID.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAlarmXListRecordID.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpTweetCoreUITexts.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpTweetCoreUIErrorTexts.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpTweetCoreUIMessageBox.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpTweetCoreUIType.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpRecipeAuditText.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAuditSignatureEvent.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAuditTweetEvent.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/AlarmAcknowledgeState.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/AlarmBypassState.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/AlarmEvent.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/AlarmState.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/DateTimeFormats.txtgrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/httpURL_SDM.txtgrp 

VCUG_SOURCES_Visu_T=$(AS_PROJECT_PATH)/Logical/VCShared/UnitGroups/Length.vcug \
	$(AS_PROJECT_PATH)/Logical/VCShared/UnitGroups/Mass.vcug \
	$(AS_PROJECT_PATH)/Logical/VCShared/UnitGroups/Volume.vcug \
	$(AS_PROJECT_PATH)/Logical/VCShared/UnitGroups/Power.vcug \
	$(AS_PROJECT_PATH)/Logical/VCShared/UnitGroups/Memory.vcug \
	$(AS_PROJECT_PATH)/Logical/VCShared/UnitGroups/Pressure.vcug \
	$(AS_PROJECT_PATH)/Logical/VCShared/UnitGroups/Temperatures.vcug \
	$(AS_PROJECT_PATH)/Logical/VCShared/UnitGroups/Energy.vcug 

ALCFG_SOURCES_Visu_T=$(AS_PROJECT_PATH)/Logical/VCShared/AlarmGroups/AlarmSystem.alcfg 

ALGRP_SOURCES_Visu_T=$(AS_PROJECT_PATH)/Logical/VCShared/AlarmGroups/SystemAlarms.algrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/AlarmGroups/MpRecipeAlarms.algrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/AlarmGroups/MpFileManagerAlarms.algrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/AlarmGroups/MpDataRecorderAlarms.algrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/AlarmGroups/MpCncAlarms.algrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/AlarmGroups/MpRobotAlarms.algrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/AlarmGroups/MpAxisBasicAlarms.algrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/AlarmGroups/MpAuditTrailAlarms.algrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/AlarmGroups/MpOeeAlarms.algrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/AlarmGroups/MpPackMLAlarms.algrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/AlarmGroups/MpUserAlarms.algrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/AlarmGroups/MpTeachPointsUIAlarms.algrp \
	$(AS_PROJECT_PATH)/Logical/VCShared/AlarmGroups/MpSpindleAlarms.algrp 

DSO_SOURCES_Visu_T=$(AS_PROJECT_PATH)/Logical/VCShared/DataSources/Internal.dso \
	$(AS_PROJECT_PATH)/Logical/VCShared/DataSources/DataSource.dso 

CVINFO_SOURCES_Visu_T=$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo 



# UnitGroups
VCUG_OBJECTS_Visu_T = $(addprefix $(AS_CPU_PATH)/VCShared/vcug., $(notdir $(VCUG_SOURCES_Visu_T:.vcug=.vco)))

$(AS_CPU_PATH)/VCShared/vcug.Length.vco: $(AS_PROJECT_PATH)/Logical/VCShared/UnitGroups/Length.vcug
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/vcug.Mass.vco: $(AS_PROJECT_PATH)/Logical/VCShared/UnitGroups/Mass.vcug
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/vcug.Volume.vco: $(AS_PROJECT_PATH)/Logical/VCShared/UnitGroups/Volume.vcug
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/vcug.Power.vco: $(AS_PROJECT_PATH)/Logical/VCShared/UnitGroups/Power.vcug
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/vcug.Memory.vco: $(AS_PROJECT_PATH)/Logical/VCShared/UnitGroups/Memory.vcug
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/vcug.Pressure.vco: $(AS_PROJECT_PATH)/Logical/VCShared/UnitGroups/Pressure.vcug
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/vcug.Temperatures.vco: $(AS_PROJECT_PATH)/Logical/VCShared/UnitGroups/Temperatures.vcug
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/vcug.Energy.vco: $(AS_PROJECT_PATH)/Logical/VCShared/UnitGroups/Energy.vcug
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


#UnitGroups END




# AlarmGroups
ALGRP_OBJECTS_Visu_T = $(addprefix $(AS_CPU_PATH)/VCShared/algrp., $(notdir $(ALGRP_SOURCES_Visu_T:.algrp=.vco)))

$(AS_CPU_PATH)/VCShared/algrp.SystemAlarms.vco: $(AS_PROJECT_PATH)/Logical/VCShared/AlarmGroups/SystemAlarms.algrp
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/algrp.MpRecipeAlarms.vco: $(AS_PROJECT_PATH)/Logical/VCShared/AlarmGroups/MpRecipeAlarms.algrp
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/algrp.MpFileManagerAlarms.vco: $(AS_PROJECT_PATH)/Logical/VCShared/AlarmGroups/MpFileManagerAlarms.algrp
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/algrp.MpDataRecorderAlarms.vco: $(AS_PROJECT_PATH)/Logical/VCShared/AlarmGroups/MpDataRecorderAlarms.algrp
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/algrp.MpCncAlarms.vco: $(AS_PROJECT_PATH)/Logical/VCShared/AlarmGroups/MpCncAlarms.algrp
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/algrp.MpRobotAlarms.vco: $(AS_PROJECT_PATH)/Logical/VCShared/AlarmGroups/MpRobotAlarms.algrp
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/algrp.MpAxisBasicAlarms.vco: $(AS_PROJECT_PATH)/Logical/VCShared/AlarmGroups/MpAxisBasicAlarms.algrp
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/algrp.MpAuditTrailAlarms.vco: $(AS_PROJECT_PATH)/Logical/VCShared/AlarmGroups/MpAuditTrailAlarms.algrp
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/algrp.MpOeeAlarms.vco: $(AS_PROJECT_PATH)/Logical/VCShared/AlarmGroups/MpOeeAlarms.algrp
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/algrp.MpPackMLAlarms.vco: $(AS_PROJECT_PATH)/Logical/VCShared/AlarmGroups/MpPackMLAlarms.algrp
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/algrp.MpUserAlarms.vco: $(AS_PROJECT_PATH)/Logical/VCShared/AlarmGroups/MpUserAlarms.algrp
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/algrp.MpTeachPointsUIAlarms.vco: $(AS_PROJECT_PATH)/Logical/VCShared/AlarmGroups/MpTeachPointsUIAlarms.algrp
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/algrp.MpSpindleAlarms.vco: $(AS_PROJECT_PATH)/Logical/VCShared/AlarmGroups/MpSpindleAlarms.algrp
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


#AlarmGroups END




# AlarmSystem
ALCFG_OBJECTS_Visu_T = $(addprefix $(AS_CPU_PATH)/VCShared/alcfg., $(notdir $(ALCFG_SOURCES_Visu_T:.alcfg=.vco)))

$(AS_CPU_PATH)/VCShared/alcfg.AlarmSystem.vco: $(AS_PROJECT_PATH)/Logical/VCShared/AlarmGroups/AlarmSystem.alcfg
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


#AlarmSystem END




# Text Groups
TXTGRP_SHARED_OBJECTS_Visu_T = $(addprefix $(AS_CPU_PATH)/VCShared/txtgrp., $(notdir $(TXTGRP_SHARED_SOURCES_Visu_T:.txtgrp=.vco)))

$(AS_CPU_PATH)/VCShared/txtgrp.MpAlarmAcknowledgeState.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAlarmAcknowledgeState.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpAlarmBypassState.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAlarmBypassState.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpAlarmEvent.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAlarmEvent.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpAlarmState.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAlarmState.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpAlarmSeparator.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAlarmSeparator.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpAuditEventsOutput.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAuditEventsOutput.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpFileManagerUIDevices.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpFileManagerUIDevices.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpFileManagerUIFiles.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpFileManagerUIFiles.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpFileManagerUIMessageBox.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpFileManagerUIMessageBox.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.Mp_httpURL_SDM.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/Mp_httpURL_SDM.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpDateTimeFormats.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpDateTimeFormats.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpUnits.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUnits.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpUserDialogHeader.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserDialogHeader.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpUserUIMessageBox.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserUIMessageBox.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpUserXUIErrorText.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserXUIErrorText.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpUserGroups.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserGroups.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpUserNoYes.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserNoYes.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpUserRight.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserRight.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpUserRightLevel.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserRightLevel.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpUserUITexts.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserUITexts.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpLanguages.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpLanguages.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpFileManagerUIText.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpFileManagerUIText.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpRecipeUIStatus.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpRecipeUIStatus.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpRecipeUIMessageBox.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpRecipeUIMessageBox.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpFileManagerUIStatus.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpFileManagerUIStatus.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.mappTopics.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/mappTopics.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpRecipeUIText.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpRecipeUIText.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpAlarmBasicUIText.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAlarmBasicUIText.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.mappComponents.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/mappComponents.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpAuditTrailUIText.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAuditTrailUIText.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpPackMLCmds.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpPackMLCmds.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpPackMLModesNames.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpPackMLModesNames.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpPackMLStateNames.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpPackMLStateNames.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpPackMLBasicUIText.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpPackMLBasicUIText.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpPackMLStatisticsText.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpPackMLStatisticsText.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpPackMLStatisticsUIText.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpPackMLStatisticsUIText.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpComLoggerUIText.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpComLoggerUIText.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpOeeTimelineUIProductionState.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpOeeTimelineUIProductionState.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpOeeTimelineUIDuration.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpOeeTimelineUIDuration.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpOeeListUIText.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpOeeListUIText.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpOeeTimelineUIText.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpOeeTimelineUIText.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpOeeTrendUIText.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpOeeTrendUIText.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpOeeCoreText.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpOeeCoreText.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpDataTableUIText.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpDataTableUIText.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpDataTableUIStatus.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpDataTableUIStatus.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpDataTableHeader.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpDataTableHeader.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpRecipeUISize.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpRecipeUISize.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpAuditUserIDText.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAuditUserIDText.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpUserPasswordCriteria.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserPasswordCriteria.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpAuditUserAction.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAuditUserAction.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpAlarmXListUIText.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAlarmXListUIText.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpAlarmXListCode.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAlarmXListCode.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpAlarmXListState.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAlarmXListState.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpAlarmXHistoryUIText.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAlarmXHistoryUIText.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpAlarmXHistoryCode.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAlarmXHistoryCode.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpAlarmXHistoryState.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAlarmXHistoryState.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpAlarmXListStatus.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAlarmXListStatus.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpAlarmXHistoryStatus.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAlarmXHistoryStatus.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpEnergyCoreUIText.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpEnergyCoreUIText.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpEnergyCoreStatus.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpEnergyCoreStatus.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpEnergyForwardEnergy.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpEnergyForwardEnergy.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpEnergyReverseEnergy.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpEnergyReverseEnergy.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpOeeCoreUIText.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpOeeCoreUIText.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpOeeCoreUITime.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpOeeCoreUITime.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpDataStatisticsUIStatus.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpDataStatisticsUIStatus.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpDataStatisticsUIText.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpDataStatisticsUIText.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpUserXUITexts.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserXUITexts.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpUserXDialogHeader.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserXDialogHeader.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpUserXGroups.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserXGroups.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpUserXNoYes.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserXNoYes.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpUserXPasswordCriteria.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserXPasswordCriteria.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpUserXRight.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserXRight.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpUserXRightLevel.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserXRightLevel.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpUserUIErrorText.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserUIErrorText.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpUserXUIMessageBox.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserXUIMessageBox.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpUserXRoles.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserXRoles.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpUserXSignUIText.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserXSignUIText.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpUserXSignUIMessageBox.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserXSignUIMessageBox.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpUserXConfirmText.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserXConfirmText.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpUserConfirmText.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpUserConfirmText.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpAuditUIMessageBox.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAuditUIMessageBox.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpAuditUIErrorText.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAuditUIErrorText.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpAlarmXListEventID.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAlarmXListEventID.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpAlarmXListRecordID.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAlarmXListRecordID.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpTweetCoreUITexts.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpTweetCoreUITexts.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpTweetCoreUIErrorTexts.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpTweetCoreUIErrorTexts.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpTweetCoreUIMessageBox.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpTweetCoreUIMessageBox.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpTweetCoreUIType.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpTweetCoreUIType.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpRecipeAuditText.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpRecipeAuditText.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpAuditSignatureEvent.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAuditSignatureEvent.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.MpAuditTweetEvent.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/MpAuditTweetEvent.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.AlarmAcknowledgeState.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/AlarmAcknowledgeState.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.AlarmBypassState.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/AlarmBypassState.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.AlarmEvent.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/AlarmEvent.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.AlarmState.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/AlarmState.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.DateTimeFormats.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/DateTimeFormats.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


$(AS_CPU_PATH)/VCShared/txtgrp.httpURL_SDM.vco: $(AS_PROJECT_PATH)/Logical/VCShared/TextGroups/httpURL_SDM.txtgrp $(VC_LANGUAGES_Visu_T)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_T)' $(VCCFLAGS_Visu_T)  -p Visu_T -so $(VC_STATIC_OPTIONS_Visu_T) -vcr 4726 -sfas


#Text Groups END


#
# Datapoint Objects
#
$(TEMP_PATH_ROOT_Visu_T)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/VCShared/dso.Internal.vco: $(AS_PROJECT_PATH)/Logical/VCShared/DataSources/Internal.dso 
	 $(VCC) -f '$<' -o '$@' $(DSOFLAGS) $(VCCFLAGS_Visu_T) -p Visu_T -vcr 4726 -sfas

$(TEMP_PATH_ROOT_Visu_T)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/VCShared/dso.DataSource.vco: $(AS_PROJECT_PATH)/Logical/VCShared/DataSources/DataSource.dso 
	 $(VCC) -f '$<' -o '$@' $(DSOFLAGS) $(VCCFLAGS_Visu_T) -p Visu_T -vcr 4726 -sfas

DPT_OBJECTS = $(TEMP_PATH_ROOT_Visu_T)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/VCShared/dpt.DataPointList.vco
DSO_OBJECTS_Visu_T=$(TEMP_PATH_ROOT_Visu_T)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/VCShared/dso.Internal.vco $(TEMP_PATH_ROOT_Visu_T)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/VCShared/dso.DataSource.vco 
$(DSO_OBJECTS_Visu_T): $(DSO_SOURCES_Visu_T)


#
# Building the Shared Runtime Options
#
$(VCRS_OBJECT) : $(VCRS_SOURCE)
	$(VCC) -f '$<' -o '$@' -ct shared -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -sl  $(VCCFLAGS_Visu_T) -p Visu_T -vcr 4726 -sfas

#
# The Shared Module
#
SHARED_MODULE=$(TEMP_PATH_ROOT_Visu_T)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/vcshared.br
SHARED_CCF=$(TEMP_PATH_ROOT_Visu_T)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/VCShared/vcshared.ccf
DEL_SHARED_CCF=$(TEMP_PATH_ROOT_Visu_T)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/VCShared/vcshared.ccf.lfl

$(SHARED_MODULE) : $(SHARED_CCF)
	 $(MODGEN) -so $(VC_STATIC_OPTIONS_Shared) -fw '$(VCFIRMWAREPATH)' -m $(VCSTARTUP) -v V1.00.0 -vc '$(VCOBJECT_Visu_T)' -f '$<' -o '$@' -d vcgclass -profile 'False'

$(VCUG_OBJECTS_Visu_T): $(VC_LANGUAGES_Visu_T)
$(TXTGRP_SHARED_OBJECTS_Visu_T): $(VC_LANGUAGES_Visu_T)
$(ALGRP_OBJECTS_Visu_T): $(VC_LANGUAGES_Visu_T)
$(ALCFG_OBJECTS_Visu_T): $(VC_LANGUAGES_Visu_T)

$(SHARED_CCF): $(VCRS_OBJECT) $(VCR_OBJECTS_Visu_T) $(VCUG_OBJECTS_Visu_T) $(ALGRP_OBJECTS_Visu_T) $(ALCFG_OBJECTS_Visu_T) $(DSO_OBJECTS_Visu_T) $(TXTGRP_SHARED_OBJECTS_Visu_T) $(CVINFO_OBJECTS_Visu_T)
	-@CMD /Q /C if exist "$(DEL_SHARED_CCF)" DEL /F /Q "$(DEL_SHARED_CCF)" 2>nul
	 @$(VCFLGEN) '$@.lfl' '$(VCR_OBJECTS_Visu_T:.vco=.vco|)' -temp '$(TEMP_PATH_Visu_T)' -prj '$(PRJ_PATH_Visu_T)'
	 @$(VCFLGEN) '$@.lfl' -mask .vcug -vcp '$(AS_PROJECT_PATH)/Logical/VCShared/Package.vcp' -temp '$(TEMP_PATH_Shared)' -prj '$(PRJ_PATH_Visu_T)'
	 @$(VCFLGEN) '$@.lfl' -mask .algrp -vcp '$(AS_PROJECT_PATH)/Logical/VCShared/Package.vcp' -temp '$(TEMP_PATH_Shared)' -prj '$(PRJ_PATH_Visu_T)'
	 @$(VCFLGEN) '$@.lfl' '$(ALCFG_OBJECTS_Visu_T:.vco=.vco|)' -temp '$(TEMP_PATH_Visu_T)' -prj '$(PRJ_PATH_Visu_T)'
	 @$(VCFLGEN) '$@.lfl' -mask .txtgrp -vcp '$(AS_PROJECT_PATH)/Logical/VCShared/Package.vcp' -temp '$(TEMP_PATH_Shared)' -prj '$(PRJ_PATH_Visu_T)'
	 @$(VCFLGEN) '$@.lfl' '$(DSO_OBJECTS_Visu_T:.vco=.vco|)' -temp '$(TEMP_PATH_Visu_T)' -prj '$(PRJ_PATH_Visu_T)'
	 @$(VCFLGEN) '$@.lfl' '$(DPT_OBJECTS:.vco=.vco|)' -temp '$(TEMP_PATH_Visu_T)' -prj '$(PRJ_PATH_Visu_T)'
	 @$(VCFLGEN) '$@.lfl' '$(VCRS_OBJECT)' -temp '$(TEMP_PATH_Visu_T)' -prj '$(PRJ_PATH_Visu_T)'
	 $(LINK) '$@.lfl' -o '$@' -lib '$(LIB_SHARED)' -P '$(AS_PROJECT_PATH)' -m 'shared resources' -profile 'False' -warningLevel2 -name Visu_T -vcr 4726 -sfas


$(LIB_SHARED): $(SHARED_CCF)

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
PALFILE_Visu_R=$(AS_PROJECT_PATH)/Logical/Visu_Resized/Palette.vcr
VCCFLAGS_Visu_R=-server -proj Visu_R -vc '$(AS_PROJECT_PATH)/Logical/Visu_Resized/VCObject.vc' -prj_path '$(AS_PROJECT_PATH)' -temp_path '$(AS_TEMP_PATH)' -cfg $(AS_CONFIGURATION) -plc $(AS_PLC) -plctemp $(AS_TEMP_PLC) -cpu_path '$(AS_CPU_PATH)'
VCFIRMWARE=4.72.6
VCFIRMWAREPATH=$(AS_VC_PATH)/Firmware/V4.72.6/SG4
VCOBJECT_Visu_R=$(AS_PROJECT_PATH)/Logical/Visu_Resized/VCObject.vc
VCSTARTUP='vcstart.br'
VCLOD='vclod.br'
VCSTPOST='vcstpost.br'
TARGET_FILE_Visu_R=$(AS_CPU_PATH)/Visu_R.br
OBJ_SCOPE_Visu_R=
PRJ_PATH_Visu_R=$(AS_PROJECT_PATH)
SRC_PATH_Visu_R=$(AS_PROJECT_PATH)/Logical/$(OBJ_SCOPE_Visu_R)/Visu_Resized
TEMP_PATH_Visu_R=$(AS_TEMP_PATH)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/Visu_R
TEMP_PATH_Shared=$(AS_TEMP_PATH)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/VCShared
TEMP_PATH_ROOT_Visu_R=$(AS_TEMP_PATH)
VC_LIBRARY_LIST_Visu_R=$(TEMP_PATH_Visu_R)/libraries.vci
VC_XREF_BUILDFILE_Visu_R=$(AS_TEMP_PATH)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/vcxref.build
VC_XREF_CLEANFILE=$(AS_TEMP_PATH)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/vcxref.clean
VC_LANGUAGES_Visu_R=$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr
CPUHWC='$(TEMP_PATH_Visu_R)/cpuhwc.vci'
VC_STATIC_OPTIONS_Visu_R='$(TEMP_PATH_Visu_R)/vcStaticOptions.xml'
VC_STATIC_OPTIONS_Shared='$(TEMP_PATH_Shared)/vcStaticOptions.xml'
# include Shared and Font Makefile (only once)
	include $(AS_TEMP_PATH)/objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/VCFntDat/Font_Visu_R.mak
ifneq ($(VCINC),1)
	VCINC=1
	include $(AS_TEMP_PATH)/objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/VCShared/VCShared.mak
endif

DEPENDENCIES_Visu_R=-d vcgclass -profile 'False'
DEFAULT_STYLE_SHEET_Visu_R='Source[local].StyleSheet[Default]'
SHARED_MODULE=$(TEMP_PATH_ROOT_Visu_R)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/vcshared.br
LFNTFLAGS_Visu_R=-P '$(AS_PROJECT_PATH)' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)'
BDRFLAGS_Visu_R=-P '$(AS_PROJECT_PATH)' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)'

# Local Libs
LIB_LOCAL_OBJ_Visu_R=$(TEMP_PATH_Visu_R)/localobj.vca

# Hardware sources
PANEL_HW_OBJECT_Visu_R=$(TEMP_PATH_ROOT_Visu_R)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/Visu_R/dis.Hardware.vco
PANEL_HW_VCI_Visu_R=$(TEMP_PATH_ROOT_Visu_R)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/Visu_R/dis.Hardware.vci
PANEL_HW_SOURCE_Visu_R=C:/project/GITH_HUB/Various/MM_movim_manuale/Physical/Config3/Hardware.hw 
DIS_OBJECTS_Visu_R=$(PANEL_HW_OBJECT_Visu_R) $(KEYMAP_OBJECTS_Visu_R)

# KeyMapping flags
KEYMAP_SOURCES_Visu_R=$(AS_PROJECT_PATH)/Physical/Config3/4PP045_0571_062/VC/4PP045_0571_062.dis 
KEYMAP_OBJECTS_Visu_R=

# All Source Objects
TXTGRP_SOURCES_Visu_R=$(AS_PROJECT_PATH)/Logical/Visu_Resized/TextGroups/InstantMessages.txtgrp \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/TextGroups/HeaderBar.txtgrp \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/TextGroups/PageNames.txtgrp \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/TextGroups/Buttons_PageTexts.txtgrp \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/TextGroups/Languages.txtgrp \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/TextGroups/NumPad_Limits.txtgrp \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/TextGroups/httpURL_SDM.txtgrp 

FNINFO_SOURCES_Visu_R=$(AS_PROJECT_PATH)/Logical/Visu_Resized/Fonts/Info.fninfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Fonts/Html_SDM.fninfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Fonts/Default.fninfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Fonts/Header.fninfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Fonts/Button.fninfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Fonts/Input.fninfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Fonts/Status.fninfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Fonts/Arial20_b.fninfo 

BMINFO_SOURCES_Visu_R=$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_NumPad_pressed.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_NumPad.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Alarm_AcknowledgeReset.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Alarm_Active.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Alarm_BypassOFF.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Alarm_BypassON.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Alarm_Inactive.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Alarm_Latched.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Alarm_NotQuit.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Alarm_Quit.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Alarm_Reset.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Alarm_ResetAcknowledge.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Alarm_Triggered.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/ProgressBorder.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/alarm.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/checkbox.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/checkbox_checked.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_default.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_default_pressed.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_down.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_down_pressed.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_global_area.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_global_area_pressed.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/information.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_left.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_left_pressed.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_down_multi.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_down_multi_pressed.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_up_multi.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_up_multi_pressed.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_radio_selected.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_radio.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_right.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_right_pressed.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_up.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_up_pressed.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/warning.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_decrease_pressed.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_increase.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_increase_pressed.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_decrease.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/frame_header.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/checkbox_small.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/checkbox_small_checked.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Slider_09x09.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Slider_ArrowRightGray.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Slider_ArrowUpGray.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Slider_BallGray.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_ListPadVer.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_ListPadHor_pressed.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_ListPadHor.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_ListPadVer_pressed.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/gauge_200x200_round_nodiv.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/gauge_NeedleRed100x11_1.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/checkbox_small_gray.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/FrameInvisible.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_off.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_on.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_ready.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_error.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/BackTransparent.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/BackgroundVGA_Portrait_NoLogo.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_AlphaPadQVGA_Layer1.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_AlphaPadQVGA_Layer1_pressed.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_AlphaPadQVGA_Layer2.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_AlphaPadQVGA_Layer2_pressed.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_AlphaPadQVGA_Layer3.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_AlphaPadQVGA_Layer3_pressed.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_NumPadLimits.bminfo \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_NumPadLimits_pressed.bminfo 

BMGRP_SOURCES_Visu_R=$(AS_PROJECT_PATH)/Logical/Visu_Resized/BitmapGroups/AlarmAcknowledgeState.bmgrp \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/BitmapGroups/AlarmBypassState.bmgrp \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/BitmapGroups/AlarmEvent.bmgrp \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/BitmapGroups/AlarmState.bmgrp \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/BitmapGroups/Borders.bmgrp \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/BitmapGroups/GlobalArea.bmgrp \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/BitmapGroups/Pads.bmgrp \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/BitmapGroups/msgBox.bmgrp 

PAGE_SOURCES_Visu_R=$(AS_PROJECT_PATH)/Logical/Visu_Resized/Pages/tmpl10_SettingsPage.page \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Pages/tmpl00_HomePage.page \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Pages/tmpl60_Setup.page \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Pages/tmpl20_MartinettiPage.page \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Pages/tmpl30_ReportPage.page \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Pages/tmpl31_CStampoPage.page \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Pages/tmpl61_SystemDiagnostics.page 

LAYER_SOURCES_Visu_R=$(AS_PROJECT_PATH)/Logical/Visu_Resized/Layers/globalArea.layer \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Layers/msgBox.layer \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Layers/Background.layer 

VCS_SOURCES_Visu_R=$(AS_PROJECT_PATH)/Logical/Visu_Resized/StyleSheets/Default.vcs 

BDR_SOURCES_Visu_R=$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Decrease.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Decrease_pressed.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Global_Area.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Global_Area_pressed.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Increase.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Increase_pressed.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Multi_Scroll_Down.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Multi_Scroll_Down_pressed.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Multi_Scroll_Up.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Multi_Scroll_Up_pressed.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Radio.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Radio_selected.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Scoll_Up.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Scoll_Up_pressed.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Scroll_Down.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Scroll_Down_pressed.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Scroll_Left.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Scroll_Left_pressed.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Scroll_Right.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Scroll_Right_pressed.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_pressed.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/SunkenNG.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/CheckBox_checked.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Flat_black.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Flat_grey.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/FrameHeader.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/OverdriveBorder.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/ProgressBarBorder.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/RaisedInner.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Raised.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/SliderBorder09.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/SunkenOuter.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Sunken.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/SunkenNGgray.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/FrameGlobal.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/FrameInvisible.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_KeyRingOff.bdr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_KeyRingOn.bdr 

TPR_SOURCES_Visu_R=$(AS_PROJECT_PATH)/Logical/Visu_Resized/TouchPads/NumPad.tpr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/TouchPads/NavigationPad_ver.tpr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/TouchPads/NavigationPad_hor.tpr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/TouchPads/AlphaPadQVGA.tpr \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/TouchPads/NumPad_Limits.tpr 

TDC_SOURCES_Visu_R=$(AS_PROJECT_PATH)/Logical/Visu_Resized/Trends/TrendData.tdc 

TRD_SOURCES_Visu_R=$(AS_PROJECT_PATH)/Logical/Visu_Resized/Trends/CPUTemperature.trd \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Trends/ROOMTemperature.trd \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Trends/TrendData_1.trd \
	$(AS_PROJECT_PATH)/Logical/Visu_Resized/Trends/TrendData_2.trd 

TRE_SOURCES_Visu_R=$(AS_PROJECT_PATH)/Logical/Visu_Resized/Trends/Trend_1.tre 

CLM_SOURCES_Visu_R=$(AS_PROJECT_PATH)/Logical/Visu_Resized/ColorMaps/ColorMap_1.clm 

VCVK_SOURCES_Visu_R=$(AS_PROJECT_PATH)/Logical/Visu_Resized/VirtualKeys.vcvk 

VCR_SOURCES_Visu_R=$(AS_PROJECT_PATH)/Logical/Visu_Resized/Palette.vcr 

# Runtime Object sources
VCR_OBJECT_Visu_R=$(TEMP_PATH_Visu_R)/vcrt.vco
VCR_SOURCE_Visu_R=$(SRC_PATH_Visu_R)/package.vcp
# All Source Objects END

#Panel Hardware
$(PANEL_HW_VCI_Visu_R): $(PANEL_HW_SOURCE_Visu_R) $(VC_LIBRARY_LIST_Visu_R) $(KEYMAP_SOURCES_Visu_R) $(PALFILE_Visu_R)
	$(VCHWPP) -f '$<' -o '$@' -n Visu_Resized -d Visu_R -pal '$(PALFILE_Visu_R)' -c '$(AS_CONFIGURATION)' -p '$(AS_PLC)' -ptemp '$(AS_TEMP_PLC)' -B 'H3.10' -L '' -verbose 'False' -profile 'False' -hw '$(CPUHWC)' -warninglevel 2 -so $(VC_STATIC_OPTIONS_Visu_R) -sos $(VC_STATIC_OPTIONS_Shared) -fp '$(AS_VC_PATH)/Firmware/V4.72.6/SG4' -sfas -prj '$(AS_PROJECT_PATH)' -apj 'MM_movim_manuale' -vcob '$(VCOBJECT_Visu_R)'

$(PANEL_HW_OBJECT_Visu_R): $(PANEL_HW_VCI_Visu_R) $(VC_LIBRARY_LIST_Visu_R)
	$(VCC) -f '$(subst .vco,.vci,$@)' -o '$@' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -k '$(VCVK_SOURCES_Visu_R)' $(VCCFLAGS_Visu_R) -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


# Pages
PAGE_OBJECTS_Visu_R = $(addprefix $(TEMP_PATH_Visu_R)/page., $(notdir $(PAGE_SOURCES_Visu_R:.page=.vco)))

$(TEMP_PATH_Visu_R)/page.tmpl10_SettingsPage.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Pages/tmpl10_SettingsPage.page $(VC_LANGUAGES_Visu_R)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R) -P '$(AS_PROJECT_PATH)' -ds '$(SRC_PATH_Visu_R)/StyleSheets/Default.vcs' -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/page.tmpl00_HomePage.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Pages/tmpl00_HomePage.page $(VC_LANGUAGES_Visu_R)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R) -P '$(AS_PROJECT_PATH)' -ds '$(SRC_PATH_Visu_R)/StyleSheets/Default.vcs' -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/page.tmpl60_Setup.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Pages/tmpl60_Setup.page $(VC_LANGUAGES_Visu_R)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R) -P '$(AS_PROJECT_PATH)' -ds '$(SRC_PATH_Visu_R)/StyleSheets/Default.vcs' -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/page.tmpl20_MartinettiPage.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Pages/tmpl20_MartinettiPage.page $(VC_LANGUAGES_Visu_R)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R) -P '$(AS_PROJECT_PATH)' -ds '$(SRC_PATH_Visu_R)/StyleSheets/Default.vcs' -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/page.tmpl30_ReportPage.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Pages/tmpl30_ReportPage.page $(VC_LANGUAGES_Visu_R)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R) -P '$(AS_PROJECT_PATH)' -ds '$(SRC_PATH_Visu_R)/StyleSheets/Default.vcs' -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/page.tmpl31_CStampoPage.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Pages/tmpl31_CStampoPage.page $(VC_LANGUAGES_Visu_R)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R) -P '$(AS_PROJECT_PATH)' -ds '$(SRC_PATH_Visu_R)/StyleSheets/Default.vcs' -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/page.tmpl61_SystemDiagnostics.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Pages/tmpl61_SystemDiagnostics.page $(VC_LANGUAGES_Visu_R)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R) -P '$(AS_PROJECT_PATH)' -ds '$(SRC_PATH_Visu_R)/StyleSheets/Default.vcs' -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


#Pages END




# Stylesheets
VCS_OBJECTS_Visu_R = $(addprefix $(TEMP_PATH_Visu_R)/vcs., $(notdir $(VCS_SOURCES_Visu_R:.vcs=.vco)))

$(TEMP_PATH_Visu_R)/vcs.Default.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/StyleSheets/Default.vcs
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R) -P '$(AS_PROJECT_PATH)' -ds $(DEFAULT_STYLE_SHEET_Visu_R) -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


#Stylesheets END




# Layers
LAYER_OBJECTS_Visu_R = $(addprefix $(TEMP_PATH_Visu_R)/layer., $(notdir $(LAYER_SOURCES_Visu_R:.layer=.vco)))

$(TEMP_PATH_Visu_R)/layer.globalArea.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Layers/globalArea.layer $(VC_LANGUAGES_Visu_R)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R) -ds $(DEFAULT_STYLE_SHEET_Visu_R) -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/layer.msgBox.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Layers/msgBox.layer $(VC_LANGUAGES_Visu_R)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R) -ds $(DEFAULT_STYLE_SHEET_Visu_R) -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/layer.Background.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Layers/Background.layer $(VC_LANGUAGES_Visu_R)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R) -ds $(DEFAULT_STYLE_SHEET_Visu_R) -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


#Layers END




# Virtual Keys
VCVK_OBJECTS_Visu_R = $(addprefix $(TEMP_PATH_Visu_R)/vcvk., $(notdir $(VCVK_SOURCES_Visu_R:.vcvk=.vco)))

$(TEMP_PATH_Visu_R)/vcvk.VirtualKeys.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/VirtualKeys.vcvk
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas

$(VCVK_OBJECTS_Visu_R): $(VC_LANGUAGES_Visu_R)

#Virtual Keys END




# Touch Pads
TPR_OBJECTS_Visu_R = $(addprefix $(TEMP_PATH_Visu_R)/tpr., $(notdir $(TPR_SOURCES_Visu_R:.tpr=.vco)))

$(TEMP_PATH_Visu_R)/tpr.NumPad.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/TouchPads/NumPad.tpr
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R) -prj 'C:/project/GITH_HUB/Various/MM_movim_manuale/Logical/Visu_Resized' -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/tpr.NavigationPad_ver.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/TouchPads/NavigationPad_ver.tpr
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R) -prj 'C:/project/GITH_HUB/Various/MM_movim_manuale/Logical/Visu_Resized' -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/tpr.NavigationPad_hor.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/TouchPads/NavigationPad_hor.tpr
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R) -prj 'C:/project/GITH_HUB/Various/MM_movim_manuale/Logical/Visu_Resized' -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/tpr.AlphaPadQVGA.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/TouchPads/AlphaPadQVGA.tpr
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R) -prj 'C:/project/GITH_HUB/Various/MM_movim_manuale/Logical/Visu_Resized' -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/tpr.NumPad_Limits.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/TouchPads/NumPad_Limits.tpr
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R) -prj 'C:/project/GITH_HUB/Various/MM_movim_manuale/Logical/Visu_Resized' -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


#Touch Pads END




# Text Groups
TXTGRP_OBJECTS_Visu_R = $(addprefix $(TEMP_PATH_Visu_R)/txtgrp., $(notdir $(TXTGRP_SOURCES_Visu_R:.txtgrp=.vco)))

$(TEMP_PATH_Visu_R)/txtgrp.InstantMessages.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/TextGroups/InstantMessages.txtgrp $(VC_LANGUAGES_Visu_R)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/txtgrp.HeaderBar.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/TextGroups/HeaderBar.txtgrp $(VC_LANGUAGES_Visu_R)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/txtgrp.PageNames.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/TextGroups/PageNames.txtgrp $(VC_LANGUAGES_Visu_R)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/txtgrp.Buttons_PageTexts.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/TextGroups/Buttons_PageTexts.txtgrp $(VC_LANGUAGES_Visu_R)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/txtgrp.Languages.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/TextGroups/Languages.txtgrp $(VC_LANGUAGES_Visu_R)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/txtgrp.NumPad_Limits.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/TextGroups/NumPad_Limits.txtgrp $(VC_LANGUAGES_Visu_R)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/txtgrp.httpURL_SDM.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/TextGroups/httpURL_SDM.txtgrp $(VC_LANGUAGES_Visu_R)
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


#Text Groups END




# BitmapGroups
BMGRP_OBJECTS_Visu_R = $(addprefix $(TEMP_PATH_Visu_R)/bmgrp., $(notdir $(BMGRP_SOURCES_Visu_R:.bmgrp=.vco)))

$(TEMP_PATH_Visu_R)/bmgrp.AlarmAcknowledgeState.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/BitmapGroups/AlarmAcknowledgeState.bmgrp
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bmgrp.AlarmBypassState.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/BitmapGroups/AlarmBypassState.bmgrp
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bmgrp.AlarmEvent.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/BitmapGroups/AlarmEvent.bmgrp
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bmgrp.AlarmState.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/BitmapGroups/AlarmState.bmgrp
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bmgrp.Borders.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/BitmapGroups/Borders.bmgrp
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bmgrp.GlobalArea.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/BitmapGroups/GlobalArea.bmgrp
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bmgrp.Pads.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/BitmapGroups/Pads.bmgrp
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bmgrp.msgBox.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/BitmapGroups/msgBox.bmgrp
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


#BitmapGroups END




# Bitmaps
BMINFO_OBJECTS_Visu_R = $(addprefix $(TEMP_PATH_Visu_R)/bminfo., $(notdir $(BMINFO_SOURCES_Visu_R:.bminfo=.vco)))

$(TEMP_PATH_Visu_R)/bminfo.Key_NumPad_pressed.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_NumPad_pressed.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_NumPad_pressed.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.Key_NumPad.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_NumPad.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_NumPad.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.Alarm_AcknowledgeReset.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Alarm_AcknowledgeReset.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Alarm_AcknowledgeReset.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.Alarm_Active.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Alarm_Active.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Alarm_Active.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.Alarm_BypassOFF.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Alarm_BypassOFF.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Alarm_BypassOFF.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.Alarm_BypassON.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Alarm_BypassON.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Alarm_BypassON.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.Alarm_Inactive.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Alarm_Inactive.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Alarm_Inactive.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.Alarm_Latched.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Alarm_Latched.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Alarm_Latched.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.Alarm_NotQuit.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Alarm_NotQuit.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Alarm_NotQuit.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.Alarm_Quit.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Alarm_Quit.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Alarm_Quit.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.Alarm_Reset.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Alarm_Reset.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Alarm_Reset.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.Alarm_ResetAcknowledge.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Alarm_ResetAcknowledge.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Alarm_ResetAcknowledge.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.Alarm_Triggered.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Alarm_Triggered.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Alarm_Triggered.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.ProgressBorder.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/ProgressBorder.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/ProgressBorder.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.alarm.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/alarm.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/alarm.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.checkbox.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/checkbox.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/checkbox.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.checkbox_checked.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/checkbox_checked.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/checkbox_checked.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.button_default.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_default.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_default.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.button_default_pressed.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_default_pressed.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_default_pressed.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.button_scroll_down.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_down.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_down.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.button_scroll_down_pressed.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_down_pressed.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_down_pressed.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.button_global_area.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_global_area.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_global_area.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.button_global_area_pressed.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_global_area_pressed.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_global_area_pressed.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.information.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/information.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/information.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.button_scroll_left.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_left.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_left.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.button_scroll_left_pressed.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_left_pressed.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_left_pressed.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.button_scroll_down_multi.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_down_multi.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_down_multi.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.button_scroll_down_multi_pressed.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_down_multi_pressed.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_down_multi_pressed.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.button_scroll_up_multi.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_up_multi.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_up_multi.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.button_scroll_up_multi_pressed.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_up_multi_pressed.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_up_multi_pressed.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.button_radio_selected.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_radio_selected.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_radio_selected.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.button_radio.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_radio.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_radio.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.button_scroll_right.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_right.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_right.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.button_scroll_right_pressed.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_right_pressed.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_right_pressed.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.button_scroll_up.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_up.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_up.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.button_scroll_up_pressed.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_up_pressed.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_scroll_up_pressed.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.warning.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/warning.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/warning.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.button_decrease_pressed.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_decrease_pressed.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_decrease_pressed.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.button_increase.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_increase.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_increase.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.button_increase_pressed.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_increase_pressed.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_increase_pressed.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.button_decrease.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_decrease.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_decrease.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.frame_header.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/frame_header.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/frame_header.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.checkbox_small.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/checkbox_small.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/checkbox_small.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.checkbox_small_checked.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/checkbox_small_checked.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/checkbox_small_checked.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.Slider_09x09.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Slider_09x09.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Slider_09x09.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.Slider_ArrowRightGray.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Slider_ArrowRightGray.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Slider_ArrowRightGray.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.Slider_ArrowUpGray.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Slider_ArrowUpGray.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Slider_ArrowUpGray.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.Slider_BallGray.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Slider_BallGray.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Slider_BallGray.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.Key_ListPadVer.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_ListPadVer.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_ListPadVer.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.Key_ListPadHor_pressed.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_ListPadHor_pressed.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_ListPadHor_pressed.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.Key_ListPadHor.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_ListPadHor.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_ListPadHor.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.Key_ListPadVer_pressed.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_ListPadVer_pressed.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_ListPadVer_pressed.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.gauge_200x200_round_nodiv.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/gauge_200x200_round_nodiv.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/gauge_200x200_round_nodiv.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.gauge_NeedleRed100x11_1.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/gauge_NeedleRed100x11_1.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/gauge_NeedleRed100x11_1.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.checkbox_small_gray.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/checkbox_small_gray.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/checkbox_small_gray.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.FrameInvisible.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/FrameInvisible.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/FrameInvisible.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.button_off.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_off.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_off.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.button_on.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_on.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_on.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.button_ready.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_ready.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_ready.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.button_error.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_error.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/button_error.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.BackTransparent.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/BackTransparent.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/BackTransparent.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.BackgroundVGA_Portrait_NoLogo.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/BackgroundVGA_Portrait_NoLogo.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/BackgroundVGA_Portrait_NoLogo.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.Key_AlphaPadQVGA_Layer1.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_AlphaPadQVGA_Layer1.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_AlphaPadQVGA_Layer1.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.Key_AlphaPadQVGA_Layer1_pressed.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_AlphaPadQVGA_Layer1_pressed.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_AlphaPadQVGA_Layer1_pressed.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.Key_AlphaPadQVGA_Layer2.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_AlphaPadQVGA_Layer2.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_AlphaPadQVGA_Layer2.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.Key_AlphaPadQVGA_Layer2_pressed.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_AlphaPadQVGA_Layer2_pressed.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_AlphaPadQVGA_Layer2_pressed.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.Key_AlphaPadQVGA_Layer3.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_AlphaPadQVGA_Layer3.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_AlphaPadQVGA_Layer3.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.Key_AlphaPadQVGA_Layer3_pressed.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_AlphaPadQVGA_Layer3_pressed.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_AlphaPadQVGA_Layer3_pressed.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.Key_NumPadLimits.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_NumPadLimits.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_NumPadLimits.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/bminfo.Key_NumPadLimits_pressed.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_NumPadLimits_pressed.bminfo $(AS_PROJECT_PATH)/Logical/Visu_Resized/Bitmaps/Key_NumPadLimits_pressed.png
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


#Bitmaps END




# Trend Configuration
TRE_OBJECTS_Visu_R = $(addprefix $(TEMP_PATH_Visu_R)/tre., $(notdir $(TRE_SOURCES_Visu_R:.tre=.vco)))

$(TEMP_PATH_Visu_R)/tre.Trend_1.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Trends/Trend_1.tre
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


#Trend Configuration END




# Trend Data
TRD_OBJECTS_Visu_R = $(addprefix $(TEMP_PATH_Visu_R)/trd., $(notdir $(TRD_SOURCES_Visu_R:.trd=.vco)))

$(TEMP_PATH_Visu_R)/trd.CPUTemperature.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Trends/CPUTemperature.trd
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/trd.ROOMTemperature.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Trends/ROOMTemperature.trd
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/trd.TrendData_1.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Trends/TrendData_1.trd
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


$(TEMP_PATH_Visu_R)/trd.TrendData_2.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Trends/TrendData_2.trd
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


#Trend Data END




# Trend Data Configuration
TDC_OBJECTS_Visu_R = $(addprefix $(TEMP_PATH_Visu_R)/tdc., $(notdir $(TDC_SOURCES_Visu_R:.tdc=.vco)))

$(TEMP_PATH_Visu_R)/tdc.TrendData.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/Trends/TrendData.tdc
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


#Trend Data Configuration END




# ColorMap Table
CLM_OBJECTS_Visu_R = $(addprefix $(TEMP_PATH_Visu_R)/clm., $(notdir $(CLM_SOURCES_Visu_R:.clm=.vco)))

$(TEMP_PATH_Visu_R)/clm.ColorMap_1.vco: $(AS_PROJECT_PATH)/Logical/Visu_Resized/ColorMaps/ColorMap_1.clm
	 $(VCC) -f '$<' -o '$@' -l '$(AS_PROJECT_PATH)/Logical/VCShared/Languages.vcr' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -pal '$(PALFILE_Visu_R)' $(VCCFLAGS_Visu_R)  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas


#ColorMap Table END


#
# Borders
#
BDR_SOURCES_Visu_R=$(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Decrease.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Decrease_pressed.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Global_Area.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Global_Area_pressed.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Increase.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Increase_pressed.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Multi_Scroll_Down.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Multi_Scroll_Down_pressed.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Multi_Scroll_Up.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Multi_Scroll_Up_pressed.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Radio.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Radio_selected.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Scoll_Up.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Scoll_Up_pressed.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Scroll_Down.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Scroll_Down_pressed.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Scroll_Left.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Scroll_Left_pressed.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Scroll_Right.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_Scroll_Right_pressed.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_pressed.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/SunkenNG.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/CheckBox_checked.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Flat_black.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Flat_grey.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/FrameHeader.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/OverdriveBorder.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/ProgressBarBorder.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/RaisedInner.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Raised.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/SliderBorder09.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/SunkenOuter.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Sunken.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/SunkenNGgray.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/FrameGlobal.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/FrameInvisible.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_KeyRingOff.bdr $(AS_PROJECT_PATH)/Logical/Visu_Resized/Borders/Button_KeyRingOn.bdr 
BDR_OBJECTS_Visu_R=$(TEMP_PATH_Visu_R)/bdr.Bordermanager.vco
$(TEMP_PATH_Visu_R)/bdr.Bordermanager.vco: $(BDR_SOURCES_Visu_R)
	$(VCC) -f '$<' -o '$@' -pkg '$(SRC_PATH_Visu_R)' $(BDRFLAGS_Visu_R) $(VCCFLAGS_Visu_R) -p Visu_R$(SRC_PATH_Visu_R)
#
# Logical fonts
#
$(TEMP_PATH_Visu_R)/lfnt.en.vco: $(TEMP_PATH_Visu_R)/en.lfnt $(VC_LANGUAGES_Visu_R)
	 $(VCC) -f '$<' -o '$@' $(LFNTFLAGS_Visu_R) $(VCCFLAGS_Visu_R) -p Visu_R -sfas
$(TEMP_PATH_Visu_R)/lfnt.de.vco: $(TEMP_PATH_Visu_R)/de.lfnt $(VC_LANGUAGES_Visu_R)
	 $(VCC) -f '$<' -o '$@' $(LFNTFLAGS_Visu_R) $(VCCFLAGS_Visu_R) -p Visu_R -sfas
LFNT_OBJECTS_Visu_R=$(TEMP_PATH_Visu_R)/lfnt.en.vco $(TEMP_PATH_Visu_R)/lfnt.de.vco 

#Runtime Object
$(VCR_OBJECT_Visu_R) : $(VCR_SOURCE_Visu_R)
	$(VCC) -f '$<' -o '$@' -cv '$(AS_PROJECT_PATH)/Logical/VCShared/ControlVersion.cvinfo' -sl en $(VCCFLAGS_Visu_R) -rt  -p Visu_R -so $(VC_STATIC_OPTIONS_Visu_R) -vcr 4726 -sfas
# Local resources Library rules
LIB_LOCAL_RES_Visu_R=$(TEMP_PATH_Visu_R)/localres.vca
$(LIB_LOCAL_RES_Visu_R) : $(TEMP_PATH_Visu_R)/Visu_R02.ccf

# Bitmap Library rules
LIB_BMP_RES_Visu_R=$(TEMP_PATH_Visu_R)/bmpres.vca
$(LIB_BMP_RES_Visu_R) : $(TEMP_PATH_Visu_R)/Visu_R03.ccf
$(BMGRP_OBJECTS_Visu_R) : $(PALFILE_Visu_R) $(VC_LANGUAGES_Visu_R)
$(BMINFO_OBJECTS_Visu_R) : $(PALFILE_Visu_R)

BUILD_FILE_Visu_R=$(TEMP_PATH_Visu_R)/BuildFiles.arg
$(BUILD_FILE_Visu_R) : BUILD_FILE_CLEAN_Visu_R $(BUILD_SOURCES_Visu_R)
BUILD_FILE_CLEAN_Visu_R:
	$(RM) /F /Q '$(BUILD_FILE_Visu_R)' 2>nul
#All Modules depending to this project
PROJECT_MODULES_Visu_R=$(AS_CPU_PATH)/Visu_R01.br $(AS_CPU_PATH)/Visu_R02.br $(AS_CPU_PATH)/Visu_R03.br $(FONT_MODULES_Visu_R) $(SHARED_MODULE)

# General Build rules

$(TARGET_FILE_Visu_R): $(PROJECT_MODULES_Visu_R) $(TEMP_PATH_Visu_R)/Visu_R.prj
	$(MODGEN) -so $(VC_STATIC_OPTIONS_Visu_R) -fw '$(VCFIRMWAREPATH)' -m $(VCSTPOST) -v V1.00.0 -f '$(TEMP_PATH_Visu_R)/Visu_R.prj' -o '$@' -vc '$(VCOBJECT_Visu_R)' $(DEPENDENCIES_Visu_R) $(addprefix -d ,$(notdir $(PROJECT_MODULES_Visu_R:.br=)))

$(AS_CPU_PATH)/Visu_R01.br: $(TEMP_PATH_Visu_R)/Visu_R01.ccf
	$(MODGEN) -so $(VC_STATIC_OPTIONS_Visu_R) -fw '$(VCFIRMWAREPATH)' -m $(VCLOD) -v V1.00.0 -b -vc '$(VCOBJECT_Visu_R)' -f '$<' -o '$@' $(DEPENDENCIES_Visu_R)

$(AS_CPU_PATH)/Visu_R02.br: $(TEMP_PATH_Visu_R)/Visu_R02.ccf
	$(MODGEN) -so $(VC_STATIC_OPTIONS_Visu_R) -fw '$(VCFIRMWAREPATH)' -m $(VCLOD) -v V1.00.0 -b -vc '$(VCOBJECT_Visu_R)' -f '$<' -o '$@' $(DEPENDENCIES_Visu_R)

$(AS_CPU_PATH)/Visu_R03.br: $(TEMP_PATH_Visu_R)/Visu_R03.ccf
	$(MODGEN) -so $(VC_STATIC_OPTIONS_Visu_R) -fw '$(VCFIRMWAREPATH)' -m $(VCLOD) -v V1.00.0 -b -vc '$(VCOBJECT_Visu_R)' -f '$<' -o '$@' $(DEPENDENCIES_Visu_R)

# General Build rules END
$(LIB_LOCAL_OBJ_Visu_R) : $(TEMP_PATH_Visu_R)/Visu_R01.ccf

# Main Module
$(TEMP_PATH_ROOT_Visu_R)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/VCShared/Visu_R.vcm:
$(TEMP_PATH_Visu_R)/Visu_R.prj: $(TEMP_PATH_ROOT_Visu_R)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/VCShared/Visu_R.vcm
	$(VCDEP) -m '$(TEMP_PATH_ROOT_Visu_R)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/VCShared/Visu_R.vcm' -s '$(AS_CPU_PATH)/VCShared/Shared.vcm' -p '$(AS_PATH)/AS/VC/Firmware' -c '$(AS_CPU_PATH)' -fw '$(VCFIRMWAREPATH)' -hw '$(CPUHWC)' -so $(VC_STATIC_OPTIONS_Visu_R) -o Visu_R -proj Visu_R
	$(VCPL) $(notdir $(PROJECT_MODULES_Visu_R:.br=,4)) Visu_R,2 -o '$@' -p Visu_R -vc 'Visu_R' -verbose 'False' -fl '$(TEMP_PATH_ROOT_Visu_R)/Objects/$(AS_CONFIGURATION)/$(AS_TEMP_PLC)/VCShared/Visu_R.vcm' -vcr '$(VCR_SOURCE_Visu_R)' -prj '$(AS_PROJECT_PATH)' -warningLevel2 -sfas

# 01 Module

DEL_TARGET01_LFL_Visu_R=$(TEMP_PATH_Visu_R)\Visu_R01.ccf.lfl
$(TEMP_PATH_Visu_R)/Visu_R01.ccf: $(LIB_SHARED) $(SHARED_CCF) $(LIB_BMP_RES_Visu_R) $(TEMP_PATH_Visu_R)/Visu_R03.ccf $(LIB_LOCAL_RES_Visu_R) $(TEMP_PATH_Visu_R)/Visu_R02.ccf $(DIS_OBJECTS_Visu_R) $(PAGE_OBJECTS_Visu_R) $(VCS_OBJECTS_Visu_R) $(VCVK_OBJECTS_Visu_R) $(VCRT_OBJECTS_Visu_R) $(TPR_OBJECTS_Visu_R) $(TXTGRP_OBJECTS_Visu_R) $(LAYER_OBJECTS_Visu_R) $(VCR_OBJECT_Visu_R) $(TDC_OBJECTS_Visu_R) $(TRD_OBJECTS_Visu_R) $(TRE_OBJECTS_Visu_R) $(PRC_OBJECTS_Visu_R) $(SCR_OBJECTS_Visu_R)
	-@CMD /Q /C if exist "$(DEL_TARGET01_LFL_Visu_R)" DEL /F /Q "$(DEL_TARGET01_LFL_Visu_R)" 2>nul
	@$(VCFLGEN) '$@.lfl' '$(LIB_SHARED)' -temp '$(TEMP_PATH_Visu_R)' -prj '$(PRJ_PATH_Visu_R)' -sfas
	@$(VCFLGEN) '$@.lfl' '$(LIB_BMP_RES_Visu_R)' -temp '$(TEMP_PATH_Visu_R)' -prj '$(PRJ_PATH_Visu_R)' -sfas
	@$(VCFLGEN) '$@.lfl' '$(LIB_LOCAL_RES_Visu_R)' -temp '$(TEMP_PATH_Visu_R)' -prj '$(PRJ_PATH_Visu_R)' -sfas
	@$(VCFLGEN) '$@.lfl' '$(DIS_OBJECTS_Visu_R:.vco=.vco|)' -temp '$(TEMP_PATH_Visu_R)' -prj '$(PRJ_PATH_Visu_R)' -sfas
	@$(VCFLGEN) '$@.lfl' -mask .page -vcp '$(AS_PROJECT_PATH)/Logical/Visu_Resized/Package.vcp' -temp '$(TEMP_PATH_Visu_R)' -prj '$(PRJ_PATH_Visu_R)' -sfas
	@$(VCFLGEN) '$@.lfl' '$(VCS_OBJECTS_Visu_R:.vco=.vco|)' -temp '$(TEMP_PATH_Visu_R)' -prj '$(PRJ_PATH_Visu_R)' -sfas
	@$(VCFLGEN) '$@.lfl' -mask .vcvk -vcp '$(AS_PROJECT_PATH)/Logical/Visu_Resized/Package.vcp' -temp '$(TEMP_PATH_Visu_R)' -prj '$(PRJ_PATH_Visu_R)' -sfas
	@$(VCFLGEN) '$@.lfl' '$(VCRT_OBJECTS_Visu_R:.vco=.vco|)' -temp '$(TEMP_PATH_Visu_R)' -prj '$(PRJ_PATH_Visu_R)' -sfas
	@$(VCFLGEN) '$@.lfl' '$(TPR_OBJECTS_Visu_R:.vco=.vco|)' -temp '$(TEMP_PATH_Visu_R)' -prj '$(PRJ_PATH_Visu_R)' -sfas
	@$(VCFLGEN) '$@.lfl' -mask .txtgrp -vcp '$(AS_PROJECT_PATH)/Logical/Visu_Resized/Package.vcp' -temp '$(TEMP_PATH_Visu_R)' -prj '$(PRJ_PATH_Visu_R)' -sfas
	@$(VCFLGEN) '$@.lfl' -mask .layer -vcp '$(AS_PROJECT_PATH)/Logical/Visu_Resized/Package.vcp' -temp '$(TEMP_PATH_Visu_R)' -prj '$(PRJ_PATH_Visu_R)' -sfas
	@$(VCFLGEN) '$@.lfl' '$(VCR_OBJECT_Visu_R:.vco=.vco|)' -temp '$(TEMP_PATH_Visu_R)' -prj '$(PRJ_PATH_Visu_R)' -sfas
	@$(VCFLGEN) '$@.lfl' -mask .tdc -vcp '$(AS_PROJECT_PATH)/Logical/Visu_Resized/Package.vcp' -temp '$(TEMP_PATH_Visu_R)' -prj '$(PRJ_PATH_Visu_R)' -sfas
	@$(VCFLGEN) '$@.lfl' -mask .trd -vcp '$(AS_PROJECT_PATH)/Logical/Visu_Resized/Package.vcp' -temp '$(TEMP_PATH_Visu_R)' -prj '$(PRJ_PATH_Visu_R)' -sfas
	@$(VCFLGEN) '$@.lfl' '$(TEMP_PATH_Visu_R)/tre.Trend_1.vco' -temp '$(TEMP_PATH_Visu_R)' -prj '$(PRJ_PATH_Visu_R)' -sfas
	@$(VCFLGEN) '$@.lfl' '$(SCR_OBJECTS_Visu_R:.vco=.vco|)' -temp '$(TEMP_PATH_Visu_R)' -prj '$(PRJ_PATH_Visu_R)' -sfas
	$(LINK) '$@.lfl' -o '$@' -p Visu_R -lib '$(LIB_LOCAL_OBJ_Visu_R)' -P '$(AS_PROJECT_PATH)' -m 'local objects' -profile 'False' -warningLevel2 -vcr 4726 -sfas
# 01 Module END

# 02 Module

DEL_TARGET02_LFL_Visu_R=$(TEMP_PATH_Visu_R)\Visu_R02.ccf.lfl
$(TEMP_PATH_Visu_R)/Visu_R02.ccf: $(LIB_SHARED) $(SHARED_CCF) $(LIB_BMP_RES_Visu_R) $(TEMP_PATH_Visu_R)/Visu_R03.ccf $(BDR_OBJECTS_Visu_R) $(LFNT_OBJECTS_Visu_R) $(CLM_OBJECTS_Visu_R)
	-@CMD /Q /C if exist "$(DEL_TARGET02_LFL_Visu_R)" DEL /F /Q "$(DEL_TARGET02_LFL_Visu_R)" 2>nul
	@$(VCFLGEN) '$@.lfl' '$(LIB_SHARED)' -temp '$(TEMP_PATH_Visu_R)' -prj '$(PRJ_PATH_Visu_R)' -sfas
	@$(VCFLGEN) '$@.lfl' '$(LIB_BMP_RES_Visu_R)' -temp '$(TEMP_PATH_Visu_R)' -prj '$(PRJ_PATH_Visu_R)' -sfas
	@$(VCFLGEN) '$@.lfl' '$(BDR_OBJECTS_Visu_R:.vco=.vco|)' -temp '$(TEMP_PATH_Visu_R)' -prj '$(PRJ_PATH_Visu_R)' -sfas
	@$(VCFLGEN) '$@.lfl' '$(LFNT_OBJECTS_Visu_R:.vco=.vco|)' -temp '$(TEMP_PATH_Visu_R)' -prj '$(PRJ_PATH_Visu_R)' -sfas
	@$(VCFLGEN) '$@.lfl' '$(CLM_OBJECTS_Visu_R:.vco=.vco|)' -temp '$(TEMP_PATH_Visu_R)' -prj '$(PRJ_PATH_Visu_R)' -sfas
	$(LINK) '$@.lfl' -o '$@' -p Visu_R -lib '$(LIB_LOCAL_RES_Visu_R)' -P '$(AS_PROJECT_PATH)' -m 'local resources' -profile 'False' -warningLevel2 -vcr 4726 -sfas
# 02 Module END

# 03 Module

DEL_TARGET03_LFL_Visu_R=$(TEMP_PATH_Visu_R)\Visu_R03.ccf.lfl
$(TEMP_PATH_Visu_R)/Visu_R03.ccf: $(LIB_SHARED) $(SHARED_CCF) $(BMGRP_OBJECTS_Visu_R) $(BMINFO_OBJECTS_Visu_R) $(PALFILE_Visu_R)
	-@CMD /Q /C if exist "$(DEL_TARGET03_LFL_Visu_R)" DEL /F /Q "$(DEL_TARGET03_LFL_Visu_R)" 2>nul
	@$(VCFLGEN) '$@.lfl' '$(LIB_SHARED)' -temp '$(TEMP_PATH_Visu_R)' -prj '$(PRJ_PATH_Visu_R)' -sfas
	@$(VCFLGEN) '$@.lfl' -mask .bmgrp -vcp '$(AS_PROJECT_PATH)/Logical/Visu_Resized/Package.vcp' -temp '$(TEMP_PATH_Visu_R)' -prj '$(PRJ_PATH_Visu_R)' -sfas
	@$(VCFLGEN) '$@.lfl' -mask .bminfo -vcp '$(AS_PROJECT_PATH)/Logical/Visu_Resized/Package.vcp' -temp '$(TEMP_PATH_Visu_R)' -prj '$(PRJ_PATH_Visu_R)' -sfas
	$(LINK) '$@.lfl' -o '$@' -p Visu_R -lib '$(LIB_BMP_RES_Visu_R)' -P '$(AS_PROJECT_PATH)' -m 'bitmap resources' -profile 'False' -warningLevel2 -vcr 4726 -sfas
# 03 Module END

# Post Build Steps

.PHONY : vcPostBuild_Visu_R

vcPostBuild_Visu_R :
	$(VCC) -pb -vcm '$(TEMP_PATH_Visu_R)/MODULEFILES.vcm' -fw '$(VCFIRMWAREPATH)' $(VCCFLAGS_Visu_R) -p Visu_R -vcr 4726 -sfas

# Post Build Steps END

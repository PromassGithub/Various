$(AS_CPU_PATH)/TCData/TCData.imx: \
	$(AS_INSTALL_PATH)/AS/TechnologyPackages/TextSystem/n.d/ObjectCatalog/Elements/TextConfig/Template/TC.textconfig 
	@'$(AS_BIN_PATH)/BR.AS.Textsystem.Builder.exe' '' -o '$(AS_CPU_PATH)/TCData/TCData.imx' -c '$(AS_INSTALL_PATH)/AS/TechnologyPackages/TextSystem/n.d/ObjectCatalog/Elements/TextConfig/Template/TC.textconfig' -I '$(AS_SYSTEM_PATH)/O0434 $(AS_INSTALL_PATH)/AS/TechnologyPackages/mapp/1.63.0 $(AS_INSTALL_PATH)/AS/TechnologyPackages/UnitSystem/n.d'  -P '$(AS_PROJECT_PATH)'

$(AS_CPU_PATH)/TCData/TCData.s18d: \
	$(AS_CPU_PATH)/TCData/TCData.imx 
	@'$(AS_BIN_PATH)/BR.AS.MsgCompiler.exe' '$(AS_CPU_PATH)/TCData/TCData.imx' -o '$(AS_CPU_PATH)/TCData/TCData.s18d'

$(AS_CPU_PATH)/TCData.br: \
	$(AS_CPU_PATH)/TCData/TCData.s18d 
	@'$(AS_BIN_PATH)/BR.AS.BuildBrModule.exe' '$(AS_CPU_PATH)/TCData/TCData.s18d' -o '$(AS_CPU_PATH)/TCData.br' -t TextModule


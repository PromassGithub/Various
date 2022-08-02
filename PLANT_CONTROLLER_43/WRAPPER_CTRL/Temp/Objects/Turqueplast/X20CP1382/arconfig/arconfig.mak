$(AS_CPU_PATH)/arconfig.br: \
	$(AS_PROJECT_CONFIG_PATH)/Hardware.hw \
	$(AS_PROJECT_CPU_PATH)/IoMap.iom \
	$(AS_PROJECT_PATH)/Physical/$(AS_CONFIGURATION)/Hardware.hw
	@'$(AS_BIN_PATH)/BR.AS.ConfigurationBuilder.exe' '$(AS_PROJECT_CONFIG_PATH)/Hardware.hw' '$(AS_PROJECT_CPU_PATH)/IoMap.iom'  -arconfig -c Turqueplast -v V1.00.0 -S 'X20CP1382' -Z 'Acp10Arnc0: 5.8.2, mapp: 1.63.0, UnitSystem: n.d, TextSystem: n.d, Connectivity: n.d, AAS: n.d' -o '$(AS_CPU_PATH)/arconfig.br' '$(AS_CPU_PATH)/ChannelConfiguration.xml' '$(AS_CPU_PATH)/HardwareConfiguration.xml' '$(AS_CPU_PATH)/ReActionTechnologyConfiguration.xml' -T SG4  -B O4.34 -P '$(AS_PROJECT_PATH)' -s 'Turqueplast' -secret '$(AS_PROJECT_PATH)_br.as.configurationbuilder.exe'

-include $(AS_CPU_PATH)/Force.mak 

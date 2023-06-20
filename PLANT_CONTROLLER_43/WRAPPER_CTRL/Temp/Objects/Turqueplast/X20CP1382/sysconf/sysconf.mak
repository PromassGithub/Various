$(AS_CPU_PATH)/sysconf.br: \
	$(AS_PROJECT_CONFIG_PATH)/Hardware.hw 
	@'$(AS_BIN_PATH)/BR.AS.ConfigurationBuilder.exe' '$(AS_PROJECT_CONFIG_PATH)/Hardware.hw'  -c Turqueplast -sysconf -S 'X20CP1382' -Z 'Acp10Arnc0: 5.8.2, mapp: 1.63.0, UnitSystem: n.d, TextSystem: n.d, Connectivity: n.d, AAS: n.d' -o '$(AS_CPU_PATH)/sysconf.br' -T SG4  -B O4.34 -P '$(AS_PROJECT_PATH)' -s 'Turqueplast' -secret '$(AS_PROJECT_PATH)_br.as.configurationbuilder.exe'

-include $(AS_CPU_PATH)/Force.mak 

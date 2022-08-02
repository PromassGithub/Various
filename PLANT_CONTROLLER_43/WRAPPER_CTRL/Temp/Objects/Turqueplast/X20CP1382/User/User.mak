UnmarkedObjectFolder := C:/projects/BR/PLANT_CONTROLLER/WRAPPER_CTRL/Physical/Turqueplast/X20CP1382/AccessAndSecurity/UserRoleSystem
MarkedObjectFolder := C:/projects/BR/PLANT_CONTROLLER/WRAPPER_CTRL/Physical/Turqueplast/X20CP1382/AccessAndSecurity/UserRoleSystem

$(AS_CPU_PATH)/User.br: \
	$(AS_PROJECT_CPU_PATH)/AccessAndSecurity/UserRoleSystem/User.user \
	$(AS_PROJECT_CONFIG_PATH)/$(AS_PLC)/AccessAndSecurity/UserRoleSystem/Role.role
	@'$(AS_BIN_PATH)/BR.AS.SystemConfiguration.Builder.exe'   '$(AS_PROJECT_CPU_PATH)/AccessAndSecurity/UserRoleSystem/User.user' -o '$(AS_CPU_PATH)/User.br' -zip -B O4.34 -z n.d -P '$(AS_PROJECT_PATH)' -c '$(AS_CONFIGURATION)' -secret '$(AS_PROJECT_PATH)_br.as.systemconfiguration.builder.exe'


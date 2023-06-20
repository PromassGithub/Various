Requirements for creation of node_modules.zip:

1) Comment (disable) modules in package.json, which are only used for testing
   (currently "grunt-mocha-test", "mocha", "should")

2) Install all other modules with command "npm install"

3) Check if all files for local execution of grunt are in node_modules/.bin
	- node_x64.exe (version 4.4.5)
	- node_x86.exe (version 4.4.5)
	- grunt.cmd
	
4) Check if environment variables for node exist in grunt.cmd
	Example:

	@IF "%PROCESSOR_ARCHITECTURE%" == "x86" goto 32BIT

	   @rem OS is 64bit
	   @"%~dp0\node_x64.exe"  "%~dp0\..\grunt-cli\bin\grunt" %*
	   @goto END

	:32BIT
	   @rem OS is 32bit
	   @"%~dp0\node_x86.exe"  "%~dp0\..\grunt-cli\bin\grunt" %*

	:END
	
5) Check if node-sass has bindings to LibSass for 64bit and 32bit:
node-sass
--vendor
----win32-ia32-46
----win32-x64-48

If all requirements are met, node_modules.zip can be created

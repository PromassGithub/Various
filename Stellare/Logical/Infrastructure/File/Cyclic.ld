PROGRAM _CYCLIC
<?xml version="1.0"?>
<?AutomationStudio Version=3.0.71?>
<!-- Automation Studio Generated XML Section -->
<networks maxcolumn="0">
	<network label="" comment="File explorer" row="6" column="0" commented="0">
		<row>
			<empty/>
			<empty/>
			<functionblock position="header" name="MpFileManagerUI_0" type="MpFileManagerUI"/>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="gFileManagerUI"/>
			<functionblock position="top" type="MpFileManagerUI"><input name="MpLink" vardynamic="true"/><output name="Active"/></functionblock>
			<empty/>
		</row>
		<row>
			<line/>
			<line/>
			<functionblock position="middle" type="MpFileManagerUI"><input name="Enable"/><output name="Error"/></functionblock>
			<empty/>
		</row>
		<row>
			<contact type="open" name="gCoffeeMainLogic.cmdClear"/>
			<line/>
			<functionblock position="middle" type="MpFileManagerUI"><input name="ErrorReset"/><output name="StatusID"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpFileManagerUI"><input name="UISetup"/><output name="Info"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="MpFileManagerUIConnect"/>
			<functionblock position="bottom" type="MpFileManagerUI"><input name="UIConnect" vardynamic="true"/></functionblock>
			<empty/>
		</row>
	</network>
</networks>
END_PROGRAM






















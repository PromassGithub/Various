PROGRAM _EXIT
<?xml version="1.0"?>
<?AutomationStudio Version=3.0.71?>
<!-- Automation Studio Generated XML Section -->
<networks maxcolumn="0">
	<network label="" comment="" row="12" column="0" commented="0">
		<row>
			<empty/>
			<functionblock position="header" name="MpRecipeXml_0" type="MpRecipeXml"/>
			<empty/>
		</row>
		<row>
			<empty/>
			<functionblock position="top" type="MpRecipeXml"><input name="MpLink" vardynamic="true"/><output name="Active"/></functionblock>
			<empty/>
		</row>
		<row>
			<analog type="input" name="0"/>
			<functionblock position="middle" type="MpRecipeXml"><input name="Enable"/><output name="Error"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<functionblock position="middle" type="MpRecipeXml"><input name="ErrorReset"/><output name="StatusID"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<functionblock position="middle" type="MpRecipeXml"><input name="DeviceName" vardynamic="true"/><output name="CommandBusy"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<functionblock position="middle" type="MpRecipeXml"><input name="FileName" vardynamic="true"/><output name="CommandDone"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<functionblock position="middle" type="MpRecipeXml"><input name="Header" vardynamic="true"/><output name="Info"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<functionblock position="middle" type="MpRecipeXml"><input name="Category" vardynamic="true"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<functionblock position="middle" type="MpRecipeXml"><input name="LoadType"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<functionblock position="middle" type="MpRecipeXml"><input name="Load"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<functionblock position="middle" type="MpRecipeXml"><input name="Save"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<functionblock position="bottom" type="MpRecipeXml"><input name="UpdateNotification"/></functionblock>
			<empty/>
		</row>
	</network>
</networks>
END_PROGRAM


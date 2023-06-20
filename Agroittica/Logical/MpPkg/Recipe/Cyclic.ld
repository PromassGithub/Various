PROGRAM _CYCLIC
<?xml version="1.0"?>
<?AutomationStudio FileVersion="4.9"?>
<!-- Automation Studio Generated XML Section -->
<networks maxcolumn="0">
	<network label="" comment="" row="13" column="0" commented="0">
		<row>
			<empty/>
			<empty/>
			<functionblock position="header" name="MpRecipeXml_0" type="MpRecipeXml"/>
			<empty/>
		</row>
		<row>
			<line/>
			<line/>
			<functionblock position="top" type="MpRecipeXml"><input name="EN" ENO="true"/><output name="ENO" ENO="true"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="gRecipeXml"/>
			<functionblock position="middle" type="MpRecipeXml"><input name="MpLink" vardynamic="true"/><output name="Active"/></functionblock>
			<empty/>
		</row>
		<row>
			<line/>
			<line/>
			<functionblock position="middle" type="MpRecipeXml"><input name="Enable"/><output name="Error"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpRecipeXml"><input name="ErrorReset"/><output name="StatusID"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="'Recipe'"/>
			<functionblock position="middle" type="MpRecipeXml"><input name="DeviceName" vardynamic="true"/><output name="CommandBusy"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="'MyRecipe'"/>
			<functionblock position="middle" type="MpRecipeXml"><input name="FileName" vardynamic="true"/><output name="CommandDone"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpRecipeXml"><input name="Header" vardynamic="true"/><output name="Info"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpRecipeXml"><input name="Category" vardynamic="true"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpRecipeXml"><input name="LoadType"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpRecipeXml"><input name="Load"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpRecipeXml"><input name="Save"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="bottom" type="MpRecipeXml"><input name="UpdateNotification"/></functionblock>
			<empty/>
		</row>
	</network>
	<network label="" comment="" row="6" column="0" commented="0">
		<row>
			<empty/>
			<empty/>
			<functionblock position="header" name="MpRecipeRegPar_0" type="MpRecipeRegPar"/>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="gRecipeXml"/>
			<functionblock position="top" type="MpRecipeRegPar"><input name="MpLink" vardynamic="true"/><output name="Active"/></functionblock>
			<empty/>
		</row>
		<row>
			<line/>
			<line/>
			<functionblock position="middle" type="MpRecipeRegPar"><input name="Enable"/><output name="Error"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpRecipeRegPar"><input name="ErrorReset"/><output name="StatusID"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="'Ricetta'"/>
			<functionblock position="middle" type="MpRecipeRegPar"><input name="PVName" vardynamic="true"/><output name="UpdateNotification"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="bottom" type="MpRecipeRegPar"><input name="Category" vardynamic="true"/><output name="Info"/></functionblock>
			<empty/>
		</row>
	</network>
	<network label="" comment="" row="6" column="0" commented="0">
		<row>
			<empty/>
			<empty/>
			<functionblock position="header" name="MpRecipeUI_0" type="MpRecipeUI"/>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="gRecipeXml"/>
			<functionblock position="top" type="MpRecipeUI"><input name="MpLink" vardynamic="true"/><output name="Active"/></functionblock>
			<empty/>
		</row>
		<row>
			<line/>
			<line/>
			<functionblock position="middle" type="MpRecipeUI"><input name="Enable"/><output name="Error"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpRecipeUI"><input name="ErrorReset"/><output name="StatusID"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<analog type="input" name="UISetup"/>
			<functionblock position="middle" type="MpRecipeUI"><input name="UISetup"/><output name="Info"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="UIConnect"/>
			<functionblock position="bottom" type="MpRecipeUI"><input name="UIConnect" vardynamic="true"/></functionblock>
			<empty/>
		</row>
	</network>
</networks>
END_PROGRAM


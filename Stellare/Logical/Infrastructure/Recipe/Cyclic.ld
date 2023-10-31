PROGRAM _CYCLIC
<?xml version="1.0"?>
<?AutomationStudio FileVersion="4.9"?>
<!-- Automation Studio Generated XML Section -->
<networks maxcolumn="0">
	<network label="" comment="Recipe handling" row="12" column="0" commented="0">
		<row>
			<empty/>
			<empty/>
			<functionblock position="header" name="MpRecipeCsv_0" type="MpRecipeCsv"/>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="gRecipeCsv"/>
			<functionblock position="top" type="MpRecipeCsv"><input name="MpLink" vardynamic="true"/><output name="Active"/></functionblock>
			<empty/>
		</row>
		<row>
			<line/>
			<line/>
			<functionblock position="middle" type="MpRecipeCsv"><input name="Enable"/><output name="Error"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpRecipeCsv"><input name="ErrorReset"/><output name="StatusID"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="'mappDir'"/>
			<functionblock position="middle" type="MpRecipeCsv"><input name="DeviceName" vardynamic="true"/><output name="CommandBusy"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="contatore.nome_ricetta2"/>
			<functionblock position="middle" type="MpRecipeCsv"><input name="FileName" vardynamic="true"/><output name="CommandDone"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpRecipeCsv"><input name="Header" vardynamic="true"/><output name="Info"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpRecipeCsv"><input name="Category" vardynamic="true"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpRecipeCsv"><input name="LoadType"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpRecipeCsv"><input name="Load"/></functionblock>
			<empty/>
		</row>
		<row>
			<contact type="open" name="StartGenerate"/>
			<line/>
			<functionblock position="middle" type="MpRecipeCsv"><input name="Save"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="bottom" type="MpRecipeCsv"><input name="UpdateNotification"/></functionblock>
			<empty/>
		</row>
	</network>
	<network label="" comment="Recipe handling connection with the HMI" row="6" column="0" commented="0">
		<row>
			<empty/>
			<empty/>
			<functionblock position="header" name="MpRecipeUI_0" type="MpRecipeUI"/>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="gRecipeCsv"/>
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
			<empty/>
			<functionblock position="middle" type="MpRecipeUI"><input name="UISetup"/><output name="Info"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="MpRecipeUIConnect"/>
			<functionblock position="bottom" type="MpRecipeUI"><input name="UIConnect" vardynamic="true"/></functionblock>
			<empty/>
		</row>
	</network>
	<network label="" comment="Registration of a coffee recipe structure" row="6" column="0" commented="0">
		<row>
			<empty/>
			<empty/>
			<functionblock position="header" name="MpRecipeRegPar_0" type="MpRecipeRegPar"/>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="gRecipeCsv"/>
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
			<functionblock position="middle" type="MpRecipeRegPar"><input name="PVName"/><output name="UpdateNotification"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="bottom" type="MpRecipeRegPar"><input name="Category" vardynamic="true"/><output name="Info"/></functionblock>
			<empty/>
		</row>
	</network>
</networks>
END_PROGRAM






















































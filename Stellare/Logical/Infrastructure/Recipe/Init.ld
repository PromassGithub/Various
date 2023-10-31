PROGRAM _INIT
<?xml version="1.0"?>
<?ladder Version = 3.0?>
<!-- Automation Studio Generated XML Section -->
<networks maxcolumn="0">
	<network label="" comment="Set the recipe load command true, is used to check if the recipes exist on the target" row="1" column="0" commented="1">
		<row>
			<line/>
			<line/>
			<line/>
			<coil type="set" name="MpRecipeXml_0.Load"/>
		</row>
	</network>
	<network label="" comment="Load this recipe which should be there, if not the 3 default recipes are created" row="1" column="0" commented="1">
		<row>
			<analog type="input" name="'mappRegular.xml'"/>
			<function position="topbottom" type="ADR"><input name="in"/><output name="7"/></function>
			<analog type="output" name="MpRecipeXml_0.FileName"/>
		</row>
	</network>
</networks>
END_PROGRAM


















PROGRAM _CYCLIC
<?xml version="1.0"?>
<?AutomationStudio FileVersion="4.9"?>
<!-- Automation Studio Generated XML Section -->
<networks maxcolumn="0">
	<network label="" comment="" row="3" column="0" commented="0">
		<row>
			<empty/>
			<functionblock position="header" name="DTGetTime_0" type="DTGetTime"/>
			<empty/>
		</row>
		<row>
			<line/>
			<functionblock position="top" type="DTGetTime"><input name="enable"/><output name="status"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<functionblock position="bottom" type="DTGetTime"><output name="DT1"/></functionblock>
			<analog type="output" name="glb_time"/>
		</row>
	</network>
</networks>
END_PROGRAM


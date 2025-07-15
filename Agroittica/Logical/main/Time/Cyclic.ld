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
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="positive transition" name="glb_io.Di.Si_01_raw"/>
			<line/>
			<line/>
			<coil type="set" name="glb_io.Di.Si_01"/>
		</row>
	</network>
	<network label="" comment="" row="3" column="0" commented="0">
		<row>
			<empty/>
			<functionblock position="header" name="TON_FASToff" type="TON_10ms"/>
			<empty/>
		</row>
		<row>
			<contact type="closed" name="glb_io.Di.Si_01_raw"/>
			<functionblock position="top" type="TON_10ms"><input name="IN"/><output name="Q"/></functionblock>
			<coil type="reset" name="glb_io.Di.Si_01"/>
		</row>
		<row>
			<analog type="input" name="3"/>
			<functionblock position="bottom" type="TON_10ms"><input name="PT"/><output name="ET"/></functionblock>
			<empty/>
		</row>
	</network>
</networks>
END_PROGRAM




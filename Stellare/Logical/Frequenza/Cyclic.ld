PROGRAM _CYCLIC
<?xml version="1.0"?>
<?AutomationStudio Version=3.0.71?>
<!-- Automation Studio Generated XML Section -->
<networks maxcolumn="0">
	<network label="" comment="" row="3" column="0" commented="0">
		<row>
			<empty/>
			<functionblock position="header" name="TOF_0" type="TOF"/>
			<empty/>
		</row>
		<row>
			<contact type="positive transition" name="contatore.S_stellare"/>
			<functionblock position="top" type="TOF"><input name="IN"/><output name="Q"/></functionblock>
			<analog type="output" name="t_ok"/>
		</row>
		<row>
			<analog type="input" name="tempo"/>
			<functionblock position="bottom" type="TOF"><input name="PT"/><output name="ET"/></functionblock>
			<empty/>
		</row>
	</network>
	<network label="" comment="" row="3" column="0" commented="0">
		<row>
			<contact type="negative transition" name="t_ok"/>
			<function position="top" type="ADD"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="contatore.giri_totali"/>
			<function position="middle" type="ADD"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="contatore.giri_totali"/>
		</row>
		<row>
			<analog type="input" name="contatore.giri_parziali"/>
			<function position="bottom" type="ADD"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
	<network label="" comment="" row="4" column="0" commented="0">
		<row>
			<empty/>
			<functionblock position="header" name="CTU_1" type="CTU"/>
			<empty/>
		</row>
		<row>
			<contact type="positive transition" name="contatore.S_stellare"/>
			<functionblock position="top" type="CTU"><input name="CU"/><output name="Q"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<functionblock position="middle" type="CTU"><input name="RESET"/><output name="CV"/></functionblock>
			<analog type="output" name="contatore.giri_parziali"/>
		</row>
		<row>
			<empty/>
			<functionblock position="bottom" type="CTU"><input name="PV"/></functionblock>
			<empty/>
		</row>
	</network>
	<network label="" comment="" row="4" column="0" commented="0">
		<row>
			<empty/>
			<functionblock position="header" name="CTU_0" type="CTU"/>
			<empty/>
		</row>
		<row>
			<contact type="positive transition" name="contatore.S_stellare"/>
			<functionblock position="top" type="CTU"><input name="CU"/><output name="Q"/></functionblock>
			<empty/>
		</row>
		<row>
			<contact type="closed" name="azzeramento"/>
			<functionblock position="middle" type="CTU"><input name="RESET"/><output name="CV"/></functionblock>
			<analog type="output" name="contatore.giri_instant"/>
		</row>
		<row>
			<empty/>
			<functionblock position="bottom" type="CTU"><input name="PV"/></functionblock>
			<empty/>
		</row>
	</network>
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="contatore.S_stellare"/>
			<line/>
			<line/>
			<coil type="set" name="azzeramento"/>
		</row>
	</network>
	<network label="" comment="" row="4" column="0" commented="0">
		<row>
			<empty/>
			<functionblock position="header" name="TON_0" type="TON"/>
			<empty/>
			<empty/>
			<empty/>
			<empty/>
			<empty/>
		</row>
		<row>
			<contact type="open" name="azzeramento"/>
			<functionblock position="top" type="TON"><input name="IN"/><output name="Q"/></functionblock>
			<line/>
			<line/>
			<function position="top" type="MOVE"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="tempo"/>
			<functionblock position="bottom" type="TON"><input name="PT"/><output name="ET"/></functionblock>
			<empty or="true"/>
			<analog type="input" name="contatore.giri_instant"/>
			<function position="bottom" type="MOVE"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="contatore.frequenza"/>
		</row>
		<row>
			<empty/>
			<empty/>
			<empty/>
			<empty or="true"/>
			<line/>
			<line/>
			<line/>
			<coil type="reset" name="azzeramento"/>
		</row>
	</network>
</networks>
END_PROGRAM










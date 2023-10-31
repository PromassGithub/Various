PROGRAM _CYCLIC
<?xml version="1.0"?>
<?AutomationStudio Version=3.0.71?>
<!-- Automation Studio Generated XML Section -->
<networks maxcolumn="0">
	<network label="" comment="" row="13" column="0" commented="0">
		<row>
			<empty/>
			<empty/>
			<functionblock position="header" name="MpEnergyCore_0" type="MpEnergyCore"/>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="gEnergyCore"/>
			<functionblock position="top" type="MpEnergyCore"><input name="MpLink" vardynamic="true"/><output name="Active"/></functionblock>
			<empty/>
		</row>
		<row>
			<line/>
			<line/>
			<functionblock position="middle" type="MpEnergyCore"><input name="Enable"/><output name="Error"/></functionblock>
			<empty/>
		</row>
		<row>
			<contact type="open" name="gCoffeeMainLogic.cmdClear"/>
			<line/>
			<functionblock position="middle" type="MpEnergyCore"><input name="ErrorReset"/><output name="StatusID"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpEnergyCore"><input name="TemporaryRecord"/><output name="CombinedActiveEnergy"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="'mappDir'"/>
			<functionblock position="middle" type="MpEnergyCore"><input name="DeviceName" vardynamic="true"/><output name="CombinedReactiveEnergy"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpEnergyCore"><input name="Export"/><output name="ActivePower"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpEnergyCore"><input name="Reset"/><output name="ReactivePower"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpEnergyCore"><output name="CommandBusy"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpEnergyCore"><output name="TemporaryRecording"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpEnergyCore"><output name="ExportDone"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpEnergyCore"><output name="ResetDone"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="bottom" type="MpEnergyCore"><output name="Info"/></functionblock>
			<empty/>
		</row>
	</network>
	<network label="" comment="" row="6" column="0" commented="0">
		<row>
			<empty/>
			<empty/>
			<functionblock position="header" name="MpEnergyCoreUI_0" type="MpEnergyCoreUI"/>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="gEnergyCore"/>
			<functionblock position="top" type="MpEnergyCoreUI"><input name="MpLink" vardynamic="true"/><output name="Active"/></functionblock>
			<empty/>
		</row>
		<row>
			<line/>
			<line/>
			<functionblock position="middle" type="MpEnergyCoreUI"><input name="Enable"/><output name="Error"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpEnergyCoreUI"><input name="ErrorReset"/><output name="StatusID"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpEnergyCoreUI"><input name="UISetup"/><output name="Info"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="MpEnergyUIConnect"/>
			<functionblock position="bottom" type="MpEnergyCoreUI"><input name="UIConnect" vardynamic="true"/></functionblock>
			<empty/>
		</row>
	</network>
</networks>
END_PROGRAM


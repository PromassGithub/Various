PROGRAM _CYCLIC
<?xml version="1.0"?>
<?AutomationStudio FileVersion="4.9"?>
<!-- Automation Studio Generated XML Section -->
<networks maxcolumn="0">
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="closed" name="avvio"/>
			<line/>
			<line/>
			<coil type="set" name="avvio"/>
		</row>
	</network>
	<network label="" comment="" row="7" column="0" commented="0">
		<row>
			<empty/>
			<empty/>
			<functionblock position="header" name="MpAlarmXCore_0" type="MpAlarmXCore"/>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="gAlarmXCore"/>
			<functionblock position="top" type="MpAlarmXCore"><input name="MpLink" vardynamic="true"/><output name="Active"/></functionblock>
			<empty/>
		</row>
		<row>
			<contact type="open" name="XCoreEn"/>
			<line/>
			<functionblock position="middle" type="MpAlarmXCore"><input name="Enable"/><output name="Error"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpAlarmXCore"><input name="ErrorReset"/><output name="StatusID"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpAlarmXCore"><output name="ActiveAlarms"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpAlarmXCore"><output name="PendingAlarms"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="bottom" type="MpAlarmXCore"><output name="Info"/></functionblock>
			<empty/>
		</row>
	</network>
	<network label="" comment="" row="6" column="0" commented="0">
		<row>
			<empty/>
			<empty/>
			<functionblock position="header" name="MpAlarmXListUI_0" type="MpAlarmXListUI"/>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="gAlarmXCore"/>
			<functionblock position="top" type="MpAlarmXListUI"><input name="MpLink" vardynamic="true"/><output name="Active"/></functionblock>
			<empty/>
		</row>
		<row>
			<line/>
			<line/>
			<functionblock position="middle" type="MpAlarmXListUI"><input name="Enable"/><output name="Error"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpAlarmXListUI"><input name="ErrorReset"/><output name="StatusID"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpAlarmXListUI"><input name="UISetup"/><output name="Info"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="MpAlarmXListUIConnect"/>
			<functionblock position="bottom" type="MpAlarmXListUI"><input name="UIConnect" vardynamic="true"/></functionblock>
			<empty/>
		</row>
	</network>
	<network label="" comment="" row="7" column="0" commented="0">
		<row>
			<empty/>
			<empty/>
			<functionblock position="header" name="MpAlarmXHistory_0" type="MpAlarmXHistory"/>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="gAlarmXHistory"/>
			<functionblock position="top" type="MpAlarmXHistory"><input name="MpLink" vardynamic="true"/><output name="Active"/></functionblock>
			<empty/>
		</row>
		<row>
			<line/>
			<line/>
			<functionblock position="middle" type="MpAlarmXHistory"><input name="Enable"/><output name="Error"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpAlarmXHistory"><input name="ErrorReset"/><output name="StatusID"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="'Alarm'"/>
			<functionblock position="middle" type="MpAlarmXHistory"><input name="DeviceName" vardynamic="true"/><output name="CommandBusy"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpAlarmXHistory"><input name="Language" vardynamic="true"/><output name="CommandDone"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="bottom" type="MpAlarmXHistory"><input name="Export"/><output name="Info"/></functionblock>
			<empty/>
		</row>
	</network>
	<network label="" comment="" row="6" column="0" commented="0">
		<row>
			<empty/>
			<empty/>
			<functionblock position="header" name="MpAlarmXHistoryUI_0" type="MpAlarmXHistoryUI"/>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="gAlarmXHistory"/>
			<functionblock position="top" type="MpAlarmXHistoryUI"><input name="MpLink" vardynamic="true"/><output name="Active"/></functionblock>
			<empty/>
		</row>
		<row>
			<line/>
			<line/>
			<functionblock position="middle" type="MpAlarmXHistoryUI"><input name="Enable"/><output name="Error"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpAlarmXHistoryUI"><input name="ErrorReset"/><output name="StatusID"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpAlarmXHistoryUI"><input name="UISetup"/><output name="Info"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="MpAlarmXHistoryUIConnect"/>
			<functionblock position="bottom" type="MpAlarmXHistoryUI"><input name="UIConnect" vardynamic="true"/></functionblock>
			<empty/>
		</row>
	</network>
</networks>
END_PROGRAM




















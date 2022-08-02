PROGRAM _CYCLIC
<?xml version="1.0"?>
<?AutomationStudio FileVersion="4.9"?>
<!-- Automation Studio Generated XML Section -->
<networks maxcolumn="0">
	<network label="" comment="Data recording

Data is recorded with every start of the brewing process." row="11" column="0" commented="0">
		<row>
			<empty/>
			<empty/>
			<functionblock position="header" name="MpDataRecorder_0" type="MpDataRecorder"/>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="gDataRecorder"/>
			<functionblock position="top" type="MpDataRecorder"><input name="MpLink" vardynamic="true"/><output name="Active"/></functionblock>
			<empty/>
		</row>
		<row>
			<line/>
			<line/>
			<functionblock position="middle" type="MpDataRecorder"><input name="Enable"/><output name="Error"/></functionblock>
			<empty/>
		</row>
		<row>
			<contact type="open" name="MpDataRecorder_0.Error"/>
			<line/>
			<functionblock position="middle" type="MpDataRecorder"><input name="ErrorReset"/><output name="StatusID"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="Header"/>
			<functionblock position="middle" type="MpDataRecorder"><input name="Header" vardynamic="true"/><output name="CommandBusy"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="'HD'"/>
			<functionblock position="middle" type="MpDataRecorder"><input name="DeviceName" vardynamic="true"/><output name="Recording"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<analog type="input" name="T#500ms"/>
			<functionblock position="middle" type="MpDataRecorder"><input name="SamplingTime"/><output name="RecordDone"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<analog type="input" name="mpDATA_RECORD_MODE_TIME"/>
			<functionblock position="middle" type="MpDataRecorder"><input name="RecordMode"/><output name="SnapShotDone"/></functionblock>
			<empty/>
		</row>
		<row>
			<contact type="open" name="MpDataRecorder_0.Active"/>
			<contact type="closed" name="MpDataRecorder_0.Error"/>
			<functionblock position="middle" type="MpDataRecorder"><input name="Record"/><output name="Info"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpDataRecorder"><input name="Trigger"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="bottom" type="MpDataRecorder"><input name="SnapShot"/></functionblock>
			<empty/>
		</row>
	</network>
	<network label="" comment="" row="8" column="0" commented="0">
		<row>
			<empty/>
			<empty/>
			<functionblock position="header" name="MpDataRegPar_0" type="MpDataRegPar"/>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="gDataRecorder"/>
			<functionblock position="top" type="MpDataRegPar"><input name="MpLink" vardynamic="true"/><output name="Active"/></functionblock>
			<empty/>
		</row>
		<row>
			<line/>
			<line/>
			<functionblock position="middle" type="MpDataRegPar"><input name="Enable"/><output name="Error"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpDataRegPar"><input name="ErrorReset"/><output name="StatusID"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="'Report'"/>
			<functionblock position="middle" type="MpDataRegPar"><input name="PVName" vardynamic="true"/><output name="Info"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpDataRegPar"><input name="Unit" vardynamic="true"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpDataRegPar"><input name="Description" vardynamic="true"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="bottom" type="MpDataRegPar"><input name="ScaleFactor"/></functionblock>
			<empty/>
		</row>
	</network>
	<network label="" comment="DataTable handling connection with the HMI" row="6" column="0" commented="0">
		<row>
			<empty/>
			<empty/>
			<functionblock position="header" name="MpDataTableUI_0" type="MpDataTableUI"/>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="gDataRecorder"/>
			<functionblock position="top" type="MpDataTableUI"><input name="MpLink" vardynamic="true"/><output name="Active"/></functionblock>
			<empty/>
		</row>
		<row>
			<contact type="open" name="MpDataRecorder_0.Active"/>
			<line/>
			<functionblock position="middle" type="MpDataTableUI"><input name="Enable"/><output name="Error"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpDataTableUI"><input name="ErrorReset"/><output name="StatusID"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpDataTableUI"><input name="UISetup"/><output name="Info"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="MpDataTableUIConnect"/>
			<functionblock position="bottom" type="MpDataTableUI"><input name="UIConnect" vardynamic="true"/></functionblock>
			<empty/>
		</row>
	</network>
	<network label="" comment="DataStatistics handling connection with the HMI" row="6" column="0" commented="0">
		<row>
			<empty/>
			<empty/>
			<functionblock position="header" name="MpDataStatisticsUI_0" type="MpDataStatisticsUI"/>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="gDataRecorder"/>
			<functionblock position="top" type="MpDataStatisticsUI"><input name="MpLink" vardynamic="true"/><output name="Active"/></functionblock>
			<empty/>
		</row>
		<row>
			<contact type="open" name="MpDataRecorder_0.Active"/>
			<line/>
			<functionblock position="middle" type="MpDataStatisticsUI"><input name="Enable"/><output name="Error"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpDataStatisticsUI"><input name="ErrorReset"/><output name="StatusID"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpDataStatisticsUI"><input name="UISetup"/><output name="Info"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="MpDataStatisticsUIConnect"/>
			<functionblock position="bottom" type="MpDataStatisticsUI"><input name="UIConnect" vardynamic="true"/></functionblock>
			<empty/>
		</row>
	</network>
</networks>
END_PROGRAM















































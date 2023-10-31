PROGRAM _CYCLIC
<?xml version="1.0"?>
<?AutomationStudio FileVersion="4.9"?>
<!-- Automation Studio Generated XML Section -->
<networks maxcolumn="0">
	<network label="" comment="PID controller plus attached delay element for simulation" row="16" column="0" commented="0">
		<row>
			<empty/>
			<functionblock position="header" name="MTBasicsPID_0" type="MTBasicsPID"/>
			<empty/>
			<empty/>
			<empty/>
			<empty/>
		</row>
		<row>
			<line/>
			<functionblock position="top" type="MTBasicsPID"><input name="Enable"/><output name="Busy"/></functionblock>
			<empty/>
			<empty/>
			<empty/>
			<empty/>
		</row>
		<row>
			<empty/>
			<functionblock position="middle" type="MTBasicsPID"/>
			<empty/>
			<functionblock position="header" name="MTBasicsPT1_0" type="MTBasicsPT1"/>
			<empty/>
		</row>
		<row>
			<empty/>
			<functionblock position="middle" type="MTBasicsPID"><input name="PIDParameters"/><output name="Active"/></functionblock>
			<line/>
			<functionblock position="top" type="MTBasicsPT1"><input name="Enable"/><output name="Busy"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<functionblock position="middle" type="MTBasicsPID"><input name="MinOut"/><output name="Error"/></functionblock>
			<analog type="input" name="4.0"/>
			<functionblock position="middle" type="MTBasicsPT1"><input name="Gain"/><output name="Active"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<functionblock position="middle" type="MTBasicsPID"><input name="MaxOut"/><output name="StatusID"/></functionblock>
			<analog type="input" name="10.0"/>
			<functionblock position="middle" type="MTBasicsPT1"><input name="TimeConstant"/><output name="Error"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<functionblock position="middle" type="MTBasicsPID"><input name="Invert"/><output name="UpdateDone"/></functionblock>
			<empty/>
			<functionblock position="middle" type="MTBasicsPT1"><input name="Update"/><output name="StatusID"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<functionblock position="middle" type="MTBasicsPID"><input name="Update"/><output name="Out"/></functionblock>
			<line/>
			<functionblock position="middle" type="MTBasicsPT1"><input name="In"/><output name="UpdateDone"/></functionblock>
			<empty/>
		</row>
		<row>
			<analog type="input" name="WaterTemp"/>
			<functionblock position="middle" type="MTBasicsPID"><input name="SetValue"/><output name="ControlError"/></functionblock>
			<analog type="input" name="20.0"/>
			<functionblock position="middle" type="MTBasicsPT1"><input name="OutPresetValue"/><output name="Out"/></functionblock>
			<analog type="output" name="WaterHeaterUIConnect.actTemperature"/>
		</row>
		<row>
			<analog type="input" name="WaterHeaterUIConnect.actTemperature"/>
			<functionblock position="middle" type="MTBasicsPID"><input name="ActValue"/><output name="ProportionalPart"/></functionblock>
			<empty/>
			<functionblock position="bottom" type="MTBasicsPT1"><input name="SetOut"/><output name="SystemReference"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<functionblock position="middle" type="MTBasicsPID"><input name="IntegrationPartPresetValue"/><output name="IntegrationPart"/></functionblock>
			<empty/>
			<empty/>
			<empty/>
			<empty/>
		</row>
		<row>
			<empty/>
			<functionblock position="middle" type="MTBasicsPID"><input name="SetIntegrationPart"/><output name="DerivativePart"/></functionblock>
			<empty/>
			<empty/>
			<empty/>
			<empty/>
		</row>
		<row>
			<empty/>
			<functionblock position="middle" type="MTBasicsPID"><input name="HoldOut"/><output name="TrackingActive"/></functionblock>
			<empty/>
			<empty/>
			<empty/>
			<empty/>
		</row>
		<row>
			<empty/>
			<functionblock position="middle" type="MTBasicsPID"><input name="TrackingValue"/><output name="IntegrationStatus"/></functionblock>
			<empty/>
			<empty/>
			<empty/>
			<empty/>
		</row>
		<row>
			<empty/>
			<functionblock position="middle" type="MTBasicsPID"><input name="EnableTracking"/><output name="SystemReference"/></functionblock>
			<empty/>
			<empty/>
			<empty/>
			<empty/>
		</row>
		<row>
			<empty/>
			<functionblock position="bottom" type="MTBasicsPID"><input name="HoldIntegration"/></functionblock>
			<empty/>
			<empty/>
			<empty/>
			<empty/>
		</row>
	</network>
</networks>
END_PROGRAM












































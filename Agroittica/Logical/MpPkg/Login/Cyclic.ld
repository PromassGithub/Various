PROGRAM _CYCLIC
<?xml version="1.0"?>
<?AutomationStudio FileVersion="4.9"?>
<!-- Automation Studio Generated XML Section -->
<networks maxcolumn="0">
	<network label="" comment="" row="11" column="0" commented="0">
		<row>
			<empty/>
			<empty/>
			<functionblock position="header" name="MpUserLogin_0" type="MpUserLogin"/>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="top" type="MpUserLogin"><input name="EN" ENO="true"/><output name="ENO" ENO="true"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="gUserLogin"/>
			<functionblock position="middle" type="MpUserLogin"><input name="MpLink" vardynamic="true"/><output name="Active"/></functionblock>
			<empty/>
		</row>
		<row>
			<line/>
			<line/>
			<functionblock position="middle" type="MpUserLogin"><input name="Enable"/><output name="Error"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpUserLogin"><input name="ErrorReset"/><output name="StatusID"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpUserLogin"><input name="LifeSign"/><output name="CommandBusy"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpUserLogin"><input name="Login"/><output name="CommandDone"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpUserLogin"><input name="Logout"/><output name="CurrentUser"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="glb_Login.Username"/>
			<functionblock position="middle" type="MpUserLogin"><input name="UserName" vardynamic="true"/><output name="CurrentLevel"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="glb_Login.Password"/>
			<functionblock position="middle" type="MpUserLogin"><input name="Password" vardynamic="true"/><output name="AccessRights"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="bottom" type="MpUserLogin"><output name="Info"/></functionblock>
			<empty/>
		</row>
	</network>
	<network label="" comment="" row="6" column="0" commented="0">
		<row>
			<empty/>
			<empty/>
			<functionblock position="header" name="MpUserLoginUI_0" type="MpUserLoginUI"/>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="top" type="MpUserLoginUI"><input name="EN" ENO="true"/><output name="ENO" ENO="true"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="gUserLogin"/>
			<functionblock position="middle" type="MpUserLoginUI"><input name="MpLink" vardynamic="true"/><output name="Active"/></functionblock>
			<empty/>
		</row>
		<row>
			<line/>
			<line/>
			<functionblock position="middle" type="MpUserLoginUI"><input name="Enable"/><output name="Error"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpUserLoginUI"><input name="ErrorReset"/><output name="StatusID"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="bottom" type="MpUserLoginUI"><input name="UIConnect" vardynamic="true"/><output name="Info"/></functionblock>
			<empty/>
		</row>
	</network>
</networks>
END_PROGRAM




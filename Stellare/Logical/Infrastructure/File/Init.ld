PROGRAM _INIT
<?xml version="1.0"?>
<?ladder Version = 3.0?>
<!-- Automation Studio Generated XML Section -->
<networks maxcolumn="0">
	<network label="" comment="Create &quot;mapp&quot; folder during boot up &gt; reset when folder already exists " row="4" column="0" commented="0">
		<row>
			<empty/>
			<empty/>
			<functionblock position="header" name="DirCreate_0" type="DirCreate"/>
			<empty/>
		</row>
		<row>
			<contact type="open" name="CreateFolder"/>
			<line/>
			<functionblock position="top" type="DirCreate"><input name="enable"/><output name="status"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="'HD'"/>
			<functionblock position="middle" type="DirCreate"><input name="pDevice"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="'mappDemo'"/>
			<functionblock position="bottom" type="DirCreate"><input name="pName"/></functionblock>
			<empty/>
		</row>
	</network>
	<network label="" comment="reset when folder already exists " row="2" column="0" commented="0">
		<row>
			<empty/>
			<function position="top" type="Compare!"><input name=""/><output name="56"/></function>
			<coil type="reset" name="CreateFolder"/>
		</row>
		<row>
			<empty/>
			<function position="bottom" type="Compare!"><input name="&lt;!DirCreate_0.status = fiERR_DIR_ALREADY_EXIST"/></function>
			<empty/>
		</row>
	</network>
	<network label="" comment="Call disabled" row="4" column="0" commented="0">
		<row>
			<empty/>
			<empty/>
			<functionblock position="header" name="DirCreate_0" type="DirCreate"/>
			<empty/>
		</row>
		<row>
			<contact type="open" name="CreateFolder"/>
			<line/>
			<functionblock position="top" type="DirCreate"><input name="enable"/><output name="status"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="'HD'"/>
			<functionblock position="middle" type="DirCreate"><input name="pDevice"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="'mappDemo'"/>
			<functionblock position="bottom" type="DirCreate"><input name="pName"/></functionblock>
			<empty/>
		</row>
	</network>
	<network label="" comment="Create &quot;'Reports&quot; folder during boot up &gt; reset when folder already exists " row="4" column="0" commented="0">
		<row>
			<empty/>
			<empty/>
			<functionblock position="header" name="DirCreate_1" type="DirCreate"/>
			<empty/>
		</row>
		<row>
			<line/>
			<line/>
			<functionblock position="top" type="DirCreate"><input name="enable"/><output name="status"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="'mappDir'"/>
			<functionblock position="middle" type="DirCreate"><input name="pDevice"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="'Reports'"/>
			<functionblock position="bottom" type="DirCreate"><input name="pName"/></functionblock>
			<empty/>
		</row>
	</network>
	<network label="" comment="reset when folder already exists " row="2" column="0" commented="0">
		<row>
			<empty/>
			<function position="top" type="Compare!"><input name=""/><output name="56"/></function>
			<coil type="reset" name="CreateReportsFolder"/>
		</row>
		<row>
			<empty/>
			<function position="bottom" type="Compare!"><input name="&lt;!DirCreate_1.status = fiERR_DIR_ALREADY_EXIST"/></function>
			<empty/>
		</row>
	</network>
	<network label="" comment="Call disabled" row="4" column="0" commented="0">
		<row>
			<empty/>
			<empty/>
			<functionblock position="header" name="DirCreate_1" type="DirCreate"/>
			<empty/>
		</row>
		<row>
			<line/>
			<line/>
			<functionblock position="top" type="DirCreate"><input name="enable"/><output name="status"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="'mappDir'"/>
			<functionblock position="middle" type="DirCreate"><input name="pDevice"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="'Reports'"/>
			<functionblock position="bottom" type="DirCreate"><input name="pName"/></functionblock>
			<empty/>
		</row>
	</network>
</networks>
END_PROGRAM



























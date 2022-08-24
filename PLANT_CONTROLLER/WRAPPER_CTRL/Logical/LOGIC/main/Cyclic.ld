PROGRAM _CYCLIC
<?xml version="1.0"?>
<?AutomationStudio FileVersion="4.9"?>
<!-- Automation Studio Generated XML Section -->
<networks maxcolumn="0">
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="glbMac01On"/>
			<line/>
			<line/>
			<coil type="open" name="gMAC01.LiveSignal"/>
		</row>
	</network>
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="gMAC01raw.Di.Alarm"/>
			<line/>
			<line/>
			<coil type="open" name="gMAC01.Alarm"/>
		</row>
	</network>
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="gMAC01raw.Di.CommitEnd"/>
			<line/>
			<line/>
			<coil type="open" name="gMAC01.CommitEnd"/>
		</row>
	</network>
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="gMAC01raw.Di.Manual"/>
			<contact type="open" name="gMAC01raw.Di.Run"/>
			<line/>
			<coil type="open" name="gMAC01.ManMode"/>
		</row>
	</network>
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="closed" name="gMAC01raw.Di.Manual"/>
			<contact type="open" name="gMAC01raw.Di.Run"/>
			<line/>
			<coil type="open" name="gMAC01.AutoMode"/>
		</row>
	</network>
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="closed" name="gMAC01raw.Di.Run"/>
			<line/>
			<line/>
			<coil type="open" name="gMAC01.Stop"/>
		</row>
	</network>
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="gMAC01raw.Di.Run"/>
			<line/>
			<line/>
			<coil type="open" name="gMAC01.Run"/>
		</row>
	</network>
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="gMAC01raw.Di.MoldChange"/>
			<line/>
			<line/>
			<coil type="open" name="gMAC01.MCH_on"/>
		</row>
	</network>
	<network label="" comment="" row="3" column="0" commented="0">
		<row>
			<empty/>
			<functionblock position="header" name="M1_NewCycle" type="TON"/>
			<empty/>
		</row>
		<row>
			<contact type="open" name="gMAC01raw.Di.NewCycleSignal"/>
			<functionblock position="top" type="TON"><input name="IN"/><output name="Q"/></functionblock>
			<analog type="output" name="gMAC01raw.Di.NewCycleTrigger"/>
		</row>
		<row>
			<analog type="input" name="T#1s"/>
			<functionblock position="bottom" type="TON"><input name="PT"/><output name="ET"/></functionblock>
			<empty/>
		</row>
	</network>
	<network label="" comment="Copy Last Actual Cycle Time to the last Cycle Time" row="2" column="0" commented="0">
		<row>
			<contact type="positive transition" name="gMAC01raw.Di.NewCycleTrigger"/>
			<function position="top" type="MOVE"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="gMAC01.ActualCycleTime"/>
			<function position="bottom" type="MOVE"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="gMAC01.LastCycleTime"/>
		</row>
	</network>
	<network label="" comment="" row="3" column="0" commented="0">
		<row>
			<contact type="positive transition" name="gMAC01raw.Di.NewCycleTrigger"/>
			<function position="top" type="ADD"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="gMac01LifeCounter"/>
			<function position="middle" type="ADD"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="gMac01LifeCounter"/>
		</row>
		<row>
			<analog type="input" name="1"/>
			<function position="bottom" type="ADD"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
	<network label="" comment="" row="2" column="0" commented="0">
		<row>
			<analog type="input" name="gMac01LifeCounter"/>
			<function position="top" type="ADD"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="gMAC01.LifeCycles"/>
		</row>
		<row>
			<analog type="input" name="gMac01CounterOffset"/>
			<function position="bottom" type="ADD"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
	<network label="" comment="" row="2" column="0" commented="0">
		<row>
			<contact type="positive transition" name="gMAC01raw.Di.NewCycleTrigger"/>
			<function position="top" type="MOVE"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="0"/>
			<function position="bottom" type="MOVE"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="gMAC01.ActualCycleTime"/>
		</row>
	</network>
	<network label="" comment="" row="2" column="0" commented="0">
		<row>
			<analog type="input" name="gMAC01.ActualCycleTime"/>
			<function position="top" type="LT"><input name="" extensible="true"/><output name="1"/></function>
			<contact type="positive transition" name="gPulse_100"/>
			<coil type="open" name="gCounter01"/>
		</row>
		<row>
			<analog type="input" name="3000"/>
			<function position="bottom" type="LT"><input name="" extensible="true"/></function>
			<empty/>
			<empty/>
		</row>
	</network>
	<network label="" comment="" row="3" column="0" commented="0">
		<row>
			<empty/>
			<empty/>
			<empty/>
			<functionblock position="header" name="M1_AUTO_1s" type="TON"/>
			<empty/>
		</row>
		<row>
			<contact type="closed" name="g1secTick01"/>
			<contact type="open" name="gMAC01.AutoMode"/>
			<contact type="open" name="gMAC01.Run"/>
			<functionblock position="top" type="TON"><input name="IN"/><output name="Q"/></functionblock>
			<coil type="open" name="g1secTick01"/>
		</row>
		<row>
			<empty/>
			<empty/>
			<analog type="input" name="T#1s"/>
			<functionblock position="bottom" type="TON"><input name="PT"/><output name="ET"/></functionblock>
			<empty/>
		</row>
	</network>
	<network label="" comment="" row="3" column="0" commented="0">
		<row>
			<contact type="open" name="gMAC01.AutoMode"/>
			<contact type="open" name="gMAC01.Run"/>
			<contact type="positive transition" name="g1secTick01"/>
			<function position="top" type="ADD"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<analog type="input" name="1"/>
			<function position="middle" type="ADD"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="gMAC01.ActualCycleTime"/>
		</row>
		<row>
			<empty/>
			<empty/>
			<analog type="input" name="gMAC01.ActualCycleTime"/>
			<function position="bottom" type="ADD"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
	<network label="" comment="" row="3" column="0" commented="0">
		<row>
			<analog type="input" name="gMAC01.LastCycleTime"/>
			<function position="top" type="GT"><input name="" extensible="true"/><output name="1"/></function>
			<line/>
			<function position="top" type="DIV"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="0"/>
			<function position="bottom" type="GT"><input name="" extensible="true"/></function>
			<analog type="input" name="36000"/>
			<function position="middle" type="DIV"><input name="" extensible="true"/><output name="42"/></function>
			<analog type="output" name="gMAC01.PcsPerHour"/>
		</row>
		<row>
			<empty/>
			<empty/>
			<empty/>
			<analog type="input" name="gMAC01.LastCycleTime"/>
			<function position="bottom" type="DIV"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
	<network label="" comment="MACHINE #2" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="glbMac02On"/>
			<line/>
			<line/>
			<coil type="open" name="gMAC02.LiveSignal"/>
		</row>
	</network>
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="gMAC02raw.Di.Alarm"/>
			<line/>
			<line/>
			<coil type="open" name="gMAC02.Alarm"/>
		</row>
	</network>
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="gMAC02raw.Di.CommitEnd"/>
			<line/>
			<line/>
			<coil type="open" name="gMAC02.CommitEnd"/>
		</row>
	</network>
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="gMAC02raw.Di.Manual"/>
			<contact type="open" name="gMAC02raw.Di.Run"/>
			<line/>
			<coil type="open" name="gMAC02.ManMode"/>
		</row>
	</network>
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="closed" name="gMAC02raw.Di.Manual"/>
			<contact type="open" name="gMAC02raw.Di.Run"/>
			<line/>
			<coil type="open" name="gMAC02.AutoMode"/>
		</row>
	</network>
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="closed" name="gMAC02raw.Di.Run"/>
			<line/>
			<line/>
			<coil type="open" name="gMAC02.Stop"/>
		</row>
	</network>
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="gMAC02raw.Di.Run"/>
			<line/>
			<line/>
			<coil type="open" name="gMAC02.Run"/>
		</row>
	</network>
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="gMAC02raw.Di.MoldChange"/>
			<line/>
			<line/>
			<coil type="open" name="gMAC02.MCH_on"/>
		</row>
	</network>
	<network label="" comment="" row="3" column="0" commented="0">
		<row>
			<empty/>
			<functionblock position="header" name="M2_NewCycle" type="TON"/>
			<empty/>
		</row>
		<row>
			<contact type="open" name="gMAC02raw.Di.NewCycleSignal"/>
			<functionblock position="top" type="TON"><input name="IN"/><output name="Q"/></functionblock>
			<analog type="output" name="gMAC02raw.Di.NewCycleTrigger"/>
		</row>
		<row>
			<analog type="input" name="T#2s"/>
			<functionblock position="bottom" type="TON"><input name="PT"/><output name="ET"/></functionblock>
			<empty/>
		</row>
	</network>
	<network label="" comment="Copy Last Actual Cycle Time to the last Cycle Time" row="2" column="0" commented="0">
		<row>
			<contact type="positive transition" name="gMAC02raw.Di.NewCycleTrigger"/>
			<function position="top" type="MOVE"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="gMAC02.ActualCycleTime"/>
			<function position="bottom" type="MOVE"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="gMAC02.LastCycleTime"/>
		</row>
	</network>
	<network label="" comment="" row="3" column="0" commented="0">
		<row>
			<contact type="positive transition" name="gMAC02raw.Di.NewCycleTrigger"/>
			<function position="top" type="ADD"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="gMac02LifeCounter"/>
			<function position="middle" type="ADD"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="gMac02LifeCounter"/>
		</row>
		<row>
			<analog type="input" name="1"/>
			<function position="bottom" type="ADD"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
	<network label="" comment="" row="2" column="0" commented="0">
		<row>
			<analog type="input" name="gMac02LifeCounter"/>
			<function position="top" type="ADD"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="gMAC02.LifeCycles"/>
		</row>
		<row>
			<analog type="input" name="gMac02CounterOffset"/>
			<function position="bottom" type="ADD"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
	<network label="" comment="" row="2" column="0" commented="0">
		<row>
			<contact type="positive transition" name="gMAC02raw.Di.NewCycleTrigger"/>
			<function position="top" type="MOVE"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="0"/>
			<function position="bottom" type="MOVE"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="gMAC02.ActualCycleTime"/>
		</row>
	</network>
	<network label="" comment="" row="2" column="0" commented="0">
		<row>
			<analog type="input" name="gMAC02.ActualCycleTime"/>
			<function position="top" type="LT"><input name="" extensible="true"/><output name="1"/></function>
			<contact type="positive transition" name="gPulse_100"/>
			<coil type="open" name="gCounter02"/>
		</row>
		<row>
			<analog type="input" name="3000"/>
			<function position="bottom" type="LT"><input name="" extensible="true"/></function>
			<empty/>
			<empty/>
		</row>
	</network>
	<network label="" comment="" row="3" column="0" commented="0">
		<row>
			<contact type="open" name="gMAC02.AutoMode"/>
			<contact type="open" name="gMAC02.Run"/>
			<contact type="open" name="gCounter02"/>
			<function position="top" type="ADD"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<analog type="input" name="1"/>
			<function position="middle" type="ADD"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="gMAC02.ActualCycleTime"/>
		</row>
		<row>
			<empty/>
			<empty/>
			<analog type="input" name="gMAC02.ActualCycleTime"/>
			<function position="bottom" type="ADD"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
	<network label="" comment="" row="3" column="0" commented="0">
		<row>
			<analog type="input" name="gMAC02.LastCycleTime"/>
			<function position="top" type="GT"><input name="" extensible="true"/><output name="1"/></function>
			<line/>
			<function position="top" type="DIV"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="0"/>
			<function position="bottom" type="GT"><input name="" extensible="true"/></function>
			<analog type="input" name="36000"/>
			<function position="middle" type="DIV"><input name="" extensible="true"/><output name="42"/></function>
			<analog type="output" name="gMAC02.PcsPerHour"/>
		</row>
		<row>
			<empty/>
			<empty/>
			<empty/>
			<analog type="input" name="gMAC02.LastCycleTime"/>
			<function position="bottom" type="DIV"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
	<network label="" comment="MACHINE #3" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="gPWL03_ok"/>
			<line/>
			<line/>
			<coil type="open" name="gMAC03.LiveSignal"/>
		</row>
	</network>
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="gMAC03raw.Di.Alarm"/>
			<line/>
			<line/>
			<coil type="open" name="gMAC03.Alarm"/>
		</row>
	</network>
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="gMAC03raw.Di.CommitEnd"/>
			<line/>
			<line/>
			<coil type="open" name="gMAC03.CommitEnd"/>
		</row>
	</network>
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="gMAC03raw.Di.Manual"/>
			<contact type="open" name="gMAC03raw.Di.Run"/>
			<line/>
			<coil type="open" name="gMAC03.ManMode"/>
		</row>
	</network>
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="closed" name="gMAC03raw.Di.Manual"/>
			<contact type="open" name="gMAC03raw.Di.Run"/>
			<line/>
			<coil type="open" name="gMAC03.AutoMode"/>
		</row>
	</network>
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="closed" name="gMAC03raw.Di.Run"/>
			<line/>
			<line/>
			<coil type="open" name="gMAC03.Stop"/>
		</row>
	</network>
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="gMAC03raw.Di.Run"/>
			<line/>
			<line/>
			<coil type="open" name="gMAC03.Run"/>
		</row>
	</network>
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="gMAC03raw.Di.MoldChange"/>
			<line/>
			<line/>
			<coil type="open" name="gMAC03.MCH_on"/>
		</row>
	</network>
	<network label="" comment="" row="3" column="0" commented="0">
		<row>
			<empty/>
			<functionblock position="header" name="M3_NewCycle" type="TON"/>
			<empty/>
		</row>
		<row>
			<contact type="open" name="gMAC03raw.Di.NewCycleSignal"/>
			<functionblock position="top" type="TON"><input name="IN"/><output name="Q"/></functionblock>
			<analog type="output" name="gMAC03raw.Di.NewCycleTrigger"/>
		</row>
		<row>
			<analog type="input" name="T#2s"/>
			<functionblock position="bottom" type="TON"><input name="PT"/><output name="ET"/></functionblock>
			<empty/>
		</row>
	</network>
	<network label="" comment="Copy Last Actual Cycle Time to the last Cycle Time" row="2" column="0" commented="0">
		<row>
			<contact type="positive transition" name="gMAC03raw.Di.NewCycleTrigger"/>
			<function position="top" type="MOVE"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="gMAC03.ActualCycleTime"/>
			<function position="bottom" type="MOVE"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="gMAC03.LastCycleTime"/>
		</row>
	</network>
	<network label="" comment="" row="3" column="0" commented="0">
		<row>
			<contact type="positive transition" name="gMAC03raw.Di.NewCycleTrigger"/>
			<function position="top" type="ADD"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="gMac03LifeCounter"/>
			<function position="middle" type="ADD"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="gMac03LifeCounter"/>
		</row>
		<row>
			<analog type="input" name="1"/>
			<function position="bottom" type="ADD"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
	<network label="" comment="" row="2" column="0" commented="0">
		<row>
			<analog type="input" name="gMac03LifeCounter"/>
			<function position="top" type="ADD"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="gMAC03.LifeCycles"/>
		</row>
		<row>
			<analog type="input" name="gMac03CounterOffset"/>
			<function position="bottom" type="ADD"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
	<network label="" comment="" row="2" column="0" commented="0">
		<row>
			<contact type="positive transition" name="gMAC03raw.Di.NewCycleTrigger"/>
			<function position="top" type="MOVE"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="0"/>
			<function position="bottom" type="MOVE"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="gMAC03.ActualCycleTime"/>
		</row>
	</network>
	<network label="" comment="" row="2" column="0" commented="0">
		<row>
			<analog type="input" name="gMAC03.ActualCycleTime"/>
			<function position="top" type="LT"><input name="" extensible="true"/><output name="1"/></function>
			<contact type="positive transition" name="gPulse_100"/>
			<coil type="open" name="gCounter03"/>
		</row>
		<row>
			<analog type="input" name="3000"/>
			<function position="bottom" type="LT"><input name="" extensible="true"/></function>
			<empty/>
			<empty/>
		</row>
	</network>
	<network label="" comment="" row="3" column="0" commented="0">
		<row>
			<contact type="open" name="gMAC03.AutoMode"/>
			<contact type="open" name="gMAC03.Run"/>
			<contact type="open" name="gCounter03"/>
			<function position="top" type="ADD"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<analog type="input" name="1"/>
			<function position="middle" type="ADD"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="gMAC03.ActualCycleTime"/>
		</row>
		<row>
			<empty/>
			<empty/>
			<analog type="input" name="gMAC03.ActualCycleTime"/>
			<function position="bottom" type="ADD"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
	<network label="" comment="" row="3" column="0" commented="0">
		<row>
			<analog type="input" name="gMAC03.LastCycleTime"/>
			<function position="top" type="GT"><input name="" extensible="true"/><output name="1"/></function>
			<line/>
			<function position="top" type="DIV"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="0"/>
			<function position="bottom" type="GT"><input name="" extensible="true"/></function>
			<analog type="input" name="36000"/>
			<function position="middle" type="DIV"><input name="" extensible="true"/><output name="42"/></function>
			<analog type="output" name="gMAC03.PcsPerHour"/>
		</row>
		<row>
			<empty/>
			<empty/>
			<empty/>
			<analog type="input" name="gMAC03.LastCycleTime"/>
			<function position="bottom" type="DIV"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
</networks>
END_PROGRAM











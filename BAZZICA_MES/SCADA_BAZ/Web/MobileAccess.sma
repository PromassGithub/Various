<Configuration xmlns="http://schemas.datacontract.org/2004/07/MobileAccessConfiguration" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
    <GlobalSettings>
        <AckedColor xmlns:a="http://schemas.datacontract.org/2004/07/System.Windows.Media">
            <a:A>255</a:A>
            <a:B>68</a:B>
            <a:G>128</a:G>
            <a:R>0</a:R>
            <a:ScA>1</a:ScA>
            <a:ScB>0.05780543</a:ScB>
            <a:ScG>0.2158605</a:ScG>
            <a:ScR>0</a:ScR>
        </AckedColor>
        <AckedColorHexCode>#008044</AckedColorHexCode>
        <ActiveColor xmlns:a="http://schemas.datacontract.org/2004/07/System.Windows.Media">
            <a:A>255</a:A>
            <a:B>0</a:B>
            <a:G>0</a:G>
            <a:R>255</a:R>
            <a:ScA>1</a:ScA>
            <a:ScB>0</a:ScB>
            <a:ScG>0</a:ScG>
            <a:ScR>1</a:ScR>
        </ActiveColor>
        <ActiveColorHexCode>#FF0000</ActiveColorHexCode>
        <AlarmAvailableColumns>
            <AlarmColumn>
                <Label>Ack Required</Label>
                <Name>ackReq</Name>
            </AlarmColumn>
            <AlarmColumn>
                <Label>Ack Time</Label>
                <Name>ackTime</Name>
            </AlarmColumn>
            <AlarmColumn>
                <Label>Comment</Label>
                <Name>comment</Name>
            </AlarmColumn>
            <AlarmColumn>
                <Label>Event Time</Label>
                <Name>eventTime</Name>
            </AlarmColumn>
            <AlarmColumn>
                <Label>Group</Label>
                <Name>group</Name>
            </AlarmColumn>
            <AlarmColumn>
                <Label>Norm Time</Label>
                <Name>stopTime</Name>
            </AlarmColumn>
            <AlarmColumn>
                <Label>Previous</Label>
                <Name>previousValue</Name>
            </AlarmColumn>
            <AlarmColumn>
                <Label>Priority</Label>
                <Name>priority</Name>
            </AlarmColumn>
            <AlarmColumn>
                <Label>Selection</Label>
                <Name>selection</Name>
            </AlarmColumn>
            <AlarmColumn>
                <Label>State</Label>
                <Name>state</Name>
            </AlarmColumn>
            <AlarmColumn>
                <Label>Station</Label>
                <Name>station</Name>
            </AlarmColumn>
            <AlarmColumn>
                <Label>Type</Label>
                <Name>type</Name>
            </AlarmColumn>
            <AlarmColumn>
                <Label>User</Label>
                <Name>user</Name>
            </AlarmColumn>
            <AlarmColumn>
                <Label>Value</Label>
                <Name>value</Name>
            </AlarmColumn>
        </AlarmAvailableColumns>
        <AlarmColumns>
            <AlarmColumn>
                <Label>Activation Time</Label>
                <Name>startTime</Name>
            </AlarmColumn>
            <AlarmColumn>
                <Label>Tag Name</Label>
                <Name>tagName</Name>
            </AlarmColumn>
            <AlarmColumn>
                <Label>Message</Label>
                <Name>message</Name>
            </AlarmColumn>
        </AlarmColumns>
        <AlarmUpdateRate>1000</AlarmUpdateRate>
        <BgColor xmlns:a="http://schemas.datacontract.org/2004/07/System.Windows.Media">
            <a:A>255</a:A>
            <a:B>255</a:B>
            <a:G>255</a:G>
            <a:R>255</a:R>
            <a:ScA>1</a:ScA>
            <a:ScB>1</a:ScB>
            <a:ScG>1</a:ScG>
            <a:ScR>1</a:ScR>
        </BgColor>
        <CustomWidgets />
        <Enable>false</Enable>
        <EnableCGI>false</EnableCGI>
        <EnableScreenCache>true</EnableScreenCache>
        <EnableViewPortAlign>true</EnableViewPortAlign>
        <FirstEventsTimeout>100</FirstEventsTimeout>
        <LogError>true</LogError>
        <LogInformation>false</LogInformation>
        <LogLevel>1</LogLevel>
        <LogRuntimeCommunication>true</LogRuntimeCommunication>
        <LogScreen>true</LogScreen>
        <LogTrace>false</LogTrace>
        <LogWarning>false</LogWarning>
        <LogWebServices>true</LogWebServices>
        <NormColor xmlns:a="http://schemas.datacontract.org/2004/07/System.Windows.Media">
            <a:A>255</a:A>
            <a:B>255</a:B>
            <a:G>0</a:G>
            <a:R>0</a:R>
            <a:ScA>1</a:ScA>
            <a:ScB>1</a:ScB>
            <a:ScG>0</a:ScG>
            <a:ScR>0</a:ScR>
        </NormColor>
        <NormColorHexCode>#0000FF</NormColorHexCode>
        <ProcessValuesUpdateAfterCommandCount>5</ProcessValuesUpdateAfterCommandCount>
        <ProcessValuesUpdateRate>1000</ProcessValuesUpdateRate>
        <ProcessValuesUpdateRateAfterCommand>100</ProcessValuesUpdateRateAfterCommand>
        <ScreenCacheSize>32</ScreenCacheSize>
        <SessionExpiration>300</SessionExpiration>
        <ShowStandbyStart>500</ShowStandbyStart>
        <ShowStandbyTimeout>10000</ShowStandbyTimeout>
        <SyncDestroyView>false</SyncDestroyView>
        <TrendDuration>60</TrendDuration>
        <TrendUpdateRate>1000</TrendUpdateRate>
        <UseGroupColor>false</UseGroupColor>
        <VKCustomPath />
        <VKDefaultType>1</VKDefaultType>
        <VKEnable>true</VKEnable>
        <VKEnableMinMaxFields>true</VKEnableMinMaxFields>
        <VKEnableMultiLine>true</VKEnableMultiLine>
        <VKHint />
        <VKShowHint>true</VKShowHint>
        <Version>1</Version>
        <ViewPortAlignMode>3</ViewPortAlignMode>
        <ZoomMode>1</ZoomMode>
    </GlobalSettings>
    <OpenID>
        <ClientId i:nil="true" />
        <Issuer i:nil="true" />
        <TokenAlgorithm i:nil="true" />
        <TokenSecret i:nil="true" />
        <UserNameClaim i:nil="true" />
    </OpenID>
    <RootArea>
        <A>A</A>
        <AccessLevel>0</AccessLevel>
        <Alarm>
            <GroupFilter />
            <OnlyProcessValues>false</OnlyProcessValues>
            <PriorityFrom>0</PriorityFrom>
            <PriorityTo>255</PriorityTo>
            <SelectionFilter />
        </Alarm>
        <Children />
        <IndexEntries />
        <Label>Main</Label>
        <Name>Main</Name>
        <ProcessValues />
        <Screens />
        <WidgetPixelSize>130</WidgetPixelSize>
        <WidgetSize>Medium</WidgetSize>
        <WriteAccessLevel>0</WriteAccessLevel>
    </RootArea>
</Configuration>

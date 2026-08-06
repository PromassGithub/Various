<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:bdg="http://www.br-automation.com/iat2015/binding/engineering/v2"
                xmlns:be="http://www.br-automation.com/iat2015/bindingListEmbedded/engineering/v2"
                xmlns:blt="http://www.br-automation.com/iat2015/bindingListTypes/engineering/v2"
                xmlns:br="http://www.br-automation.com/iat2015/bindingList/runtime/v2"
                xmlns:wdg="http://www.br-automation.com/iat2014/widget"
                xmlns="http://www.br-automation.com/iat2014/binding/runtime/v1"
                exclude-result-prefixes="bdg be blt wdg">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

  <!-- File which contains all expression instances where we can look up the contentRefId for a given expression id -->
  <xsl:param name="expressionContentMappingFile" select="'./ExpressionContentMapping.xml'"/>
  <xsl:param name="widgetRoot">../../BRVisu/</xsl:param>
  <xsl:param name="elpathdelimiter">/</xsl:param>
  
  <xsl:variable name="expressions" select="document($expressionContentMappingFile)//Mappings/*"/>
  
  <xsl:template match="bdg:BindingsSet">
    <BindingDefinition>
      <xsl:apply-templates />
    </BindingDefinition>
  </xsl:template>

  <!-- Move each binding into content, visu, session or server scope -->
  <xsl:template match="bdg:Bindings/bdg:Binding">
    <xsl:choose>
      <!-- content scope -->
      <xsl:when test="bdg:Target/@xsi:type='brease' or bdg:Source/@xsi:type='brease' or bdg:Target/@xsi:type='expression' or bdg:Source/@xsi:type='expression'">
        <xsl:call-template name="contentBinding" />
      </xsl:when>
      <xsl:when test="bdg:Source/bdg:Selector/@xsi:type='brease'">
        <xsl:call-template name="contentBinding" />
      </xsl:when>
      <xsl:when test="bdg:Source/be:List/@xsi:type='be:brease'">
        <xsl:call-template name="contentBinding" />
      </xsl:when>
      <!-- session scopes: A&P 545630: Regression: Textkeys mit Snippets werden erst nach einem Refresh der Visualisierung korrekt angezeigt-->
      <xsl:when test="bdg:Source/@xsi:type='snippet' or bdg:Target/@xsi:type='snippet'">
        <xsl:call-template name="sessionBinding" />
      </xsl:when>
      <!-- visualization scopes -->
      <xsl:when test="bdg:Source/@xsi:type='session' or bdg:Target/@xsi:type='session' or bdg:Source/@xsi:type='text' or bdg:Target/@xsi:type='text'">
        <xsl:call-template name="visuBinding" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="serverBinding" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="bdg:Binding/bdg:Target">
    <xsl:call-template name="createSourceOrTarget" />
  </xsl:template>

  <xsl:template match="bdg:Binding/bdg:Source[@xsi:type != 'listElement']">
    <xsl:call-template name="createSourceOrTarget" />
  </xsl:template>

  <!-- list binding (dynamic binding) -->
  <xsl:template match="bdg:Source[@xsi:type = 'listElement']">
    <xsl:element name="Source">
      <!-- copy all attributes + mode from binding-element (A&P 587115: Listbinding oneWayToSource is not working with session variable as target) -->
      <xsl:copy-of select="../@mode | @*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="bdg:Selector">
    <xsl:call-template name="createSourceOrTarget" />
  </xsl:template>

  <!-- embedded list -->
  <xsl:template match="be:List">
    <xsl:element name="br:List">
      <xsl:attribute name="xsi:type">
        <xsl:choose>
          <xsl:when test="substring-after(@xsi:type, ':')='session'">
            <xsl:value-of select="'br:variable'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat('br:', substring-after(@xsi:type, ':'))"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="id">
        <xsl:call-template name="getIdFromTarget" />
      </xsl:attribute>
      <!-- copy all the elements -->
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template name="getIdFromTarget">
    <xsl:choose>
      <xsl:when test="../../bdg:Target/@xsi:type = 'brease'">
        <xsl:value-of select="concat(../../bdg:Target/@xsi:type, '*', ../../bdg:Target/@contentRefId, '_', ../../bdg:Target/@widgetRefId, '*', ../../bdg:Target/@attribute)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat(../../bdg:Target/@xsi:type, '*', ../../bdg:Target/@refId, '*', ../../bdg:Target/@attribute)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--Embedded list elements -->
  <xsl:template match="blt:Element | blt:Default">
    <xsl:element name="br:{local-name()}">
      <xsl:for-each select="@*">
        <xsl:choose>
          <xsl:when test="name()='widgetRefId'">
            <xsl:attribute name="refId">
              <xsl:value-of select="."/>
            </xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="{name()}">
              <xsl:value-of select="."/>
            </xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
      <!--for opcua and session var, attributes are defined in list for all elements -->
      <xsl:copy-of select="../@attribute"/>
      <xsl:copy-of select="../@serverAlias"/>
      <xsl:copy-of select="../@nameSpaceAlias"/>
      <xsl:copy-of select="../@samplingRate"/>
    </xsl:element>
  </xsl:template>

  <!-- external list -->
  <xsl:template match="bdg:List">
    <List refId="{@refId}" />
  </xsl:template>

  <!-- handle content scope binding -->
  <xsl:template name="contentBinding">
    <xsl:variable name="contentId">
      <xsl:call-template name="getScopeId"/>
    </xsl:variable>
    <Content id="{$contentId}">
      <Binding mode="{@mode}">
        <xsl:apply-templates/>
      </Binding>
    </Content>
    <xsl:apply-templates select="." mode="dataSource"/>
  </xsl:template>

  <!-- get contentId of binding  -->
  <xsl:template name="getScopeId">
    <xsl:choose>
      <xsl:when test="bdg:Target/@xsi:type='brease'">
        <xsl:value-of select="bdg:Target/@contentRefId"></xsl:value-of>
      </xsl:when>
      <xsl:when test="bdg:Source/@xsi:type='brease'">
        <xsl:value-of select="bdg:Source/@contentRefId"></xsl:value-of>
      </xsl:when>
      <xsl:when test="bdg:Source/bdg:Selector/@xsi:type='brease'">
        <xsl:value-of select="bdg:Source/bdg:Selector/@contentRefId"></xsl:value-of>
      </xsl:when>
      <xsl:when test="bdg:Source/be:List/@xsi:type='be:brease'">
        <xsl:value-of select="bdg:Source/be:List/@contentRefId"></xsl:value-of>
      </xsl:when>
      <xsl:when test="bdg:Target/@xsi:type='expression'">
        <xsl:call-template name="getExpressionScopeId">
          <xsl:with-param name="target" select="bdg:Target" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="bdg:Source/@xsi:type='expression'">
        <xsl:call-template name="getExpressionScopeId">
          <xsl:with-param name="target" select="bdg:Source" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- remove with session scope -->
        <xsl:value-of select="'_session'"></xsl:value-of>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- get contentId of expression: look up id in loaded expressions -->
  <xsl:template name="getExpressionScopeId">
    <xsl:param name="target"/>
    <xsl:choose>
      <xsl:when test="$expressions[@expressionRefId=$target/@refId]">
        <xsl:value-of select="$expressions[@expressionRefId=$target/@refId]/@contentRefId"></xsl:value-of>
      </xsl:when>
      <xsl:when test="$target/@contentRefId">
        <xsl:message terminate="no">
          Deprecated scope definition for expression <xsl:copy-of select="$target"/>. Just use refId="expressionId"
        </xsl:message>
        <xsl:value-of select="$target/@contentRefId"></xsl:value-of>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message terminate="yes">
          Referenced expression is unavailable: <xsl:copy-of select="$target"/>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- handle session bindings -->
  <xsl:template name="sessionBinding">
    <Session>
      <Binding mode="{@mode}">
        <xsl:apply-templates/>
      </Binding>
    </Session>
  </xsl:template>

  <!-- handle visualization bindings -->
  <xsl:template name="visuBinding">
    <Visualization>
      <Binding mode="{@mode}">
        <xsl:apply-templates/>
      </Binding>
    </Visualization>
  </xsl:template>

  <!--handle server bindings -->
  <xsl:template name="serverBinding">
    <Server>
      <Binding mode="{@mode}">
        <xsl:apply-templates/>
      </Binding>
    </Server>
  </xsl:template>

  <!-- handle source and target attributes of a binding -->
  <xsl:template name="createSourceOrTarget">
    <xsl:element name="{local-name()}">
      <xsl:for-each select="@*">
        <xsl:choose>
          <xsl:when test="name()='xsi:type' and (.='server' or .='session')">
            <xsl:attribute name="{name()}">
              <xsl:value-of select="'variable'"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:when test="name()='contentRefId'">
          </xsl:when>
          <xsl:when test="name()='widgetRefId'">
            <xsl:attribute name="refId">
              <xsl:value-of select="."/>
            </xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="{name()}">
              <xsl:value-of select="."/>
            </xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>


  <!-- (START) dataSource bindings aka maplan bindings: generate additonal bindings query, count, limit, offset, notification and slotId -->
  <xsl:template match="bdg:Selectors/bdg:SelectorQuery/bdg:Target" mode="dataSource">
    <Content id="{@contentRefId}">
      <Binding mode="oneWay">
        <Source xsi:type="brease" refId="{@widgetRefId}" attribute="{@attribute}"/>
        <Target xsi:type="dataSource" refId="{../../../@refId}" attribute="query"/>
      </Binding>
    </Content>
  </xsl:template>

  <xsl:template match="bdg:Selectors/bdg:SelectorCount/bdg:Target" mode="dataSource">
    <Content id="{@contentRefId}">
      <Binding mode="oneWay">
        <Source xsi:type="dataSource" refId="{../../../@refId}" attribute="count"/>
        <Target xsi:type="brease" refId="{@widgetRefId}" attribute="{@attribute}"/>
      </Binding>
    </Content>
  </xsl:template>

  <xsl:template match="bdg:Selectors/bdg:SelectorLimit/bdg:Target" mode="dataSource">
    <Content id="{@contentRefId}">
      <Binding mode="oneWay">
        <Source xsi:type="brease" refId="{@widgetRefId}" attribute="{@attribute}"/>
        <Target xsi:type="dataSource" refId="{../../../@refId}" attribute="limit"/>
      </Binding>
    </Content>
  </xsl:template>

  <xsl:template match="bdg:Selectors/bdg:SelectorOffset/bdg:Target" mode="dataSource">
    <Content id="{@contentRefId}">
      <Binding mode="oneWay">
        <Source xsi:type="brease" refId="{@widgetRefId}" attribute="{@attribute}"/>
        <Target xsi:type="dataSource" refId="{../../../@refId}" attribute="offset"/>
      </Binding>
    </Content>
  </xsl:template>

  <xsl:template match="bdg:Selectors/bdg:SelectorNotification/bdg:Target" mode="dataSource">
    <Content id="{@contentRefId}">
      <Binding mode="oneWay">
        <Source xsi:type="dataSource" refId="{../../../@refId}" attribute="notification"/>
        <Target xsi:type="brease" refId="{@widgetRefId}" attribute="{@attribute}"/>
      </Binding>
    </Content>
  </xsl:template>
  
  <xsl:template match="bdg:Binding/bdg:Source[@xsi:type = 'dataSource']" mode="dataSource">
    <xsl:apply-templates mode="dataSource" />
    <Visualization>
      <Binding mode="oneWay">
        <Source xsi:type="variable" refId="::SYSTEM:clientInfo.slotId" attribute="value"/>
        <Target xsi:type="dataSource" refId="{@refId}" attribute="slotid"/>
      </Binding>
    </Visualization>
  </xsl:template>
  <!-- (END) dataSource bindings aka maplan bindings -->
 
  <!-- (START) complex binding: generate all simple bindings for a single complexBinding by using binding template from widget -->
  <xsl:template match="bdg:Bindings/bdg:ComplexBinding">
    <!--only target brease allowed so we can always move bindings into content-->
    <Content id="{bdg:TargetRoot/@contentRefId}">
      <!--get path of .widget file by using param and widgetType attribute -->
      <xsl:variable name="widgetTypePath">
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text" select="@widgetType" />
          <xsl:with-param name="replace" select="'.'" />
          <xsl:with-param name="by" select="$elpathdelimiter" />
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="file">
        <xsl:call-template name="getWidgetFile">
          <xsl:with-param name="widgetType" select="$widgetTypePath"></xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <!-- load template and match each binding we have to create -->
      <xsl:variable name="templateId" select="@templateId"/>
      <xsl:variable name="bindingtemplate" select="document($file)//wdg:BindingTemplate[@id=$templateId]" />
      <xsl:if test="not($bindingtemplate/@id)">
        <xsl:message terminate="yes">
          Error: Defined  Template not found; File: <xsl:value-of select="$file" />; Widget: <xsl:value-of select="$widgetTypePath" />; Template: <xsl:value-of select="$templateId" />
          <xsl:copy-of select="$bindingtemplate"/>
        </xsl:message>
      </xsl:if>
      <xsl:apply-templates select="$bindingtemplate/wdg:BindingMember">
        <xsl:with-param name="binding" select="."/>
      </xsl:apply-templates>
    </Content>
  </xsl:template>

  <!-- create single binding (context=template)-->
  <xsl:template match="wdg:BindingMember">
    <xsl:param name="binding" />
    <Binding mode="{@mode}">
      <xsl:apply-templates>
        <xsl:with-param name="binding" select="$binding"/>
      </xsl:apply-templates>
    </Binding>
  </xsl:template>
  
  <!--create single binding source (context=template) -->
  <xsl:template match="wdg:SourceMember">
    <xsl:param name="binding" />
    <xsl:element name="Source">
      <xsl:apply-templates select="$binding/bdg:SourceRoot" >
        <xsl:with-param name="sourceTemplate" select="."/>
      </xsl:apply-templates>
    </xsl:element>
  </xsl:template>

  <!--create single binding brease target (context=template) -->
  <xsl:template match="wdg:TargetMember">
    <xsl:param name="binding" />
    <Target xsi:type="brease" refId="{$binding/bdg:TargetRoot/@widgetRefId}" attribute="{@attribute}"/>
  </xsl:template>

  <!--create simple source attributes (context=binding) -->
  <xsl:template match="bdg:SourceRoot[@xsi:type != 'listComplexElement']">
    <xsl:param name="sourceTemplate" />
    <xsl:attribute name="xsi:type">opcUa</xsl:attribute>
    <xsl:attribute name="refId">
      <xsl:call-template name="string-replace-all">
        <xsl:with-param name="text" select="$sourceTemplate/@refId" />
        <xsl:with-param name="replace" select="'$Source'" />
        <xsl:with-param name="by" select="@refId" />
      </xsl:call-template>
    </xsl:attribute>
    <xsl:attribute name="attribute">
      <xsl:value-of select="$sourceTemplate/@attribute" />
    </xsl:attribute>
    <!--samplingRage, serverAlias, namepsaceAlias are currently not supported by schema-->
  </xsl:template>

  <!--create listElement binding (context=binding) -->
  <xsl:template match="bdg:SourceRoot[@xsi:type = 'listComplexElement']">
    <xsl:param name="sourceTemplate" />
    <xsl:attribute name="mode">
      <xsl:value-of select="$sourceTemplate/../@mode"/>
    </xsl:attribute>
    <xsl:attribute name="xsi:type">listElement</xsl:attribute>
    <xsl:apply-templates select="bdg:Selector" />
    <xsl:apply-templates select="bdg:List" mode="complex" >
      <xsl:with-param name="sourceTemplate" select="$sourceTemplate"/>
    </xsl:apply-templates>
  </xsl:template>

  <!--create embedded list (context=binding) -->
  <xsl:template match="bdg:List" mode="complex">
    <xsl:param name="sourceTemplate" />
    <br:List xsi:type="br:opcUa" id="{concat('brease*', ../../bdg:TargetRoot/@contentRefId, '_', ../../bdg:TargetRoot/@widgetRefId, '*', $sourceTemplate/../wdg:TargetMember/@attribute)}">
      <xsl:apply-templates mode="complexList">
        <xsl:with-param name="sourceTemplate" select="$sourceTemplate"/>
      </xsl:apply-templates>
    </br:List>
  </xsl:template>

  <!--create embedded list elements (context=binding) -->
  <xsl:template match="bdg:Element | bdg:Default" mode="complexList">
    <xsl:param name="sourceTemplate" />
    <xsl:element name="br:{local-name()}">
      <xsl:if test="@index">
        <xsl:attribute name="index">
          <xsl:value-of select="@index"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:attribute name="refId">
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text" select="$sourceTemplate/@refId" />
          <xsl:with-param name="replace" select="'$Source'" />
          <xsl:with-param name="by" select="@refId" />
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="attribute">
        <xsl:value-of select="$sourceTemplate/@attribute" />
      </xsl:attribute>
      <!--samplingRate, serverAlias, namespsaceAlias are currently not supported by schema-->
    </xsl:element>
  </xsl:template>

  <!--Template function to get a widgte file by type and root directory -->
  <xsl:template name="getWidgetFile">
    <xsl:param name="widgetType"></xsl:param>
    <xsl:variable name="eltype">
      <xsl:call-template name="getFileName">
        <xsl:with-param name="elname" select="$widgetType"></xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="concat($widgetRoot,$widgetType,$elpathdelimiter,'meta',$elpathdelimiter,$eltype,'.widget')"></xsl:value-of>
  </xsl:template>

  <!--Template function to get the Widget name out of the namespace-->
  <xsl:template name="getFileName">
    <xsl:param name="elname"></xsl:param>
    <xsl:choose>
      <xsl:when test="contains($elname,'/')">
        <xsl:call-template name="getFileName">
          <xsl:with-param name="elname" select="substring-after($elname,'/')"></xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$elname"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="string-replace-all">
    <xsl:param name="text" />
    <xsl:param name="replace" />
    <xsl:param name="by" />
    <xsl:choose>
      <xsl:when test="contains($text, $replace)">
        <xsl:value-of select="substring-before($text,$replace)" />
        <xsl:value-of select="$by" />
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text"
          select="substring-after($text,$replace)" />
          <xsl:with-param name="replace" select="$replace" />
          <xsl:with-param name="by" select="$by" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- (END complex binding) -->
</xsl:stylesheet>
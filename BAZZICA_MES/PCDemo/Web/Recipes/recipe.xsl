<xsl:stylesheet xmlns:xsl="http://www.w3.org/TR/WD-xsl">
  <xsl:template match="/">
    <HTML>
      <BODY>
	<table border="4" width="100%">
	<tr>
	    <td width="40%"><b>Tagname</b></td>
	    <td width="60%"><b>Value</b></td>
	</tr>
	</table>	
	<table border="1" width="100%">
	<tr>
	    <xsl:apply-templates />
	</tr>
	</table>	
      </BODY>
    </HTML>
  </xsl:template>

  <xsl:template match="TAGLIST">
      <xsl:for-each select="TAG">
      <tr>
        <xsl:apply-templates />
      </tr>
      </xsl:for-each>
  </xsl:template>

  <xsl:template match="NAME">
      <td width="40%">
    <xsl:apply-templates />
      </td>
  </xsl:template>  

  <xsl:template match="VALUE">
      <td width="60%">
    <xsl:apply-templates />
      </td>
  </xsl:template>  

  <xsl:template match="text()"><xsl:value-of /></xsl:template>
  
</xsl:stylesheet>
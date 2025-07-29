<?xml version="1.0"?>
<!-- édité avec XMLSpy v2017 (x64) (http://www.altova.com) par APAVE (Apave SA) -->
<!-- edited with XMLSpy v2016 rel. 2 sp1 (x64) (http://www.altova.com) by MAINTA (SA APAVE) -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mainta="http://www.apave.com/france/web/loc/TR/WD-mainta" xmlns:xslc="http://xslcomponents.org/TR/WD-xslc" version="1.0" exclude-result-prefixes="mainta">
	<xsl:import href="..\..\xslc.xsl"/>
	<xsl:import href="..\..\Treeview.xsl"/>
	<xsl:import href="..\..\Common.xsl"/>
	<xsl:import href="..\..\mainta.xsl"/>
	<xsl:import href="..\..\perscreen.xsl"/>
	<xsl:import href="..\..\mainta_templates.xsl"/>
	<xsl:import href="..\..\maintatools.xsl"/>
	<xsl:template match="/">
		<xsl:apply-templates select="document"/>
	</xsl:template>
	<xsl:template match="document">
		<xsl:choose>
			<xsl:when test="/document/Params/EMBEDDED='YES'">
				<script language="javascript"><![CDATA[DBBatchTableObj.ROWs[']]><xsl:value-of select="/document/BT/ID_NUMBT"/><![CDATA['] = ]]><xsl:call-template name="mainta:XMLtoJSON">
						<xsl:with-param name="node" select="/document/BT"/>
					</xsl:call-template><![CDATA[;]]></script>
				<div id="{generate-id()}" class="subrowcontent subrow" aria-multiselectable="true" role="tablist">
					<xsl:apply-templates select="activepage"/>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="mainta:Page">
					<xsl:with-param name="Title">
						<xsl:value-of select="/document/Locales/SaisieE39"/>
					</xsl:with-param>
					<xsl:with-param name="DisplayVolet">1</xsl:with-param>
					<xsl:with-param name="WantCompletion">1</xsl:with-param>
					<xsl:with-param name="DisplayAlarm">1</xsl:with-param>
					<xsl:with-param name="Head">
						<xsl:call-template name="mainta:nocache"/>
						<script language="javascript" src="{$XMLC_Portal}md5.js"/>
						<script language="javascript" src="{/document/Aliases/MOS_XML}XLookup.js"/>
						<script language="javascript" src="{$JSlibsPath}E39-v1.0.js"/>
						<script language="javascript"><![CDATA[var submitted = false;
var alarmfieldsvisible = '';
function onExit()
{
  if (!submitted){
    if (confirm("]]><xsl:value-of select="/document/Locales/ExitMessage"/><![CDATA[")){return true;} else {return false;}}
  else
  return true;
}

]]></script>
						<script language="javascript" src="{$JSlibsPath}Adresses.js?V={$JSVersion}"/>
						<script language="javascript">function initLocales() {	<xsl:for-each select="/document/Locales/*">
								<xsl:choose>
									<xsl:when test="substring(name(),1,3) = 'MOS'">Locales.<xsl:value-of select="name()"/> = "<xsl:value-of select="."/>"; </xsl:when>
								</xsl:choose>
							</xsl:for-each>}initLocales();				    </script>
						<xsl:call-template name="mainta:FileHeader"/>
						<script language="javascript" src="{$JSlibsPath}Adresses.js?V={$JSVersion}"/>
						<script language="javascript"><![CDATA[var srcMode =']]><xsl:value-of select="/document/Params/E39ACTION"/><![CDATA[';
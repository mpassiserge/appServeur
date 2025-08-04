<xsl:template name="mainta:field">
	<xsl:param name="type"/>
	<xsl:param name="locale">no</xsl:param>
	<xsl:param name="nom"/>
	<xsl:param name="src"/>
	<xsl:param name="caption"/>
	<xsl:param name="inheritance"/>
	<xsl:param name="mode"/>
	<xsl:param name="title"/>
	<xsl:param name="table"/>
	<xsl:param name="partial"/>
	<xsl:param name="radiovalue"/>
	<xsl:param name="nolink">false</xsl:param>
	<xsl:param name="relativepath">no</xsl:param>
	<xsl:param name="relativehref">yes</xsl:param>
	<xsl:param name="xslCursor"/>
	<xsl:param name="disabled">yes</xsl:param>
	<xsl:param name="style"/>
	<xsl:param name="id">
		<xsl:value-of select="$nom"/>
	</xsl:param>
	<xsl:param name="labelfor"/>
	<xsl:param name="fieldmob">no</xsl:param>
	
	<!-- Paramètres ajoutés pour la gestion du blur et autres fonctionnalités -->
	<xsl:param name="addVerifOnBlur">no</xsl:param>
	<xsl:param name="overrideVerifOnBlur"/>
	<xsl:param name="controlform"/>
	<xsl:param name="class"/>
	<xsl:param name="onchange"/>
	<xsl:param name="TYP_"/>
	<xsl:param name="SRC_"/>
	<xsl:param name="INH_"/>
	<xsl:param name="INR_"/>
	<xsl:param name="SA_"/>
	<xsl:param name="FMODE_"/>
	<xsl:param name="ACS_"/>
	<xsl:param name="valdef"/>
	<xsl:param name="INCOOKIES_"/>
	<xsl:param name="CTL_"/>
	<xsl:param name="PictosMainta"/>
	
	<!-- Définition de la variable jsonblur -->
	<xsl:variable name="jsonblur">
		<xsl:if test="$addVerifOnBlur = 'yes'">
			<xsl:choose>
				<xsl:when test="$overrideVerifOnBlur != ''">
					<xsl:value-of select="$overrideVerifOnBlur"/>
				</xsl:when>
				<xsl:otherwise>MOS_VerifOnBlur("<xsl:value-of select="$id"/>","<xsl:value-of select="$controlform"/>","<xsl:value-of select="$class"/>","<xsl:value-of select="$caption"/>");</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:variable>
	
	<xsl:variable name="absolutebaseref">
		<xsl:choose>
			<xsl:when test="$relativehref = 'no'">
				<xsl:choose>
					<xsl:when test="/document/Params/GLOBAL_WWW_URL != ''">
						<xsl:value-of select="/document/Params/GLOBAL_WWW_URL"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="/document/XMLC_Params/XMLC_HTTPS = '1'">https://</xsl:when>
							<xsl:otherwise>http://</xsl:otherwise>
						</xsl:choose>
						<xsl:value-of select="/document/XMLC_Params/XMLC_Host"/>
						<xsl:value-of select="/document/XMLC_Params/XMLC_ScriptName"/>/</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="absolutebaseref2">
		<xsl:choose>
			<xsl:when test="$relativehref = 'no'">
				<xsl:choose>
					<xsl:when test="/document/Params/GLOBAL_PORTAL_URL != ''">
						<xsl:value-of select="/document/Params/GLOBAL_PORTAL_URL"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="/document/XMLC_Params/XMLC_HTTPS = '1'">https://</xsl:when>
							<xsl:otherwise>http://</xsl:otherwise>
						</xsl:choose>
						<xsl:value-of select="/document/XMLC_Params/XMLC_Host"/>
						<xsl:value-of select="/document/XMLC_Params/XMLC_ScriptName"/>/</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="valeur">
		<xsl:choose>
			<xsl:when test="$relativepath = 'yes'">
				<xsl:variable name="tab" select="$xslCursor"/>
				<xsl:choose>
					<xsl:when test="$src = '' or not($src)">
						<xsl:value-of select="$tab/*[name() = $nom]/text()"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$tab/*[name() = $src]/*[name() = $nom]/text()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$src = '' or $src = $table or not($src)">
				<xsl:value-of select="/document/*[name() = $table]/*[name() = $nom]/text()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/document/*[name() = $table]/*[name() = $src]/*[name() = $nom]/text()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:call-template name="mainta:overprinting-text">
		<xsl:with-param name="fieldname">
			<xsl:value-of select="$nom"/>
		</xsl:with-param>
		<xsl:with-param name="fieldvalue">
			<xsl:value-of select="$valeur"/>
		</xsl:with-param>
		<xsl:with-param name="id">
			<xsl:value-of select="$id"/>
		</xsl:with-param>
		<xsl:with-param name="fieldonly">yes</xsl:with-param>
		<xsl:with-param name="fieldmob">
			<xsl:value-of select="$fieldmob"/>
		</xsl:with-param>
		<xsl:with-param name="content">
			<xsl:if test="false">
				<xsl:value-of select="/document/Locales/inheritance"/>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="//field[@name = $inheritance]/ml-text">
						<xsl:variable name="valml">
							<xsl:value-of select="//field[@name = $inheritance]/ml-text/@value"/>
						</xsl:variable>
						<xsl:value-of select="/document/PersLocales/field[./name = $valml]/trad"/>
					</xsl:when>
					<xsl:when test="//field[@name = $inheritance]/text()">
						<xsl:value-of select="//field[@name = $inheritance]/text()"/>
					</xsl:when>
					<xsl:when test="//field[@name = $inheritance]/@caption">
						<xsl:value-of select="//field[@name = $inheritance]/@caption"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$inheritance"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:with-param>
	</xsl:call-template>
	<xsl:choose>
		<xsl:when test="$type = 'DOC'">
			<xsl:choose>
				<xsl:when test="/document/Params/XMLC_FORMATTER = 'PDA'">
					<a class="maintafile">
						<xsl:attribute name="href"><xsl:if test="'1'='2'"><!--YS : ca peut servir pour plutard pour le t�l�chargement des fichiers depuis le mobile--><xsl:choose><xsl:when test="/document/XMLC_Params/XMLC_HTTPS = '1'">https</xsl:when><xsl:otherwise>http</xsl:otherwise></xsl:choose>://<xsl:value-of select="/document/XMLC_Params/XMLC_Host"/><xsl:value-of select="/document/Aliases/MOS_XMLDLL"/></xsl:if><xsl:value-of select="$valeur"/></xsl:attribute>
						<xsl:value-of select="$valeur"/>
					</a>
				</xsl:when>
				<xsl:when test="$mode = 'external'">
					<a target="_blank">
						<xsl:attribute name="href"><xsl:value-of select="$absolutebaseref2"/><xsl:value-of select="$valeur"/></xsl:attribute>
						<xsl:value-of select="$valeur"/>
					</a>
				</xsl:when>
				<xsl:when test="$mode = 'internal'">
					<a>
						<xsl:attribute name="href"><xsl:value-of select="$absolutebaseref"/><xsl:value-of select="$valeur"/></xsl:attribute>
						<xsl:value-of select="$valeur"/>
					</a>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$partial = 'yes'">
							<div name="DV{$nom}" id="DV{$id}" width="100%" height="100%" style="width: 100%; height: 100%;" class="clFieldMaintaMemoType"/>
						</xsl:when>
					</xsl:choose>
					<iframe width="100%" height="100%" marginwidth="0" marginheight="0" frameborder="0">
						<xsl:attribute name="style"><xsl:choose><xsl:when test="$partial = 'yes'">visibility: hidden; display: none;</xsl:when><xsl:otherwise>display: block;</xsl:otherwise></xsl:choose></xsl:attribute>
						<xsl:attribute name="id">iFrame_<xsl:value-of select="$id"/></xsl:attribute>
						<xsl:attribute name="name">iFrame_<xsl:value-of select="$nom"/></xsl:attribute>
						<xsl:attribute name="src"><xsl:value-of select="$absolutebaseref"/><xsl:value-of select="$valeur"/></xsl:attribute>
					</iframe>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:when test="$type = 'HREF'">
			<a class="clFieldMaintaHREFType">
				<xsl:if test="$nolink != 'true'">
					<xsl:attribute name="href"><xsl:value-of select="$absolutebaseref"/><xsl:choose><xsl:when test="@href = 'FormSearch'">FormSearch?SEACRHTEXT=</xsl:when><xsl:otherwise><xsl:value-of select="@href"/><xsl:if test="$absolutebaseref!=''">?ID1=</xsl:if></xsl:otherwise></xsl:choose><xsl:value-of select="$valeur"/><xsl:if test="$absolutebaseref!='' or @href = 'FormSearch'">&amp;FF=<xsl:value-of select="/document/Params/FF"/>&amp;CONTEXTFID=<xsl:value-of select="/document/Params/CONTEXTFID"/></xsl:if></xsl:attribute>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="$relativepath = 'yes'">
						<xsl:variable name="tab" select="$xslCursor"/>
						<xsl:choose>
							<xsl:when test="($src = '' or not($src) ) and ($caption != '')">
								<xsl:value-of select="$tab/*[name() = $caption]/text()"/>
							</xsl:when>
							<xsl:when test="($caption != '')">
								<xsl:value-of select="$tab/*[name() = $src]/*[name() = $caption]/text()"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$valeur"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="($src = '' or $src = $table or not($src)) and ($caption != '')">
						<xsl:value-of select="/document/*[name() = $table]/*[name() = $caption]/text()"/>
					</xsl:when>
					<xsl:when test="($caption != '')">
						<xsl:value-of select="/document/*[name() = $table]/*[name() = $src]/*[name() = $caption]/text()"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$valeur"/>
					</xsl:otherwise>
				</xsl:choose>
			</a>
		</xsl:when>
		<xsl:when test="$type = 'MEMO'">
			<xsl:call-template name="mainta:advInput">
				<xsl:with-param name="onblur">
					<xsl:value-of select="$jsonblur"/>
				</xsl:with-param>
				<xsl:with-param name="id">
					<xsl:value-of select="$id"/>
				</xsl:with-param>
				<xsl:with-param name="attributes">
					<attributes 
						typ_="{$TYP_}" 
						src_="{$SRC_}" 
						inh_="{$INH_}" 
						inr_="{$INR_}" 
						sa_="{$SA_}" 
						fm_="{$FMODE_}" 
						acs_="{$ACS_}" 
						valdef_="{$valdef}" 
						incookies_="{$INCOOKIES_}" 
						ctl_="{$CTL_}"/>
				</xsl:with-param>
				<xsl:with-param name="OnChange">
					<xsl:value-of select="$onchange"/>
				</xsl:with-param>
				<xsl:with-param name="input">
					<xsl:choose>
						<xsl:when test="$mode = 'external'">
							<a class="img_special txtzero edit" href=".">
								<xsl:attribute name="onclick">
									window.open('<xsl:value-of select="/document/Aliases/MOS_XMLDLL"/>GetRTF2HTML?ID1=<xsl:value-of select="$valeur"/>&amp;TABLE=<xsl:value-of select="$table"/>&amp;TITRE=<xsl:value-of select="$title"/>', 
									'', 
									'left=200,top=200,width=600,height=500,scrollbars,resizable'); 
									return false;
								</xsl:attribute>
								<!-- Ajout de l'événement onBlur sur le lien -->
								<xsl:if test="$jsonblur != ''">
									<xsl:attribute name="onblur"><xsl:value-of select="$jsonblur"/></xsl:attribute>
								</xsl:if>
							</a>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="$partial = 'yes'">
								<div 
									name="DV{$nom}" 
									id="DV{$id}" 
									width="100%" 
									height="100%" 
									style="width: 100%; height: 100%;" 
									class="clFieldMaintaMemoType">
									<!-- Ajout de l'événement onBlur sur le div -->
									<xsl:if test="$jsonblur != ''">
										<xsl:attribute name="onblur"><xsl:value-of select="$jsonblur"/></xsl:attribute>
									</xsl:if>
								</div>
							</xsl:if>
							
							<iframe 
								width="100%" 
								height="100%" 
								marginwidth="0" 
								marginheight="0" 
								frameborder="0">
								<xsl:attribute name="style">
									<xsl:choose>
										<xsl:when test="$partial = 'yes'">visibility: hidden; display: none;</xsl:when>
										<xsl:otherwise>display: block;</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<xsl:attribute name="id">iFrame_<xsl:value-of select="$id"/></xsl:attribute>
								<xsl:attribute name="name">iFrame_<xsl:value-of select="$nom"/></xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="/document/Aliases/MOS_XMLDLL"/>GetRTF2HTML?ID1=<xsl:value-of select="$valeur"/>&amp;TABLE=<xsl:value-of select="$table"/>&amp;PARTIAL=<xsl:choose>
										<xsl:when test="$partial = 'yes'">YES&amp;DIVID=DV<xsl:value-of select="$id"/></xsl:when>
										<xsl:otherwise>NO</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<!-- Ajout de l'événement onBlur sur l'iframe -->
								<xsl:if test="$jsonblur != ''">
									<xsl:attribute name="onblur"><xsl:value-of select="$jsonblur"/></xsl:attribute>
								</xsl:if>
							</iframe>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="$type = 'CHECK'">
			<label>
				<img alt="{$title}" title="{$title}" border="0">
					<xsl:attribute name="src"><xsl:choose><xsl:when test="$relativehref = 'no'"><xsl:choose><xsl:when test="/document/Params/GLOBAL_PORTAL_URL != ''"><xsl:value-of select="/document/Params/GLOBAL_PORTAL_URL"/></xsl:when><xsl:when test="/document/Params/GLOBAL_WWW_URL != ''"><xsl:value-of select="/document/Params/GLOBAL_WWW_URL"/>../../..</xsl:when><xsl:otherwise><xsl:choose><xsl:when test="/document/XMLC_Params/XMLC_HTTPS = '1'">https://</xsl:when><xsl:otherwise>http://</xsl:otherwise></xsl:choose><xsl:value-of select="/document/XMLC_Params/XMLC_Host"/></xsl:otherwise></xsl:choose></xsl:when><xsl:otherwise/></xsl:choose><xsl:value-of select="$PictosMainta"/><xsl:choose><xsl:when test="$valeur = 'O' or $valeur = 'YES' or $valeur = 'Y' or $valeur = 'o' or ($valeur = $radiovalue and $radiovalue != '')">133.gif</xsl:when><xsl:otherwise>134.gif</xsl:otherwise></xsl:choose></xsl:attribute>
				</img>
				<span>
					<xsl:value-of select="$caption"/>
				</span>
			</label>
		</xsl:when>
		<xsl:when test="$type = 'RADIO'">
			<label>
				<img alt="{$title}" title="{$title}" border="0">
					<xsl:attribute name="src"><xsl:choose><xsl:when test="$relativehref = 'no'"><xsl:choose><xsl:when test="/document/Params/GLOBAL_PORTAL_URL != ''"><xsl:value-of select="/document/Params/GLOBAL_PORTAL_URL"/></xsl:when><xsl:when test="/document/Params/GLOBAL_WWW_URL != ''"><xsl:value-of select="/document/Params/GLOBAL_WWW_URL"/>../../..</xsl:when><xsl:otherwise><xsl:choose><xsl:when test="/document/XMLC_Params/XMLC_HTTPS = '1'">https://</xsl:when><xsl:otherwise>http://</xsl:otherwise></xsl:choose><xsl:value-of select="/document/XMLC_Params/XMLC_Host"/></xsl:otherwise></xsl:choose></xsl:when><xsl:otherwise/></xsl:choose><xsl:value-of select="$PictosMainta"/><xsl:choose><xsl:when test="($valeur = $radiovalue and $radiovalue != '') or $valeur = 'O' or $valeur = 'YES' or $valeur = 'Y' or $valeur = 'o'">radioc.gif</xsl:when><xsl:otherwise>radio.gif</xsl:otherwise></xsl:choose></xsl:attribute>
				</img>
				<span>
					<xsl:value-of select="$caption"/>
				</span>
			</label>
		</xsl:when>
		<xsl:when test="$type = 'FIELD'">
			<xsl:call-template name="mainta:advInput">
				<xsl:with-param name="style">
					<xsl:value-of select="$style"/>
				</xsl:with-param>
				<xsl:with-param name="input">
					<input id="{$id}" name="{$nom}" type="text" readonly="readonly" class="disabled">
						<xsl:if test="$disabled = 'yes'">
							<xsl:attribute name="disabled"/>
						</xsl:if>
						<xsl:if test="$labelfor != ''">
							<xsl:attribute name="labelfor"><xsl:value-of select="$labelfor"/></xsl:attribute>
						</xsl:if>
						<xsl:attribute name="value"><xsl:choose><xsl:when test="$valeur = ''">&#xA0;</xsl:when><xsl:otherwise><xsl:value-of select="$valeur"/></xsl:otherwise></xsl:choose></xsl:attribute>
					</input>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="$type = 'HIDDEN'">
			<input id="{$id}" name="{$nom}" type="hidden">
				<xsl:attribute name="value"><xsl:value-of select="$valeur"/></xsl:attribute>
			</input>
		</xsl:when>
		<xsl:when test="$type = 'PRINT'">
			<xsl:choose>
				<xsl:when test="$valeur = ''">&#xA0;</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$locale= 'yes'">
							<!--à traduire en locale-->
							<xsl:value-of select="/document/Locales/*[name() = $valeur]" disable-output-escaping="yes"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$valeur" disable-output-escaping="yes"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:when test="$type = 'MEMOPRINT'">
			<xsl:variable name="idmemo">
				<xsl:choose>
					<xsl:when test="$relativepath = 'yes'">
						<xsl:value-of select="$valeur"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="generate-id()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$partial = 'yes'">
					<div name="DV{$nom}{$idmemo}" id="DV{$id}{$idmemo}" width="100%" height="100%" style="width: 100%; height: 100%;background-color: transparent;"/>
				</xsl:when>
			</xsl:choose>
			<iframe width="100%" height="100%" marginwidth="0" marginheight="0" frameborder="0">
				<xsl:attribute name="style"><xsl:choose><xsl:when test="$partial = 'yes'">visibility: hidden; display: none;</xsl:when><xsl:otherwise>display: block;</xsl:otherwise></xsl:choose>background-color: transparent;</xsl:attribute>
				<xsl:attribute name="id">iFrame_<xsl:value-of select="$id"/><xsl:value-of select="$idmemo"/></xsl:attribute>
				<xsl:attribute name="name">iFrame_<xsl:value-of select="$nom"/><xsl:value-of select="$idmemo"/></xsl:attribute>
				<xsl:attribute name="src"><xsl:value-of select="/document/Aliases/MOS_XMLDLL"/>GetRTF2HTML?ID1=<xsl:value-of select="$valeur"/>&amp;TABLE=<xsl:value-of select="$table"/>&amp;PARTIAL=<xsl:choose><xsl:when test="$partial = 'yes'">YES&amp;DIVID=DV<xsl:value-of select="$id"/><xsl:value-of select="$idmemo"/></xsl:when><xsl:otherwise>NO</xsl:otherwise></xsl:choose></xsl:attribute>
			</iframe>
		</xsl:when>
		<xsl:otherwise>
			<span class="clFieldMainta">
				<xsl:choose>
					<xsl:when test="$valeur = ''">&#xA0;</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$valeur"/>
					</xsl:otherwise>
				</xsl:choose>
			</span>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
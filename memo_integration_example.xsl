<!-- Variable jsonblur définie au début -->
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

<!-- Section 1: Modification pour le type MEMO -->
<xsl:when test="$type = 'MEMO'">
    <xsl:choose>
        <xsl:when test="$mode = 'external'">
            <a class="img_special txtzero edit" href=".">
                <xsl:attribute name="onclick">window.open('<xsl:value-of select="/documnet/Aliases/MOS_XMLDLL"/>GetRTF2HTML?ID1=<xsl:value-of select="$valeur"/>&amp;TABLE=<xsl:value-of select="$table"/>&amp;TITRE=<xsl:value-of select="$title"/>', '', 'left=200,top=200,width=600,height=500,scrollbars,resizable'); return false;</xsl:attribute>
                <!-- Ajout de l'événement onBlur -->
                <xsl:if test="$jsonblur != ''">
                    <xsl:attribute name="onblur"><xsl:value-of select="$jsonblur"/></xsl:attribute>
                </xsl:if>
            </a>
        </xsl:when>
        <xsl:otherwise>
            <xsl:choose>
                <xsl:when test="$partial = 'yes'">
                    <div name="DV{$nom}" id="DV{$id}" width="100%" height="100%" style="width: 100%; height: 100%;" class="clFieldMaintaMemoType">
                        <!-- Ajout de l'événement onBlur sur le div -->
                        <xsl:if test="$jsonblur != ''">
                            <xsl:attribute name="onblur"><xsl:value-of select="$jsonblur"/></xsl:attribute>
                        </xsl:if>
                    </div>
                </xsl:when>
            </xsl:choose>
            <iframe width="100%" height="100%" marginwidth="0" marginheight="0" frameborder="0">
                <xsl:attribute name="style"><xsl:choose><xsl:when test="$partial = 'yes'">visibility: hidden; display: none;</xsl:when><xsl:otherwise>display: block;</xsl:otherwise></xsl:choose></xsl:attribute>
                <xsl:attribute name="id">iFrame_<xsl:value-of select="$id"/></xsl:attribute>
                <xsl:attribute name="name">iFrame_<xsl:value-of select="$nom"/></xsl:attribute>
                <xsl:attribute name="src"><xsl:value-of select="/documnet/Aliases/MOS_XMLDLL"/>GetRTF2HTML?ID1=<xsl:value-of select="$valeur"/>&amp;TABLE=<xsl:value-of select="$table"/>&amp;PARTIAL=<xsl:choose><xsl:when test="$partial = 'yes'">YES&amp;DIVID=DV<xsl:value-of select="$id"/></xsl:when><xsl:otherwise>NO</xsl:otherwise></xsl:choose></xsl:attribute>
                <!-- Ajout de l'événement onBlur sur l'iframe -->
                <xsl:if test="$jsonblur != ''">
                    <xsl:attribute name="onblur"><xsl:value-of select="$jsonblur"/></xsl:attribute>
                </xsl:if>
            </iframe>
        </xsl:otherwise>
    </xsl:choose>
</xsl:when>

<!-- Section 2: Modification pour les boutons memo -->
<xsl:if test="($type = 'memo')">
    <xsl:if test="($acces != 'disabled') and ($acces != 'readonly')">
        <xsl:call-template name="mainta:Button">
            <xsl:with-param name="Class">edit</xsl:with-param>
            <xsl:with-param name="Caption">
                <img border="0" align="absmiddle">
                    <xsl:attribute name="src"><xsl:value-of select="$PictosMainta"/>045g.gif</xsl:attribute>
                </img>
            </xsl:with-param>
            <xsl:with-param name="HRef">.</xsl:with-param>
            <xsl:with-param name="Hint">
                <xsl:value-of select="/document/Locales/toolmemo"/>
            </xsl:with-param>
            <xsl:with-param name="OnClick">
                <xsl:choose>
                    <xsl:when test="($acces = 'disabled') or ($acces = 'readonly')">return false;</xsl:when>
                    <xsl:otherwise>javascript:win = window.open('MemoEditor?ID1='+getObjectById('<xsl:value-of select="$id"/>').value+'&amp;TABLE=<xsl:choose>
                            <!--Si c'est une donnée étendue de type mémo-->
                            <xsl:when test="contains($id, 'PDO')">EXT<xsl:choose>
                                    <xsl:when test="$exttablename != ''">
                                        <xsl:value-of select="$exttablename"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$table"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$table"/>
                            </xsl:otherwise>
                        </xsl:choose>&amp;DESC=<xsl:call-template name="mainta:escapeSimpleQuote">
                            <xsl:with-param name="originalString">
                                <xsl:choose>
                                    <xsl:when test="../node()[name()='label'] ">
                                        <xsl:apply-templates select="../node()[name()='label']"/>
                                        <!--Récupère le contenu de la balise label-->
                                    </xsl:when>
                                    <xsl:when test="@caption and string(@caption) != ''">
                                        <xsl:value-of select="@caption"/>
                                        <!--Récupère la valeur du caption dans la balise zone-->
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates select="node()[name()!='option']"/>
                                        <!--Sélectionne les nœuds enfants (node()) de l'élément actuel, sauf les nœuds "option"-->
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:with-param>
                        </xsl:call-template>&amp;FORM=<xsl:value-of select="$form"/>&amp;FIELDNAME=<xsl:value-of select="$id"/>&amp;PARTIAL=<xsl:choose>
                            <xsl:when test="$partial='yes'">YES&amp;DIVID=DV<xsl:value-of select="$id"/>&amp;ACS=<xsl:value-of select="$mode"/>
                            </xsl:when>
                            <xsl:otherwise>NO</xsl:otherwise>
                        </xsl:choose>&amp;FRAMENAME=iFrame_<xsl:value-of select="$id"/>
                        <xsl:if test="$saveIDMemo = 'yes'">&amp;SAVEIDMEMO=YES&amp;IDSOURCE=<xsl:value-of select="$IDsource"/>&amp;COLSOURCE=<xsl:value-of select="$COLsource"/>
                        </xsl:if>
                        <xsl:if test="$memohtml = 'yes'">&amp;ONLY_HTML=YES</xsl:if>','Wnd_','left=150,top=100,width=750,height=610,scrollbars,resizable');win.focus(); return false;</xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
            <!-- Ajout du paramètre OnBlur pour le bouton -->
            <xsl:with-param name="OnBlur">
                <xsl:if test="$jsonblur != ''">
                    <xsl:value-of select="$jsonblur"/>
                </xsl:if>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:if test="$buttonCustom='copy'">
            <xsl:call-template name="mainta:Button">
                <xsl:with-param name="Caption">
                    <xsl:choose>
                        <xsl:when test="$buttonCustom='copy'">
                            <i class="icon small pictos icon-006"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <img border="0" align="absmiddle">
                                <xsl:attribute name="src"><xsl:value-of select="$PictosMainta"/><xsl:value-of select="$buttonCustom"/></xsl:attribute>
                            </img>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
                <xsl:with-param name="HRef">.</xsl:with-param>
                <xsl:with-param name="Hint">
                    <xsl:choose>
                        <xsl:when test="$buttonCustom='copy'">
                            <xsl:value-of select="/document/Locales/copymemo"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$buttonCustomHint"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
                <xsl:with-param name="OnClick">
                    <xsl:choose>
                        <xsl:when test="($acces = 'disabled') and ($acces = 'readonly')">return false;</xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="$buttonCustom='copy'">CopyMemo()</xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$buttonCustomAction"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
                <xsl:with-param name="flatDesign">yes</xsl:with-param>
                <!-- Ajout du paramètre OnBlur pour le bouton de copie -->
                <xsl:with-param name="OnBlur">
                    <xsl:if test="$jsonblur != ''">
                        <xsl:value-of select="$jsonblur"/>
                    </xsl:if>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:if>
</xsl:if>
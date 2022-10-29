<?xml version="1.0" encoding="ISO-8859-1" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method = "text" encoding="ISO-8859-1" />
<xsl:strip-space elements="*" />

<xsl:template match="*">
  <xsl:apply-templates select = "*" />
</xsl:template>

<xsl:template match="@*">@<xsl:value-of select = "name()" />="<xsl:value-of select = "." />",</xsl:template>

<!-- Pour filtrer les éléments, il suffit de mettre les noms des balises à inclure à la place de *, séparés par '|' -->
<xsl:template match="*">

<xsl:for-each select = "ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:apply-templates select = "@*" />]</xsl:for-each>=<xsl:value-of select="text()" />
<xsl:text>
</xsl:text>

<xsl:apply-templates select = "*" />

</xsl:template>


</xsl:stylesheet>
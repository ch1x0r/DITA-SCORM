<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:adlcp="http://www.adlnet.org/xsd/adlcp_rootv1p2"  
    xmlns:date="http://exslt.org/dates-and-times"
    xmlns:monkey="http://monkeymediasoftware.com/monkeynamespace"
    exclude-result-prefixes="xsl adlcp date monkey"
    extension-element-prefixes="date"
    version="2.0"> 
    
    <xsl:output
        method="html"
        omit-xml-declaration="yes"
        encoding="UTF-8"
        indent="yes" />


<!-- MCC -->
<!-- launchmodule - contains navigation hrefs -->
<xsl:template name="launchmodule-MCC">
    <xsl:param name="title"/>   
    <xsl:result-document href="{$module}-{$mode}/HTML/index.html">
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
        <xsl:text>
        </xsl:text>

        <xsl:apply-templates select="document(concat('../LIBRARY-BASE/',$lessons_dir,'/HTML/index.html'))/*" mode="tags">
                <xsl:with-param name="title" select="$title"/>
                <xsl:with-param name="num" select='none'/>
                <xsl:with-param name="img" select='none'/>
            </xsl:apply-templates>
        </xsl:result-document>
</xsl:template>    
    
    
<xsl:template match="div[@id='MCC_title']" mode="tags"> 
        <xsl:param name="title"/>
        <xsl:param name="num"/>
        <xsl:param name="img"/>
    
        <h1><xsl:value-of select="$title"/></h1>
</xsl:template>



</xsl:stylesheet>
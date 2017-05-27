<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:adlcp="http://www.adlnet.org/xsd/adlcp_rootv1p2"  
                xmlns:date="http://exslt.org/dates-and-times"
                xmlns:monkey="http://monkeymediasoftware.com/monkeynamespace"
                exclude-result-prefixes="xsl adlcp date monkey"
                extension-element-prefixes="date"
                version="2.0"> 

<!-- functions -->
  
<!-- make filename out of title -->
<xsl:function name="monkey:get_html_filename">
    <xsl:param name="title"/>
    <xsl:param name="num"/>
    <xsl:value-of select="concat('_',$num,'_',lower-case(replace($title,'[^a-zA-Z0-9]','_')),'.html')" />
</xsl:function>

<!-- get filename from URL -->
<xsl:function name="monkey:get_URL_filename">
  <xsl:param name="URL"/>
  <xsl:analyze-string select="$URL" regex="([^/]+)$">
    <xsl:matching-substring>
        <xsl:value-of select="regex-group(1)"/>
    </xsl:matching-substring>  
  </xsl:analyze-string>
  
  
</xsl:function>  
  
<!-- get parent directory from URL -->
<xsl:function name="monkey:get_URL_filename_parent_dir">
    <xsl:param name="URL"/>
    <xsl:analyze-string select="$URL" regex="/([^/]+)/([^/]+)$">
      <xsl:matching-substring>
        <xsl:value-of select="regex-group(1)"/>
      </xsl:matching-substring>
      <!--
    <xsl:non-matching-substring>
      <xsl:value-of select="false()"></xsl:value-of>
    </xsl:non-matching-substring>
    -->
    </xsl:analyze-string>
    
</xsl:function>  

  <!-- get subdirectory from full directory doc-map path -->
  <xsl:function name="monkey:get_path_subdir">
    <xsl:param name="dir"/>
    <xsl:param name="dir_forward_slash"/>
    <xsl:param name="sub_dir"/>
    
    
    
    <xsl:choose>
      <xsl:when test="$dir_forward_slash=true()">
        <xsl:analyze-string select="$dir" regex="(.+)(/{$sub_dir}/)(.+)$">
          <xsl:matching-substring>
            <xsl:value-of select="concat(regex-group(1),regex-group(2))"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:otherwise>
       
        <!-- <xsl:value-of select="$sub_dir"></xsl:value-of> -->
        <xsl:analyze-string select="$dir" regex="(.+)(\\{$sub_dir}\\)(.+)$">
          <xsl:matching-substring>
            <xsl:value-of select="concat(regex-group(1),regex-group(2))"/>            
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>  
  
  
  <!-- get parent from full directory doc-map path -->
  <xsl:function name="monkey:get_path_dir_parent">
    <xsl:param name="dir"/>
    <xsl:param name="dir_forward_slash"/>
    
    <xsl:choose>
      <xsl:when test="$dir_forward_slash=true()">
        <xsl:analyze-string select="$dir" regex="/([^/]+)/([^/]+)$">
          <xsl:matching-substring>
            <xsl:value-of select="regex-group(1)"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:otherwise>
        <!-- <xsl:value-of select="$sub_dir"></xsl:value-of> -->
        <xsl:analyze-string select="$dir" regex="\\([^\\]+)\\([^\\]+)$">
          <xsl:matching-substring>
            <xsl:value-of select="regex-group(1)"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>  
  
  
  
  <xsl:function name="monkey:format_dir_slashes">
    <xsl:param name="string"/>
    <xsl:param name="dir_forward_slash"/>
    
    <xsl:choose>
      <xsl:when test="not($dir_forward_slash)">
        <xsl:value-of select="replace($string,'/','\\')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$string"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>  
  
  <xsl:function name="monkey:get_1_0">
    <xsl:param name="boolean_val"/>
    <xsl:choose>
      <xsl:when test="$boolean_val">
        <xsl:value-of select="1"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="0"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>  
  

<!-- outputting html file contents -->
  <xsl:template match="*" mode="tags">
    <xsl:param name="num"/>
    <xsl:param name="title"/>
    <xsl:param name="img"/>
    <xsl:variable name="tagname" select="local-name()"/>
    <xsl:element name="{$tagname}">
      <xsl:call-template name="get-attribs"/>
      <xsl:apply-templates mode="tags">
        <xsl:with-param name="num" select="$num" />
        <xsl:with-param name="title" select="$title"/>
        <xsl:with-param name="img" select="$img"/>
      </xsl:apply-templates>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="get-attribs">
    <xsl:for-each select="@*">
      <xsl:variable name="attname" select="name()"/>
      <xsl:attribute name="{$attname}"><xsl:value-of select="."></xsl:value-of></xsl:attribute>
    </xsl:for-each>
  </xsl:template>  
  
  
  
  
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:adlcp="http://www.adlnet.org/xsd/adlcp_rootv1p2"  
                xmlns:fo ="http://www.w3.org/1999/XSL/Format"
                xmlns:svg="http://www.w3.org/2000/svg"
                xmlns:date="http://exslt.org/dates-and-times"
                xmlns:monkey="http://monkeymediasoftware.com/monkeynamespace"
                version="2.0">
   
  
  
  
<!-- HIDING ELEMENTS - CSM stopped working so taken out ! - revisit-->
<!--xsl:template match="*[@outputclass]" priority="1">
  <xsl:param name="xml_filename"/>
  <xsl:choose>
    <xsl:when test="contains(@outputclass,'hide_eu') and $hide_eu = true()"></xsl:when>
  <xsl:otherwise>
    
    <xsl:if test="name()!='note'">
    <xsl:apply-templates>
      <xsl:with-param name="xml_filename" select="$xml_filename"/>
    </xsl:apply-templates>
    </xsl:if>
    
  </xsl:otherwise>  
  </xsl:choose>
  
</xsl:template-->
  
  <!-- title -->
  <xsl:template match="title">
    <h2>
      <xsl:if test="parent::task"><xsl:attribute name="id">task</xsl:attribute></xsl:if>
      <xsl:value-of select="."/>
    </h2>
  </xsl:template>  
  

  
  
  
 
  
  
  
  <!-- hyper text links -->

  <xsl:template match="xref[not(contains(@outputclass,'sublevel')) and not(contains(@outputclass,'pdf_more_info'))]">
    <xsl:param name="xml_filename"></xsl:param>  
    
   
    
  
  <!-- title -->
 
    <xsl:variable name="href_title">
      <xsl:choose>
        <xsl:when test="contains(@outputclass,'attached')">
          <xsl:value-of select="'more info'"></xsl:value-of>
          
        </xsl:when>
        <xsl:when test="string-length(text())>0"> <!--This is for the other links on the page... -->
          <xsl:value-of select="text()"/>
        </xsl:when>
       
        <xsl:otherwise>
          <xsl:value-of select="document(@href)/title[1]"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

  
    <!-- xml file in link where -->
    <xsl:variable name="fileURL">
      <xsl:choose>
        <xsl:when test="contains(@href,'#')">
          <xsl:value-of select="substring-before(@href,'#')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'#'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="filename" select="($fileURL)"/>

  
    <!-- output link this is where we would like a param feature for no links or links--> 
    <a class="internal" href="{$filename}"><xsl:value-of select="$href_title"/></a> 
    
  </xsl:template>  
<!-- definitely href_title. if changed to filename links to the actual html id or filename such as task_open_mapping_to_production2 or something -->

  
<!-- audio -->  
<xsl:template match="data[@name='audio']">
  <div id="sm2-container">
    <!-- flash movie is added here -->
  </div>
 
 <xsl:variable name="link_txt">
   <xsl:choose>
     <xsl:when test="string-length(text())>0"><xsl:value-of select="text()"/></xsl:when>
     <xsl:otherwise>Play Audio</xsl:otherwise>
   </xsl:choose>
   
 </xsl:variable>
 
 <!--
  <div class="ui360">
    <a href="{concat('../AUDIO/SRC/',monkey:get_URL_filename(@value))}"><xsl:value-of select="$link_txt"></xsl:value-of></a>
  </div>  
  -->
  
  <p class="mm_audio">
    <a class="sm2_button" href="{concat('../AUDIO/SRC/',monkey:get_URL_filename(@value))}"></a><xsl:value-of select="$link_txt"/>
  </p>  
  
</xsl:template>  
  
<!-- video -->  
<xsl:template match="data[@name='video']">
  
  <!--
  <video class="mejs-ted" width="640" height="360" src="{concat('../VIDEO/SRC/',monkey:get_URL_filename(@value))}" type="video/mp4" 
    controls="controls" poster="../VIDEO/MMBUILD/poster-cover.png" preload="none"></video>
  -->
  
  
  <!--video class="mejs-ted" src="{concat('../VIDEO/SRC/',monkey:get_URL_filename(@value))}" type="video/mp4" 
    controls="controls" poster="../VIDEO/MMBUILD/poster-cover.png" preload="none"-->
  
  <xsl:choose>
  <xsl:when test="data[@name='width']">
    <xsl:attribute name="width"><xsl:value-of select="data[@name='width']"/></xsl:attribute>
  </xsl:when>  
    <xsl:otherwise><xsl:attribute name="width"><xsl:value-of select="640"/></xsl:attribute> </xsl:otherwise>
  </xsl:choose>
    
    <xsl:choose>
      <xsl:when test="data[@name='height']">
        <xsl:attribute name="height"><xsl:value-of select="data[@name='height']"/></xsl:attribute>
      </xsl:when>  
      <xsl:otherwise><xsl:attribute name="height"><xsl:value-of select="360"/></xsl:attribute> </xsl:otherwise>
    </xsl:choose>
    
    
  <!--/video-->
  
  
  
</xsl:template>    
  
  <!--
<xsl:template match="*[@conref]" priority="1">
  
  <xsl:variable name="dir" select="monkey:get_URL_filename_parent_dir(substring-before(@conref,'#'))"/>  
  <xsl:variable name="file" select="monkey:get_URL_filename(substring-before(@conref,'#'))"/>
  <xsl:variable name="id" select="substring-after(@conref,'#')"/>
   -->
  <!-- find contents of file -->
  <!-- <xsl:variable name="includes_file" select="concat($INCLUDES_XML_BASE,$dir,'/',$file)"/>
  -->
  <!--
  <xsl:message>FILE=<xsl:value-of select="$includes_file"/></xsl:message>
  <xsl:message>ID=<xsl:value-of select="$id"/></xsl:message>
  -->
  <!--
  <xsl:apply-templates select="document($includes_file)//*[@id=$id]"/>
  
</xsl:template -->
 
  
  
<xsl:template match="p">
<xsl:param name="xml_filename"/>  
  
  <xsl:choose>
    <xsl:when test="@outputclass='heading'">
      <h3><xsl:value-of select="."/></h3>
    </xsl:when>
    
    <xsl:when test="contains(@outputclass,'quote:no-quote-marks')">
      <p class="quote_text"><xsl:apply-templates/></p>
    </xsl:when>
    
      
      
    <xsl:when test="contains(@outputclass,'quote:small')">
      <p class="small_quote_text"><span class="small_start_quote"/><xsl:apply-templates/><span class="small_end_quote"/></p>
    </xsl:when>
    
    
    <xsl:when test="contains(@outputclass,'front_icon:')">
      <xsl:variable name="img_file" select="concat('../IMAGES/',substring-after(@outputclass,'front_icon:'),'.png')"/>
      <p class="icon"><span class="icon"><img src="{$img_file}"/></span><xsl:apply-templates/></p>
    </xsl:when>


    <xsl:when test="contains(@outputclass,'pretask:')">
      <xsl:variable name="txt" select="substring-after(@outputclass,'pretask:')"/>
      <p><span class="pretask"><xsl:value-of select="$txt"/></span><xsl:apply-templates/></p>
    </xsl:when>
    
    
    
    <xsl:when test="contains(@outputclass,'action_label:')">
      <xsl:variable name="txt" select="substring-after(@outputclass,'action_label:')"/>
      <p><span class="action_label"><xsl:value-of select="$txt"/></span><xsl:apply-templates/></p>
    </xsl:when>
    
    <xsl:when test="contains(@outputclass,'action_submit_form:')">     
      <xsl:variable name="txt" select="substring-after(@outputclass,'action_submit_form:')"/>
      <p><span class="submit_button"><xsl:value-of select="$txt"/></span><xsl:apply-templates/></p>
    </xsl:when>
    
    <xsl:when test="contains(@outputclass,'action_click_button:')">     
      <xsl:variable name="txt" select="substring-after(@outputclass,'action_click_button:')"/>
      <p><span class="action_click_button"><xsl:value-of select="$txt"/></span><xsl:apply-templates/></p>
    </xsl:when>
    
    
    <xsl:when test="contains(@outputclass,'action_plus_label:')">     
      <xsl:variable name="txt" select="substring-after(@outputclass,'action_plus_label:')"/>
      <p><span class="action_plus_label"><xsl:value-of select="$txt"/></span><xsl:apply-templates/></p>
    </xsl:when>
    
    <xsl:when test="contains(@outputclass,'action_checkbox_checked:')">     
      <xsl:variable name="txt" select="substring-after(@outputclass,'action_checkbox_checked:')"/>
      <p><span class="action_checkbox_checked"><xsl:value-of select="$txt"/></span><xsl:apply-templates/></p>
    </xsl:when>
    
    
    
    
    
    <xsl:when test="@outputclass">
      
      <p class="{@outputclass}"><xsl:apply-templates>  
        <xsl:with-param name="xml_filename" select="$xml_filename" ></xsl:with-param>
      </xsl:apply-templates></p>
    </xsl:when>
    
    <xsl:otherwise>
      <p><xsl:apply-templates>
        <xsl:with-param name="xml_filename" select="$xml_filename"></xsl:with-param>
      </xsl:apply-templates></p>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>  

<xsl:template match="ul">
  <xsl:param name="xml_filename"/>
      <ul>
        <xsl:if test="@outputclass">
          <xsl:attribute name="class"><xsl:value-of select="@outputclass"/></xsl:attribute>
        </xsl:if>        
        <xsl:apply-templates>
          <xsl:with-param name="xml_filename" select="$xml_filename"></xsl:with-param>
        </xsl:apply-templates>
      </ul>
</xsl:template>
  

<xsl:template match="li">
  <xsl:param name="xml_filename"/>
  <li><xsl:apply-templates>
    <xsl:with-param name="xml_filename" select="$xml_filename"/>
  </xsl:apply-templates></li>
</xsl:template>
  
<xsl:template match="b">
  <b><xsl:apply-templates/></b>
</xsl:template>  
    
<xsl:template match="table">
  <xsl:param name="xml_filename"/>
<table>
    <xsl:if test="@outputclass">
      <xsl:attribute name="class"><xsl:value-of select="@outputclass"/></xsl:attribute>
    </xsl:if>
    <xsl:apply-templates select="tgroup">
      <xsl:with-param name="xml_filename" select="$xml_filename"/>
    </xsl:apply-templates>
</table>
</xsl:template>
 

 
 
<xsl:template match="thead">
  <xsl:param name="xml_filename"/>
  <xsl:call-template name="row">
    <xsl:with-param name="row_type" select="'row_header'"/>
    <xsl:with-param name="xml_filename" select="$xml_filename"/>
  </xsl:call-template>
</xsl:template>  

<xsl:template match="tbody">
  <xsl:param name="xml_filename"/>
  <xsl:call-template name="row" >
    <xsl:with-param name="xml_filename" select="$xml_filename"/>
  </xsl:call-template>
</xsl:template>  
  
  <!-- PREREQ IN TASK -->
  <xsl:template match="prereq">
    <p> <fo:block margin-top="10pt">
      <!-- keep-with-previous="3" -->
      
      <fo:block font-weight="bold"><b>Pre Task Requirement: </b>    </fo:block>
      <xsl:apply-templates />
    </fo:block>    </p>
  </xsl:template>
  
  <!-- substeps -->
  <xsl:template match="substeps" >
    <!-- keep-with-previous="2" -->
    <fo:block margin-top="7pt" >
      <xsl:apply-templates select="substep" />
    </fo:block>
  </xsl:template>
  
  
  <!-- result IN TASK -->
  <xsl:template match="result">
    <p><br> <fo:block margin-top="10pt">  
      <!-- keep-with-previous="3" -->
      
      <fo:block font-weight="bold"><b>Results: </b>    </fo:block>
      <xsl:apply-templates />
    </fo:block> </br> </p>
  </xsl:template>
  
  <!-- note in Topic -->
  <xsl:template match="note">
    <p><br> <fo:block margin-top="10pt">  
      <!-- keep-with-previous="3" -->
      
      <fo:block font-weight="bold"><b>Note: </b>    </fo:block>
      <xsl:apply-templates />
    </fo:block> </br> </p>
  </xsl:template>
  
  

<!-- table rows -->
<xsl:template name="row">
  <xsl:param name="xml_filename"/>
<xsl:param name="row_type">row_body</xsl:param>
  <xsl:for-each select="row">       
  <tr>
      <xsl:choose>
        <xsl:when test="@outputclass">
          <xsl:attribute name="class"><xsl:value-of select="@outputclass" /></xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="class"><xsl:value-of select="$row_type" /></xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>

    
      <!-- entry = <td> -->
      <!-- in <tgroup>
         <colspec colname="1" colnum="1"/>
         <colspec colname="2" colnum="2"/>
         <colspec colname="3" colnum="3"/>
      
      in <entry>
        namest="2" nameend="3"
     -->
    
        <xsl:for-each select="entry">
      
        <xsl:variable name="colspan">
            <xsl:choose>
              <xsl:when test="@nameend">
                <xsl:variable name="nameend" select="@nameend"/>
                <xsl:value-of select="number(ancestor::tgroup//colspec[@colname=$nameend]/@colnum) - position() + 1"/>
              </xsl:when>
              <xsl:otherwise><xsl:value-of select="0"/></xsl:otherwise>
            </xsl:choose>    
        </xsl:variable>
        
        <td>
          <xsl:if test="$colspan > 0">
            <xsl:attribute name="colspan"><xsl:value-of select="$colspan"/></xsl:attribute>
          </xsl:if>          
          
        
        <xsl:if test="@outputclass">
          <xsl:attribute name="class"><xsl:value-of select="@outputclass" /></xsl:attribute>
        </xsl:if>
 
        <xsl:choose>
          <xsl:when test="not(p) and contains(@outputclass,'label')">
            <span>
              <xsl:apply-templates>
                <xsl:with-param name="xml_filename" select="$xml_filename"></xsl:with-param>
              </xsl:apply-templates>
            </span>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates>
              <xsl:with-param name="xml_filename" select="$xml_filename"></xsl:with-param>
            </xsl:apply-templates>
          </xsl:otherwise>
        </xsl:choose>
        
      </td>
      </xsl:for-each>  
  </tr> 
  </xsl:for-each>
</xsl:template>  


<!-- images -->
<xsl:template match="image">
  <!-- <xsl:variable name="href" select="@href"/> -->
  <!-- href="../images-education-institute/doc_buyer_types.png" -->
  
  <xsl:element name="img">
  
    <!--  outputclass="noborder:lms_height=150" -->
  <xsl:if test="contains(@outputclass,'lms_height=')">
    <xsl:attribute name="height" select="substring-after(@outputclass,'lms_height=')"/>
  </xsl:if>
    
    <xsl:if test="contains(@outputclass,'lms_width=')">
      <xsl:attribute name="width" select="substring-after(@outputclass,'lms_width=')"/>
    </xsl:if>
  
  <!-- href -->
  <xsl:analyze-string select="@href" regex="([^/]+)$">
  <xsl:matching-substring>
    
    <xsl:if test="$draw_border_images=true()">
    <xsl:attribute name="class" select="'border'"/>
   </xsl:if>
    
    <xsl:attribute name="src" select="concat('../IMAGES/',regex-group(1))"/>
  </xsl:matching-substring>
  </xsl:analyze-string>
 
  </xsl:element>
    
 
</xsl:template>

<!-- titles for images -->
<xsl:template match="title[parent::fig]">
  <h3 class="img"><xsl:value-of select="text()"/></h3>
</xsl:template>  


 
 
 
 
  <!-- tasks -->
  <xsl:template match="steps">
    <xsl:param name="xml_filename"/> 
    
    <ul class="steps num">
      <xsl:for-each select="step[not(contains(@outputclass,'hide_eu') and $hide_eu = true())]">
        
        <li>
          <xsl:if test="contains(cmd/@outputclass,'navbar')">
            <xsl:attribute name="class"><xsl:value-of select="cmd/@outputclass"/></xsl:attribute>
          </xsl:if>
          <!-- cmd -->
             <span class="instruction">
            <xsl:apply-templates select="cmd"/>
          </span>
         
          <xsl:if test="cmd/@outputclass">
            
            <xsl:choose>
              <xsl:when test="contains(cmd/@outputclass,':')">
                
                <!-- action_label: works -->
                <xsl:choose>
                  <xsl:when test="contains(cmd/@outputclass,'action_label')">
                    <span class="action_label"><xsl:value-of select="substring-after(cmd/@outputclass,':')"/></span>
                  </xsl:when>
                </xsl:choose> <!-- strip out select text if it exists -->
                
                
                
                <!-- action_click_button: works -->
                <xsl:choose>
                  <xsl:when test="contains(cmd/@outputclass,'action_click_button')">
                    <span class="action_click_button"><xsl:value-of select="substring-after(cmd/@outputclass,':')"/></span>
                  </xsl:when>
                </xsl:choose>
                
               
                <!-- action_submit_form: Go -->
                <xsl:choose>
                  <xsl:when test="contains(cmd/@outputclass,'action_submit_form')">
                    <span class="submit_button"><xsl:value-of select="substring-after(cmd/@outputclass,':')"/></span>
                  </xsl:when>
            
            
                  <!-- strip out select text if it exists -->
                    <xsl:when test="contains(cmd/text(),'select')">
                      <xsl:value-of select="substring-after(cmd/text(),'select')"/>
                    </xsl:when>
                    
                    <xsl:when test="contains(cmd/text(),'Select')">
                      <xsl:value-of select="substring-before(cmd/text(),'')"/>
                    </xsl:when>
                    
                    <xsl:otherwise>
                      <xsl:value-of select="cmd"/>
                    </xsl:otherwise>
                    
     
                  
                
                </xsl:choose>
                
              </xsl:when>
              
              <xsl:otherwise>
                <span class="icon"><img src="../IMAGES/{cmd/@outputclass}.png"/></span>
              </xsl:otherwise>
              
              
            </xsl:choose>
          </xsl:if>
          <!-- info and rest -->
          <xsl:apply-templates select="info">
            <xsl:with-param name="xml_filename" select="$xml_filename"></xsl:with-param>
          </xsl:apply-templates>
        </li>
        
      </xsl:for-each>
    </ul> 
  </xsl:template>
 
 
 
 
 
 
 
 
 
 
  <xsl:template match="substeps">
<xsl:param name="xml_filename"/>  
    <ul class="steps_alpha">
    <xsl:for-each select="substep">
      <li><xsl:apply-templates>
        <xsl:with-param name="xml_filename" select="$xml_filename"/>
      </xsl:apply-templates></li>
    </xsl:for-each>
  </ul>   
</xsl:template>
    



<xsl:template match="info">
<xsl:param name="xml_filename"/>  
  <div class="task_info">
    <xsl:apply-templates>
      <xsl:with-param name="xml_filename" select="$xml_filename"/>
    </xsl:apply-templates>
  </div>
</xsl:template>



  
<xsl:template match="screen">
  <div class="screen"><xsl:apply-templates/></div>
</xsl:template>

<xsl:template match="screen/data">
    <div class="systemoutput"><xsl:apply-templates/></div>
</xsl:template>

<xsl:template match="keyword">
  <div class="keyword"><xsl:apply-templates/></div>
</xsl:template>

 <xsl:template match="systemoutput">
    <div class="systemoutput"><xsl:apply-templates/></div>
 </xsl:template>

  
</xsl:stylesheet>

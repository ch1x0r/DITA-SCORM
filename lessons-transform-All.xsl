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
<!--This transform file includes the Note, Prereq and Results. This includes No chapter titles and action_click items. This is the comprehensive transform for our current needs.-->
<!-- based on transform test Dec 27. Created February 21, 2017 -Updated Feb27 -->  

 <!-- conf -->
<xsl:param name="INCLUDES_XML_BASE" />
    
<!-- current directory of doc map file -->
<xsl:param name="file_path" />
<xsl:param name="module"/>

<!-- software - scenario -->
<xsl:param name="draw_border_images" select="true()" />

<!-- if set to true - does not show all elements with @outputclass CONTAINING hide_eu -->
<xsl:param name="hide_eu" select="true()"/>

 <!-- MAC SETTINGS -->
  
 <!-- mac path to bash script -->
 <xsl:param name="mac_script" select="'/Users/monkeyadmin/Documents/mmedia/documentation/trunk/mac.sh'"/>  
 <xsl:param name="mac_env" select="false()"/> 
  
 <xsl:variable name="command_script">
   <xsl:choose>
     <xsl:when test="$mac_env">
       <xsl:value-of select="concat($mac_script,' ')"/>
     </xsl:when>
     <xsl:otherwise>
       <xsl:value-of select="'perl '"/>
     </xsl:otherwise>
   </xsl:choose>
   
 </xsl:variable> 
  <!-- HIDE TASK CONTEXT -Need for menu management etc-->
  <xsl:template match="context"></xsl:template>
  
 

<xsl:variable name="dir_forward_slash">
  <xsl:choose>
    <xsl:when test="$mac_env">
      <xsl:value-of select="true()"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="false()"/>
    </xsl:otherwise>
  </xsl:choose>
  
</xsl:variable>
  

<!-- directories -->
<xsl:param name="lessons_dir" select="'Lessons'"/>  
  
<!-- mode -->
<xsl:param name="mode" select="'SCORM'"/>  

<xsl:param name="scorm_path" select="monkey:get_path_subdir($file_path,$dir_forward_slash,'HTML')"/>
<xsl:param name="destination_dir" select="concat($scorm_path,monkey:get_path_dir_parent($file_path,$dir_forward_slash),monkey:format_dir_slashes(concat('/',$module,'-',$mode),$dir_forward_slash))"/>




<!-- used for debugging & editing -->
<xsl:param name="debug_xmlfilename" select="false()"/>  <!-- xml filename display in html output -->  
<xsl:param name="debug_worddoc" select="false()"/> <!-- link to word doc --> 

<!-- used for sublevel links - default value for MCC help -->
<xsl:param name="sublevel_module" select="'../../../../SOFTWARE-SUB-LEVEL-HELP/OUTPUT-MCC-HELP-SUBLEVEL/'" />

<!-- includes -->
<xsl:include href="utilstestdec27.xsl" />  
<xsl:include href="quiz-utils.xsl"/>
<xsl:include href="lessons_base_formatting-all.xsl"/>

  <xsl:include href="MCC-plugin.xsl"/>

<xsl:template match="map">
 
   <!-- if mac environment make NEW BATCH FILE -->
   <xsl:message>
    <xsl:if test="$mac_env">
      
      <xsl:value-of select="Runtime:exec(Runtime:getRuntime(),concat($mac_script,' start'))"
        xmlns:Runtime="java:java.lang.Runtime"/> 

    </xsl:if>
   </xsl:message>
 
 
   <!-- MAKE HTML PAGES -->
  <xsl:call-template name="html_pages"/>


  <!-- MAKE NAV CONTROL - NEXT/PREV -->
  <xsl:choose>
    <xsl:when test="$mode='SCORM'"><xsl:call-template name="launchmodule"/></xsl:when>
    <xsl:otherwise><xsl:call-template name="launchmodule-MCC"><xsl:with-param name="title" select="title/text()"/></xsl:call-template></xsl:otherwise>
  </xsl:choose>
  
    
  <!-- MAKE PAGINATION PAGES -->
  <xsl:call-template name="pagination_pages"/>


  <!-- MAKE MANIFEST FILE -->
  <xsl:if test="$mode='SCORM'">
  <xsl:call-template name="manifest"/>
  </xsl:if>
  
  <!-- RUN SCRIPT TO COPY FILES -->
  <xsl:call-template name="run_script"/>
  
  <xsl:message>
    <xsl:if test="$mac_env">
 
    <xsl:value-of select="Runtime:exec(Runtime:getRuntime(),'/usr/bin/open -a Terminal /tmp/BATCH')"
      xmlns:Runtime="java:java.lang.Runtime"/> 
      
    </xsl:if>
  </xsl:message>
  
  
  
</xsl:template>

<!-- run script to copy files to SCORM dir -->
<xsl:template name="run_script">
  
  
  <xsl:variable name="copy_dir_files_script" select="concat($scorm_path,monkey:format_dir_slashes('ENGINE/script/copy_dir_files.pl',$dir_forward_slash))"></xsl:variable>
 
  <xsl:variable name="source_dir" select="concat($scorm_path,monkey:format_dir_slashes(concat('ENGINE/LIBRARY-BASE/',$lessons_dir),$dir_forward_slash))"/>
  
  <xsl:variable name="source_audio_dir" select="concat($scorm_path,monkey:format_dir_slashes('ENGINE/LIBRARY-BASE/AUDIO',$dir_forward_slash))"/>
  
  <xsl:variable name="source_video_dir" select="concat($scorm_path,monkey:format_dir_slashes('ENGINE/LIBRARY-BASE/VIDEO',$dir_forward_slash))"/>
  
  <xsl:variable name="sq">&quot;</xsl:variable>
  
  <xsl:variable name="command" select="concat($command_script,' ',$sq,$copy_dir_files_script,$sq,' ',$sq,$source_dir,$sq,' ',$sq,$source_audio_dir,$sq,' ',$sq,$source_video_dir,$sq,' ',$sq,$destination_dir,$sq,' ',monkey:get_1_0($dir_forward_slash))" />
  
   <!-- BASE IMAGES, CSS, JSCRIPT, AUDIO, VIDEO -->
  <xsl:message>
    
    <!--
    STATIC COPY:
    SOURCE AUDIO =<xsl:value-of select="$source_audio_dir"/>
    DEST=<xsl:value-of select="$destination_dir"/> 
    -->
    <!--
    PERL - <xsl:value-of select="$command"></xsl:value-of>
    -->
   
   
    <xsl:value-of select="Runtime:exec(Runtime:getRuntime(),$command)"
      xmlns:Runtime="java:java.lang.Runtime"/> 

  </xsl:message>


  <!-- IMAGES/AUDI0/VIDEO IN XML FILES -->
  <xsl:variable name="copy_file_script" select="concat($scorm_path,monkey:format_dir_slashes('ENGINE/script/copy_file.pl',$dir_forward_slash))"></xsl:variable>
  <xsl:variable name="xml_lib_path" select="monkey:get_path_subdir($file_path,$dir_forward_slash,'XML-LIBRARY')"/>
  <xsl:for-each select="topicgroup">
    
    <xsl:choose>
      <xsl:when test="topicmeta/category">
        
        <!-- SECTION PAGE IMAGE -->
        <xsl:if test="topicmeta/data[@name='img_cover']/@value">
          <xsl:variable name="URL" select="topicmeta/data[@name='img_cover']/@value"/>
          <xsl:variable name="filename" select="monkey:get_URL_filename($URL)"/>
          <xsl:variable name="filename_parent_dir" select="monkey:get_URL_filename_parent_dir($URL)"/>
          
          <xsl:variable name="source_file" select="monkey:format_dir_slashes(concat($xml_lib_path,$filename_parent_dir,'/',$filename),$dir_forward_slash)"/>   
          <xsl:variable name="dest_file" select="monkey:format_dir_slashes(concat($destination_dir,'/IMAGES/',$filename),$dir_forward_slash)"/>
          
          <xsl:variable name="dest_dir" select="monkey:format_dir_slashes(concat($destination_dir,'/IMAGES'),$dir_forward_slash)"/>
          <xsl:variable name="command" select="concat($command_script,'&quot;',$copy_file_script,'&quot;',' ','&quot;',$source_file,'&quot;',' ',' &quot;',$dest_file,'&quot;',' ','&quot;',$dest_dir,'&quot;')" />
          
          
        <xsl:message>
       
       <!--
       DYNAMIC COPY:
        SOURCE=<xsl:value-of select="$source_file"/>
        DEST=<xsl:value-of select="$dest_file"/>     
       -->     
          
            
            <xsl:value-of select="Runtime:exec(Runtime:getRuntime(),$command)"
              xmlns:Runtime="java:java.lang.Runtime"/>
          
          

        </xsl:message>
        </xsl:if>
        
      </xsl:when>
      
      <xsl:otherwise>
        
        <!-- get images from xml files -->
        <xsl:for-each select="document(topicref/@href)//image">
          <xsl:variable name="filename" select="monkey:get_URL_filename(@href)"/>
          <xsl:variable name="filename_parent_dir" select="monkey:get_URL_filename_parent_dir(@href)"/>

          <xsl:variable name="source_file" select="monkey:format_dir_slashes(concat($xml_lib_path,$filename_parent_dir,'/',$filename),$dir_forward_slash)"/>         
         
          <xsl:variable name="dest_file" select="monkey:format_dir_slashes(concat($destination_dir,'/IMAGES/',$filename),$dir_forward_slash)"/>
          
          <xsl:variable name="dest_dir" select="monkey:format_dir_slashes(concat($destination_dir,'/IMAGES'),$dir_forward_slash)"/>
          <xsl:variable name="command" select="concat($command_script,'&quot;',$copy_file_script,'&quot;',' ','&quot;',$source_file,'&quot;',' ',' &quot;',$dest_file,'&quot;',' ','&quot;',$dest_dir,'&quot;')" />
          
          <xsl:message>
            
         <!--   
         DYNAMIC COPY:
         SOURCE=<xsl:value-of select="$source_file"/>
         DEST=<xsl:value-of select="$dest_file"/> 
         -->     
            
              
              
              <xsl:value-of select="Runtime:exec(Runtime:getRuntime(),$command)"
                xmlns:Runtime="java:java.lang.Runtime"/>
              

            
            
             
          </xsl:message>
          
        </xsl:for-each>
        
        
        <!-- get task step cmd icon images from xml files -->
        <!-- <cmd outputclass="action_add_billing_account"> -->
        <xsl:for-each select="document(topicref/@href)//cmd/@outputclass">
          <xsl:variable name="filename" select="concat(.,'.png')"/>
          <xsl:variable name="filename_parent_dir" select="'icons'"/>
          
          <xsl:variable name="source_file" select="monkey:format_dir_slashes(concat($xml_lib_path,$filename_parent_dir,'/',$filename),$dir_forward_slash)"/>         
          
          <xsl:variable name="dest_file" select="monkey:format_dir_slashes(concat($destination_dir,'/IMAGES/',$filename),$dir_forward_slash)"/>
          
          <xsl:variable name="dest_dir" select="monkey:format_dir_slashes(concat($destination_dir,'/IMAGES'),$dir_forward_slash)"/>
          <xsl:variable name="command" select="concat($command_script,'&quot;',$copy_file_script,'&quot;',' ','&quot;',$source_file,'&quot;',' ',' &quot;',$dest_file,'&quot;',' ','&quot;',$dest_dir,'&quot;')" />
          
          <xsl:message>
            
            <!--
            DYNAMIC COPY:
            ICON SOURCE=<xsl:value-of select="$source_file"/>
            ICON DEST=<xsl:value-of select="$dest_file"/> 
            -->

            <xsl:value-of select="Runtime:exec(Runtime:getRuntime(),$command)"
              xmlns:Runtime="java:java.lang.Runtime"/>

          </xsl:message>
          
        </xsl:for-each>
        
        
        <!-- get icon images, front of paragraphs, front of lists -->
        <xsl:for-each select="document(topicref/@href)//*[contains(@outputclass,'front_icon')]">
          <xsl:apply-templates select="." mode="copy_icons">
            <xsl:with-param name="copy_file_script" select="$copy_file_script"/>
            <xsl:with-param name="xml_lib_path" select="$xml_lib_path"/>
          </xsl:apply-templates>
        </xsl:for-each>
        
        
        <!-- conrefs -->
        <xsl:for-each select="document(topicref/@href)//*[@conref]">
           
          <xsl:variable name="dir" select="monkey:get_URL_filename_parent_dir(substring-before(@conref,'#'))"/>  
          <xsl:variable name="file" select="monkey:get_URL_filename(substring-before(@conref,'#'))"/>
          <xsl:variable name="id" select="substring-after(@conref,'#')"/>
          
          <!-- includes file -->
          <xsl:variable name="includes_file" select="concat($INCLUDES_XML_BASE,$dir,'/',$file)"/>
          
          <xsl:for-each select="document($includes_file)//*[@id=$id]//*[contains(@outputclass,'front_icon')]">
              <xsl:apply-templates select="." mode="copy_icons">
                <xsl:with-param name="copy_file_script" select="$copy_file_script"/>
                <xsl:with-param name="xml_lib_path" select="$xml_lib_path"/>
              </xsl:apply-templates>
          </xsl:for-each>
          
        </xsl:for-each>

        
        
        
        
        
        
        
        
        
        <!-- audio -->
        <xsl:for-each select="document(topicref/@href)//data[@name='audio']">
          <xsl:variable name="filename" select="monkey:get_URL_filename(@value)"/>
          <xsl:variable name="filename_parent_dir" select="monkey:get_URL_filename_parent_dir(@value)"/>
          
          <xsl:variable name="source_file" select="monkey:format_dir_slashes(concat($xml_lib_path,$filename_parent_dir,'/',$filename),$dir_forward_slash)"/>
          
          <xsl:variable name="dest_file" select="monkey:format_dir_slashes(concat($destination_dir,'/AUDIO/SRC/',$filename),$dir_forward_slash)"/>
          
          <xsl:variable name="dest_dir" select="monkey:format_dir_slashes(concat($destination_dir,'/AUDIO/SRC'),$dir_forward_slash)"/>
          
          <xsl:variable name="command" select="concat($command_script,'&quot;',$copy_file_script,'&quot;',' ','&quot;',$source_file,'&quot;',' ',' &quot;',$dest_file,'&quot;',' ','&quot;',$dest_dir,'&quot;')" />
          
          <xsl:message>
            
            <!--
            DYNAMIC COPY:
            SOURCE=<xsl:value-of select="$source_file"/>
            DEST=<xsl:value-of select="$dest_file"/> 
            -->
            
            
            <xsl:value-of select="Runtime:exec(Runtime:getRuntime(),$command)"
              xmlns:Runtime="java:java.lang.Runtime"/>
            
            
          </xsl:message>
          
        </xsl:for-each>
        
        
        
        <!-- video -->
        <xsl:for-each select="document(topicref/@href)//data[@name='video']">
          <xsl:variable name="filename" select="monkey:get_URL_filename(@value)"/>
          <xsl:variable name="filename_parent_dir" select="monkey:get_URL_filename_parent_dir(@value)"/>
          
          <xsl:variable name="source_file" select="monkey:format_dir_slashes(concat($xml_lib_path,$filename_parent_dir,'/',$filename),$dir_forward_slash)"/>
          
          <xsl:variable name="dest_file" select="monkey:format_dir_slashes(concat($destination_dir,'/VIDEO/SRC/',$filename),$dir_forward_slash)"/>
          
          <xsl:variable name="dest_dir" select="monkey:format_dir_slashes(concat($destination_dir,'/VIDEO/SRC'),$dir_forward_slash)"/>
          <xsl:variable name="command" select="concat($command_script,'&quot;',$copy_file_script,'&quot;',' ','&quot;',$source_file,'&quot;',' ',' &quot;',$dest_file,'&quot;',' ','&quot;',$dest_dir,'&quot;')" />
          
          
          <xsl:message>
            <!--
            DYNAMIC COPY:
            SOURCE=<xsl:value-of select="$source_file"/>
            DEST=<xsl:value-of select="$dest_file"/> 
            -->
            
            
            <xsl:value-of select="Runtime:exec(Runtime:getRuntime(),$command)"
              xmlns:Runtime="java:java.lang.Runtime"/>
            
            
          </xsl:message>
          
        </xsl:for-each>
               
      </xsl:otherwise> 
    </xsl:choose> 
    
  </xsl:for-each>






</xsl:template>


<!-- SCORM MANIFEST FILE -->
<xsl:template name="manifest">
  <xsl:result-document href="{$module}-SCORM/imsmanifest.xml">
    <xsl:text disable-output-escaping='yes'>&lt;?xml version="1.0" encoding="UTF-8"?>
    </xsl:text>
    <xsl:text disable-output-escaping='yes'>&lt;manifest identifier="MONKEYMANIFEST" 
    xmlns="http://www.imsproject.org/xsd/imscp_rootv1p1p2" 
    xmlns:adlcp="http://www.adlnet.org/xsd/adlcp_rootv1p2" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xsi:schemaLocation="http://www.imsproject.org/xsd/imscp_rootv1p1p2 imscp_rootv1p1p2.xsd http://www.adlnet.org/xsd/adlcp_rootv1p2 adlcp_rootv1p2.xsd">
    </xsl:text>
  
    <xsl:element name="metadata">
      <xsl:element name="schema">ADL SCORM</xsl:element>
      <xsl:element name="schemaversion">1.2</xsl:element>
    </xsl:element>
  
    <xsl:element name="organizations">
    <xsl:attribute name="default">TOC</xsl:attribute>
       <xsl:element name="organization">
         <xsl:attribute name="identifier">TOC</xsl:attribute>
         <xsl:attribute name="structure">hierarchical</xsl:attribute>
         <xsl:element name="title">Course: <xsl:value-of select="title"/></xsl:element>
         <xsl:element name="item">
           <xsl:attribute name="identifier">ITEM1</xsl:attribute>
           <xsl:attribute name="identifierref">MOD1</xsl:attribute>
           <xsl:attribute name="isvisible">true</xsl:attribute>
           <xsl:element name="title"><xsl:value-of select="title"/></xsl:element>
         </xsl:element>
       </xsl:element>
      
    </xsl:element>
  
    <xsl:element name="resources">
      <xsl:element name="resource">
        <xsl:attribute name="identifier">MOD1</xsl:attribute>
        <xsl:attribute name="type">webcontent</xsl:attribute>
        <xsl:attribute name="adlcp:scormtype">sco</xsl:attribute>
        <xsl:attribute name="href">HTML/launchmodule.html</xsl:attribute>
 
      <xsl:for-each select="topicgroup">
        
          <xsl:choose>
            <xsl:when test="topicmeta/category">
              <!-- SECTION/REVIEW PAGE IMAGE -->
              <xsl:if test="topicmeta/data[@name='img_cover']/@value">
                <xsl:variable name="URL" select="topicmeta/data[@name='img_cover']/@value"/>
                <xsl:variable name="filename" select="monkey:get_URL_filename($URL)"/>
                <xsl:element name="file">
                <xsl:attribute name="href">IMAGES/<xsl:value-of select="$filename"/></xsl:attribute>
                </xsl:element>
              </xsl:if>
              
           
            </xsl:when>
            
            <xsl:otherwise>
              <!-- NORMAL PAGE - TOPIC OR TASK -->
              <xsl:variable name="start_page" select="document(topicref[1]/@href)" />
              <xsl:variable name="title" select="$start_page//title[parent::topic|parent::task]/text()" />
              <xsl:variable name="filename" select="monkey:get_html_filename($title,position())" />
              <xsl:element name="file">
                <xsl:attribute name="href">HTML/<xsl:value-of select="$filename"/></xsl:attribute>
               </xsl:element>
            </xsl:otherwise> 
          </xsl:choose> 
  
      </xsl:for-each>
        
        <xsl:element name="dependency">
          <xsl:attribute name="identifierref">CSS</xsl:attribute>
        </xsl:element>
        
        <xsl:element name="dependency">
          <xsl:attribute name="identifierref">JSCRIPT</xsl:attribute>
        </xsl:element>
        
        <xsl:element name="dependency">
          <xsl:attribute name="identifierref">IMAGES</xsl:attribute>
        </xsl:element>
        
        <xsl:element name="dependency">
          <xsl:attribute name="identifierref">AUDIO</xsl:attribute>
        </xsl:element>
        
        <xsl:element name="dependency">
          <xsl:attribute name="identifierref">VIDEO</xsl:attribute>
        </xsl:element>
        
        <xsl:if test="$debug_worddoc">
        <xsl:element name="dependency">
          <xsl:attribute name="identifierref">DOC</xsl:attribute>
        </xsl:element>
        </xsl:if>
        
      </xsl:element><!-- resource -->
      
      <!-- CSS -->
      <xsl:element name="resource">
        <xsl:attribute name="identifier">CSS</xsl:attribute>
        <xsl:attribute name="type">webcontent</xsl:attribute>
        <xsl:attribute name="adlcp:scormtype">asset</xsl:attribute>
        
        <!-- BASE -->
        <xsl:copy-of select="document('../LIBRARY-BASE/Lessons/css_base_manifest.xml')/css_base_manifest/*" />
      </xsl:element>
      
      
      <!-- JAVSCRIPT -->
      <xsl:element name="resource">
        <xsl:attribute name="identifier">JSCRIPT</xsl:attribute>
        <xsl:attribute name="type">webcontent</xsl:attribute>
        <xsl:attribute name="adlcp:scormtype">asset</xsl:attribute>
        
        <!-- BASE -->
        <xsl:copy-of select="document('../LIBRARY-BASE/Lessons/js_base_manifest.xml')/js_base_manifest/*" />
        
        <!-- GENERATED -->
        <xsl:for-each select="topicgroup">
          <!-- javascript config file -->
            <xsl:if test="@outputclass='review_question'">
            <xsl:variable name="js_file" select="concat('_',position(),'_quiz-config.js')"/>
              <xsl:element name="file">
                <xsl:attribute name="href">JSCRIPT/<xsl:value-of select="$js_file"/></xsl:attribute>
              </xsl:element>
            </xsl:if>
        </xsl:for-each>

      </xsl:element>
      
      
      <!-- IMAGES -->
      <xsl:element name="resource">
        <xsl:attribute name="identifier">IMAGES</xsl:attribute>
        <xsl:attribute name="type">webcontent</xsl:attribute>
        <xsl:attribute name="adlcp:scormtype">asset</xsl:attribute>
      <!-- BASE -->  
      <xsl:copy-of select="document('../LIBRARY-BASE/Lessons/image_base_manifest.xml')/image_base_manifest/*" />
      
      <!-- images in xml files -->
        <xsl:for-each select="topicgroup">
          <xsl:choose>
            <xsl:when test="topicmeta/category">
              
              <!-- SECTION/REVIEW PAGE IMAGE -->
              <xsl:if test="topicmeta/data[@name='img_cover']/@value">
                <xsl:variable name="URL" select="topicmeta/data[@name='img_cover']/@value"/>
                <xsl:variable name="filename" select="monkey:get_URL_filename($URL)"/>
                <xsl:element name="file">
                  <xsl:attribute name="href">IMAGES/<xsl:value-of select="$filename"/></xsl:attribute>
                </xsl:element>
              </xsl:if>

            </xsl:when>
            
            <xsl:otherwise>
              
              <!-- get images from xml files -->
              <xsl:for-each select="document(topicref/@href)//image">
                <xsl:variable name="filename" select="monkey:get_URL_filename(@href)"/>
                <xsl:element name="file">
                  <xsl:attribute name="href">IMAGES/<xsl:value-of select="$filename"/></xsl:attribute>
                </xsl:element>
              </xsl:for-each>
              
              <xsl:for-each select="document(topicref/@href)//step/cmd/@outputclass">
                <xsl:if test="not(contains(.,':'))">
                <xsl:variable name="filename" select="concat(.,'.png')"/>
                <xsl:element name="file">
                  <xsl:attribute name="href">IMAGES/<xsl:value-of select="$filename"/></xsl:attribute>
                </xsl:element>
                </xsl:if>
              </xsl:for-each>
              
               <!-- ADD FOR CONREF - front_icon images FOR MCC in LMS -->
              
              
            </xsl:otherwise> 
          </xsl:choose> 
        </xsl:for-each>
      </xsl:element> <!-- end images -->
      
      
      
      <!-- AUDIO -->
      <xsl:element name="resource">
        <xsl:attribute name="identifier">AUDIO</xsl:attribute>
        <xsl:attribute name="type">webcontent</xsl:attribute>
        <xsl:attribute name="adlcp:scormtype">asset</xsl:attribute>
        <!-- BASE -->  
        <xsl:copy-of select="document('../LIBRARY-BASE/AUDIO/audio_base_manifest.xml')/audio_base_manifest/*" />
        
        <!-- audio files in xml files -->
        <xsl:for-each select="topicgroup">
              
              <!-- get images from xml files -->
              <xsl:for-each select="document(topicref/@href)//data[@name='audio']">
                <xsl:variable name="filename" select="monkey:get_URL_filename(@value)"/>
                <xsl:element name="file">
                  <xsl:attribute name="href">AUDIO/SRC/<xsl:value-of select="$filename"/></xsl:attribute>
                </xsl:element>
              </xsl:for-each>
              
        </xsl:for-each>
      </xsl:element> <!-- end audio -->
      
     
      <!-- VIDEO -->
      <xsl:element name="resource">
        <xsl:attribute name="identifier">VIDEO</xsl:attribute>
        <xsl:attribute name="type">webcontent</xsl:attribute>
        <xsl:attribute name="adlcp:scormtype">asset</xsl:attribute>
        <!-- BASE -->  
        <xsl:copy-of select="document('../LIBRARY-BASE/VIDEO/video_base_manifest.xml')/video_base_manifest/*" />
        
        <!-- video files in xml files -->
        <xsl:for-each select="topicgroup">
          
          <!-- get images from xml files -->
          <xsl:for-each select="document(topicref/@href)//data[@name='video']">
            <xsl:variable name="filename" select="monkey:get_URL_filename(@value)"/>
            <xsl:element name="file">
              <xsl:attribute name="href">VIDEO/SRC/<xsl:value-of select="$filename"/></xsl:attribute>
            </xsl:element>
          </xsl:for-each>
          
        </xsl:for-each>
      </xsl:element> <!-- end video -->
     
     
      <!-- word doc files -->
      
      <xsl:if test="$debug_worddoc">
      <xsl:element name="resource">
        <xsl:attribute name="identifier">DOC</xsl:attribute>
        <xsl:attribute name="type">webcontent</xsl:attribute>
        <xsl:attribute name="adlcp:scormtype">asset</xsl:attribute>
             
        <xsl:for-each select="topicgroup">
            <xsl:if test="not(topicmeta/category)">
              <!-- NORMAL PAGE - TOPIC OR TASK -->
              <xsl:variable name="start_page" select="document(topicref[1]/@href)" />
              <xsl:variable name="title" select="$start_page//title[parent::topic|parent::task]/text()" />
              <xsl:variable name="filename" select="monkey:get_html_filename($title,position())" />
              <xsl:element name="file">
                <xsl:attribute name="href">DOC/<xsl:value-of select="concat(substring-before($filename,'.html'),'.rtf')"/></xsl:attribute>
              </xsl:element>
            </xsl:if>           
        </xsl:for-each> 
        
      </xsl:element> <!-- end word doc -->
      </xsl:if>
     

    </xsl:element><!-- resources -->
  
  
<xsl:text disable-output-escaping='yes'>
&lt;/manifest></xsl:text>
</xsl:result-document>  
  
</xsl:template>  


<!-- HTML pages -->
<xsl:template name="html_pages">
  <!-- make individual HTML files including quiz html files --> 
  
  <xsl:for-each select="topicgroup">
    
    <xsl:choose>
      
      <!-- review question(s) -->
      <xsl:when test="@outputclass='review_question'">
        
        <xsl:call-template name="review_question_page">
          <xsl:with-param name="title" select="topicmeta/category/text()" />
          <xsl:with-param name="img"   select="topicmeta/data[@name='img_cover']/@value" />
          <xsl:with-param name="num" select="position()" />
        </xsl:call-template>
        
        <!-- make up javascript config file -->
        <xsl:call-template name="question_config">
          <xsl:with-param name="dir" select="concat($module,'-',$mode,'/JSCRIPT/')"/>
          <xsl:with-param name="js_file" select="concat('_',position(),'_quiz-config.js')"></xsl:with-param>
          <xsl:with-param name="xpath_topicref" select="topicref"/>
          <xsl:with-param name="results_message" select="'See the answers below!'"></xsl:with-param>
        </xsl:call-template>
        
        
        
      </xsl:when>
      <xsl:otherwise>
        <!-- html lessons -->
        <xsl:choose>
          <xsl:when test="topicmeta/category">
            
            <!-- SECTION PAGE -->
            <xsl:choose>
              
              <!-- with Image -->
              <xsl:when test="topicmeta/data[@name='img_cover']/@value">
           
                <xsl:call-template name="section_page">
                  <xsl:with-param name="title" select="topicmeta/category/text()" />
                  <xsl:with-param name="img"   select="topicmeta/data[@name='img_cover']/@value" />
                  <xsl:with-param name="num" select="position()" />
                </xsl:call-template>
              </xsl:when>
          
              <!-- without Image -->
              <xsl:otherwise>
                <xsl:call-template name="section_page">
                  <xsl:with-param name="title" select="topicmeta/category/text()" />
                  <xsl:with-param name="img"   select="' '" />
                  <xsl:with-param name="num" select="position()" />
                </xsl:call-template>
                
              </xsl:otherwise>
              
            </xsl:choose>
          
          
          </xsl:when>
          
          
          
          <xsl:otherwise>
            
            <!-- NORMAL PAGE -->
            <xsl:call-template name="normal_page">
              <xsl:with-param name="start_page" select="document(topicref[1]/@href)" />
              <xsl:with-param name="num" select="position()" />
              <xsl:with-param name="xml_filename" select="topicref[1]/@href"/>
            </xsl:call-template>
            
          </xsl:otherwise> 
        </xsl:choose> 
         
      </xsl:otherwise> 
    
    
    </xsl:choose>
    
    
  </xsl:for-each>
  
  
</xsl:template>  


<!-- pagination pages -->
<xsl:template name="pagination_pages">
  <xsl:result-document href="{$module}-{$mode}/JSCRIPT/pagination_pages.js">
  <![CDATA[
  // GENERATED FILE
  //Set up Array to contain page links
  var Pages = new Array();
  var Page_Processed = new Array();
  var Pages_File = new Object(); //used for href links to tie xml file to html filename
  var PageCount = 0;
  ]]>
 
    <xsl:for-each select="topicgroup">
     
      <xsl:choose>
        <xsl:when test="topicmeta/category">
          
          <!-- SECTION/REVIEW PAGE -->
            <xsl:variable name="title" select="topicmeta/category/text()" />
            <xsl:variable name="filename" select="monkey:get_html_filename($title,position())" />
            <xsl:variable name="page" select="concat('Pages[',position()-1,']','=','&quot;',$filename,'&quot;')"/> 
            <xsl:value-of select="$page"/><xsl:text>;
            </xsl:text>
            
        </xsl:when>
        
        <xsl:otherwise>
          <!-- NORMAL PAGE -->
            <xsl:variable name="start_page" select="document(topicref[1]/@href)" />
            <xsl:variable name="title" select="$start_page//title[parent::topic|parent::task]/text()" />
            <xsl:variable name="filename" select="monkey:get_html_filename($title,position())" />
            <xsl:variable name="page" select="concat('Pages[',position()-1,']','=','&quot;',$filename,'&quot;')"/> 
            <xsl:variable name="xml_file" select="monkey:get_URL_filename(topicref[1]/@href)"/>
            <xsl:variable name="pages_file" select="concat('Pages_File[&quot;',$xml_file,'&quot;]','=','&quot;',$filename,'&quot;')"/> 
            <xsl:value-of select="$page"/><xsl:text>;
            </xsl:text>
            <xsl:value-of select="$pages_file"/><xsl:text>;
            </xsl:text>
            
          
        </xsl:otherwise> 
      </xsl:choose> 
      
      <!-- Keep track of pages read - for status complete -->
      <xsl:value-of select="concat('Page_Processed[',position()-1,']','=',0)" />;
      
    </xsl:for-each>  
  
  </xsl:result-document>
  
</xsl:template>  



<!-- launchmodule - contains navigation hrefs -->
<xsl:template name="launchmodule">
  
  <xsl:result-document href="{$module}-{$mode}/HTML/launchmodule.html">
    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
    <xsl:text>
    </xsl:text>
    <xsl:copy-of select="document('../LIBRARY-BASE/Lessons/HTML/launchmodule.html')/*" />
  </xsl:result-document>
</xsl:template>



  <xsl:template name="section_page">
    <xsl:param name="title" />
    <xsl:param name="img" />
    <xsl:param name="num"/>
    
    <xsl:variable name="filename" select="monkey:get_html_filename($title,$num)" />

    <!-- get filename for image -->
    <xsl:variable name="img-filename" select="monkey:get_URL_filename($img)" />
    <xsl:variable name="path-and-image-filename" select="concat('../IMAGES/',$img-filename)" /> 

    <!-- start html -->
    <xsl:result-document href="{$module}-{$mode}/HTML/{$filename}">
    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
    <xsl:text>
    </xsl:text>
    <html>
      <head>
        <meta charset="utf-8"/>
        
        <title><xsl:value-of select="$title"/></title>
        
        <!-- Required stylesheet -->
        <link rel="stylesheet" type="text/css" href="../CSS/base.css" /><xsl:text>
        </xsl:text>
        
        <!-- Required Javascript -->
        <script type="text/javascript" src="../JSCRIPT/jquery.js"></script><xsl:text>
        </xsl:text>
        <script type="text/javascript" src="../JSCRIPT/page_controls.js"></script><xsl:text>
        </xsl:text>
        
      </head>
  <!--removing the h1 tag under the chapter will remove the heading line-->
      <body>
        <div id="chapter">
          <!--h1--><!--xsl:value-of select="$title"/--><!--/h1-->
          <div class="section_img" style="background-image:url({$path-and-image-filename})"></div>
          <h2>Chapter Overview</h2>
          <div class="chapter_overview">
            <ul class="chapter_overview">
              <xsl:for-each select="//topicgroup/topicref[position()=1]">
                <xsl:if test="contains(@outputclass,'chapter_overview')">
                  <xsl:variable name="filename" select="monkey:get_URL_filename(@href)"/>
                  <li> <a class="internal" href="{$filename}"><xsl:value-of select="document(@href)/topic/title/text()|document(@href)/task/title/text()" /></a></li>
                </xsl:if>
              </xsl:for-each>
            </ul>
            
            <div style="clear:both"></div>
          </div>
        </div>
        
      </body>
      
    </html>
    </xsl:result-document>
  </xsl:template>  
  
 
 <!-- review question page -->
  <xsl:template name="review_question_page">
    <xsl:param name="title" />
    <xsl:param name="img" />
    <xsl:param name="num"/>
    
    <!-- find title of review page -->
    <xsl:variable name="filename" select="monkey:get_html_filename($title,$num)" />
    
    <!-- get filename -->
    <xsl:variable name="img-filename" select="monkey:get_URL_filename($img)" />
    <xsl:variable name="path-and-image-filename" select="concat('../IMAGES/',$img-filename)" /> 
    
    <!-- start html -->
    <xsl:result-document href="{$module}-{$mode}/HTML/{$filename}">
      <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
      <xsl:text>
    </xsl:text>
      <xsl:apply-templates mode="tags" select="document('../LIBRARY-BASE/Lessons/HTML/review_question.html')/*">
        <xsl:with-param name="num" select="$num"/>
        <xsl:with-param name="title" select="$title"/>
        <xsl:with-param name="img" select="$path-and-image-filename"/>
      </xsl:apply-templates>
    </xsl:result-document>
  </xsl:template> 
 
 
  <xsl:template match="div[@id='placeholder']" mode="tags"> 
    <xsl:param name="num"/>
    <xsl:param name="title"/>
    <xsl:param name="img"/>
    
    <h1><xsl:value-of select="$title"/></h1>
    <div class="section_img" style="background-image:url({$img})"></div>
  </xsl:template>
 
 
 
 
  <xsl:template match="script[@src='placeholder_config_js']" mode="tags">
    <xsl:param name="num"/>
    <xsl:param name="title"/>
    <xsl:param name="img"/>
    <!-- <script src="placeholder_config_js"></script> -->
    <xsl:variable name="js_file" select="concat('_',$num,'_quiz-config.js')"></xsl:variable>
    
    <xsl:element name="script">
      <xsl:attribute name="src"><xsl:value-of select="concat('../JSCRIPT/',$js_file)"/></xsl:attribute>
    </xsl:element>
    <xsl:text>
    </xsl:text>
    
    <!-- start quiz -->
    <xsl:element name="script">
      jQuery(document).ready(function($) {
      $('#slickQuiz').slickQuiz({'startButton':false,'completionResponseMessaging': true});
      });
    </xsl:element>
    
  </xsl:template>
 
  
  <xsl:template name="normal_page">
    <xsl:param name="start_page"/>
    <xsl:param name="num"/>
    <xsl:param name="xml_filename"/>
    
    <xsl:variable name="title" select="$start_page//title[parent::topic|parent::task]/text()" />
    <xsl:variable name="filename" select="monkey:get_html_filename($title,$num)" />
    
    <!-- start html -->
    <xsl:result-document href="{$module}-{$mode}/HTML/{$filename}">
      <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
      <xsl:text>
      </xsl:text>
      <html>
        <head>
          <meta charset="utf-8"/>
          <title><xsl:value-of select="$title"/></title>
          
          <!-- Required stylesheet -->
          <link rel="stylesheet" type="text/css" href="../CSS/base.css" /><xsl:text>
        </xsl:text>
          
          <!-- Required Javascript -->
          <script type="text/javascript" src="../JSCRIPT/jquery.js"></script><xsl:text>
        </xsl:text>
          <script type="text/javascript" src="../JSCRIPT/page_controls.js"></script><xsl:text>
        </xsl:text>
          
          <!-- find audio xml in any of the files making up this page -->
          <xsl:for-each select="document(topicref/@href)//data[@name='audio']">
            
            <xsl:if test="position()=1">
              <!-- Audio stylesheet -->
              <!--
              <link rel="stylesheet" type="text/css" href="../AUDIO/CSS/360player.css" /><xsl:text>
            </xsl:text>
              -->
              <link rel="stylesheet" type="text/css" href="../AUDIO/CSS/mp3-player-button.css" /><xsl:text>
            </xsl:text>
              
            </xsl:if>
          </xsl:for-each>
          
          
          <xsl:for-each select="document(topicref/@href)//data[@name='audio']">
            <xsl:if test="position()=1">
              
             
              <!-- Apache-licensed animation library -->
              <!--
              <script type="text/javascript" src="../AUDIO/SCRIPT/berniecode-animator.js"></script><xsl:text>
            </xsl:text>-->
              
              <!-- the core stuff -->
              <script type="text/javascript" src="../AUDIO/SCRIPT/soundmanager2.js"></script><xsl:text>
            </xsl:text>
              
              <!--
              <script type="text/javascript" src="../AUDIO/SCRIPT/360player.js"></script><xsl:text>
            </xsl:text> -->
              
              <script type="text/javascript" src="../AUDIO/SCRIPT/mp3-player-button.js"></script><xsl:text>
            </xsl:text>
              
              <script type="text/javascript">
                
                    soundManager.setup({
                    // path to directory containing SM2 SWF
                    
                    url: '../AUDIO/SWF/',
                    debugMode: false,
                
                    
                    ontimeout: function() {
                      alert('SM2 could not start');
                    },
                    
                    onready: function() {
                    jQuery('.mm_audio a.sm2_button').css({'display': 'block'}); 
                    }
                

                });

              </script><xsl:text>
            </xsl:text>
            </xsl:if>
            
            <!-- soundManager.useFlashBlock: related CSS -->
            <link rel="stylesheet" type="text/css" href="../AUDIO/CSS/flashblock.css" /><xsl:text>
            </xsl:text>
            
          </xsl:for-each>
        
        
          <!-- video -->
          <xsl:for-each select="document(topicref/@href)//data[@name='video']">
            <xsl:if test="position()=1">
              
              <script type="text/javascript" src="../VIDEO/MMBUILD/mediaelement-and-player.min.js"></script><xsl:text>
            </xsl:text>
              
              <link rel="stylesheet" type="text/css" href="../VIDEO/MMBUILD/mediaelementplayer.min.css"/><xsl:text>
              </xsl:text>  
              
              <link rel="stylesheet" type="text/css" href="../VIDEO/MMBUILD/mejs-skins.css" /><xsl:text>
              </xsl:text>
             
              

            </xsl:if>
            
          </xsl:for-each> <!-- end video -->
          
          
          <!-- Required Modernizr file -->
          <script src="../JSCRIPT/modernizr.custom.23933.js"></script>
        </head>
        <body>
          <div id="container">
            
            <xsl:if test="$debug_xmlfilename">
              <div class="debug_xmlfilename">
                Source : <xsl:value-of select="monkey:get_URL_filename($xml_filename)"/>
              </div>
            </xsl:if>

            <xsl:if test="$debug_worddoc">
              <div class="debug_worddoc">
                <xsl:variable name="worddoc" select="concat('../DOC/',substring-before($filename,'.html'),'.rtf')"/>
                Doc for edits/comments : <a href="{$worddoc}">CLICK HERE TO DOWNLOAD</a>
              </div>
            </xsl:if>
            
            <xsl:element name="h1">
            
            <!-- SOFTWARE TASK -->
            <xsl:if test="$start_page//title[parent::task]">
              <xsl:attribute name="class">task</xsl:attribute>
            </xsl:if>
              
             <!-- ROLEPLAY --> 
             <!-- covered by rule below  
             <xsl:if test="$start_page//title[@outputclass='roleplay']">
                <xsl:attribute name="class">roleplay</xsl:attribute>
             </xsl:if>  
              -->
                            
             <xsl:if test="$start_page//title[@outputclass]">
               <xsl:attribute name="class"><xsl:value-of select="$start_page//title/@outputclass"/></xsl:attribute>
             </xsl:if> 
              
              
              <xsl:value-of select="$title"/>
            </xsl:element>
          
            <xsl:apply-templates select="$start_page/topic/body/*|$start_page/task/taskbody/*">
              <xsl:with-param name="xml_filename" select="$xml_filename"/>
            </xsl:apply-templates>
          
          <!-- other xml files that make up this page -->
          <xsl:for-each select="topicref[position()>1]">
             <xsl:apply-templates select="document(@href)/*">
               <xsl:with-param name="xml_filename" select="$xml_filename"/>
             </xsl:apply-templates>
          </xsl:for-each>
          </div>
          
          <!-- video -->
          <xsl:for-each select="document(topicref/@href)//data[@name='video']">
            <xsl:if test="position()=1">
          <script type="text/javascript">
            $('video').mediaelementplayer();
          </script><xsl:text>
            </xsl:text>
            </xsl:if>
          </xsl:for-each>
          
        </body>
      </html>
    </xsl:result-document>
  </xsl:template>


<!-- file copying templates -->
 <xsl:template match="*[contains(@outputclass,'front_icon')]" mode="copy_icons">
 
   <xsl:param name="copy_file_script"/>
   <xsl:param name="xml_lib_path"/>
 
   <xsl:variable name="filename" select="concat(substring-after(@outputclass,'front_icon:'),'.png')"/>
   <xsl:variable name="filename_parent_dir" select="'icons'"/>
   <xsl:variable name="source_file" select="monkey:format_dir_slashes(concat($xml_lib_path,$filename_parent_dir,'/',$filename),$dir_forward_slash)"/>         
   <xsl:variable name="dest_file" select="monkey:format_dir_slashes(concat($destination_dir,'/IMAGES/',$filename),$dir_forward_slash)"/>
   <xsl:variable name="dest_dir" select="monkey:format_dir_slashes(concat($destination_dir,'/IMAGES'),$dir_forward_slash)"/>
   
   <xsl:variable name="command" select="concat($command_script,'&quot;',$copy_file_script,'&quot;',' ','&quot;',$source_file,'&quot;',' ',' &quot;',$dest_file,'&quot;',' ','&quot;',$dest_dir,'&quot;')" />
   
   <xsl:message>
     <xsl:value-of select="Runtime:exec(Runtime:getRuntime(),$command)" xmlns:Runtime="java:java.lang.Runtime"/>
   </xsl:message>
  
</xsl:template>
  




 
</xsl:stylesheet>
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


<!-- conf -->
<!-- current directory of doc map file -->
<xsl:param name="file_path" />
<xsl:param name="module"/>
  
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
  
  
  
<xsl:param name="scorm_path" select="monkey:get_path_subdir($file_path,$dir_forward_slash,'HTML')"/>
<xsl:param name="destination_dir" select="concat($scorm_path,monkey:get_path_dir_parent($file_path,$dir_forward_slash),monkey:format_dir_slashes(concat('/',$module,'-SCORM'),$dir_forward_slash))"/>
  


<!-- title and cover image -->
<xsl:param name="title" select="//topicgroup[1]/topicmeta/category/text()" />
<xsl:param name="img_URL" select="//topicgroup[1]/topicmeta/data[@name='img_cover']/@value" />
  


<!-- includes -->
<xsl:include href="utils.xsl" />  
<xsl:include href="quiz-utils.xsl"/>

<xsl:template match="map">
 
  <!-- if mac environment make NEW BATCH FILE -->
  <xsl:message>
    <xsl:if test="$mac_env">
      
      <xsl:value-of select="Runtime:exec(Runtime:getRuntime(),concat($mac_script,' start'))"
        xmlns:Runtime="java:java.lang.Runtime"/> 
      
    </xsl:if>
  </xsl:message>
 
 
   <!-- MAKE QUIZ LAUNCH PAGE -->
  <xsl:call-template name="launchmodule"/>
  
  <!-- MAKE JS QUESTIONS -->
  <xsl:call-template name="question_config">
    <xsl:with-param name="dir" select="concat($module,'-SCORM/JSCRIPT/')"/>
    <xsl:with-param name="js_file" select="'slickQuiz-config.js'"></xsl:with-param>
    <xsl:with-param name="xpath_topicref" select="topicgroup/topicref"/>
    <xsl:with-param name="results_message" select="'You have completed the Quiz !'"></xsl:with-param>
  </xsl:call-template>
   

  <!-- MAKE MANIFEST FILE -->
  <xsl:call-template name="manifest"/>
  
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
    
    <xsl:variable name="source_dir" select="concat($scorm_path,monkey:format_dir_slashes('ENGINE/LIBRARY-BASE/Quiz-multichoice',$dir_forward_slash))"/>
    
    <xsl:variable name="source_audio_dir" select="concat($scorm_path,monkey:format_dir_slashes('ENGINE/LIBRARY-BASE/AUDIO',$dir_forward_slash))"/>
    
    <xsl:variable name="source_video_dir" select="concat($scorm_path,monkey:format_dir_slashes('ENGINE/LIBRARY-BASE/VIDEO',$dir_forward_slash))"/>
    
    <xsl:variable name="command" select="concat($command_script,'&quot;',$copy_dir_files_script,'&quot;',' ','&quot;',$source_dir,'&quot;',' ','&quot;',$source_audio_dir,'&quot;',' ','&quot;',$source_video_dir,'&quot;',' ',' &quot;',$destination_dir,'&quot;',' ',monkey:get_1_0($dir_forward_slash))" />
    
    
    <!-- BASE IMAGES, CSS, JSCRIPT -->
    <xsl:message>
   
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
              <xsl:value-of select="Runtime:exec(Runtime:getRuntime(),$command)"
                xmlns:Runtime="java:java.lang.Runtime"/>
            </xsl:message>
          </xsl:if>
          
        </xsl:when>
        
        <xsl:otherwise>
          
          <!-- get images from topicref in doc map file -->
          <xsl:for-each select="topicref">
            
            <xsl:if test="contains(@outputclass,'header_img')">
            <xsl:variable name="filename" select="monkey:get_URL_filename(substring-after(@outputclass,'header_img:'))"/>
            
            
            <xsl:variable name="filename_parent_dir" select="monkey:get_URL_filename_parent_dir(substring-after(@outputclass,'header_img:'))"/>
            
            <xsl:variable name="source_file" select="monkey:format_dir_slashes(concat($xml_lib_path,$filename_parent_dir,'/',$filename),$dir_forward_slash)"/>
            
            <xsl:variable name="dest_file" select="monkey:format_dir_slashes(concat($destination_dir,'/IMAGES/',$filename),$dir_forward_slash)"/>
            
            <xsl:variable name="dest_dir" select="monkey:format_dir_slashes(concat($destination_dir,'/IMAGES'),$dir_forward_slash)"/>
       
            <xsl:variable name="command" select="concat($command_script,'&quot;',$copy_file_script,'&quot;',' ','&quot;',$source_file,'&quot;',' ',' &quot;',$dest_file,'&quot;',' ','&quot;',$dest_dir,'&quot;')" />
              
       
            <xsl:message>

              <xsl:value-of select="Runtime:exec(Runtime:getRuntime(),$command)"
                xmlns:Runtime="java:java.lang.Runtime"/>

            </xsl:message>

            </xsl:if>
            
          </xsl:for-each>
          
          
          
          
          
          <!-- get images from xml files -->
          <xsl:for-each select="document(topicref/@href)//image">
            <xsl:variable name="filename" select="monkey:get_URL_filename(@href)"/>
            <xsl:variable name="filename_parent_dir" select="monkey:get_URL_filename_parent_dir(@href)"/>
            
            <xsl:variable name="source_file" select="monkey:format_dir_slashes(concat($xml_lib_path,$filename_parent_dir,'/',$filename),$dir_forward_slash)"/>
            
            <xsl:variable name="dest_file" select="monkey:format_dir_slashes(concat($destination_dir,'/IMAGES/',$filename),$dir_forward_slash)"/>
            
            <xsl:variable name="dest_dir" select="monkey:format_dir_slashes(concat($destination_dir,'/IMAGES'),$dir_forward_slash)"/>
            <xsl:variable name="command" select="concat($command_script,'&quot;',$copy_file_script,'&quot;',' ','&quot;',$source_file,'&quot;',' ',' &quot;',$dest_file,'&quot;',' ','&quot;',$dest_dir,'&quot;')" />
            
            <xsl:message>

              <xsl:value-of select="Runtime:exec(Runtime:getRuntime(),$command)"
                xmlns:Runtime="java:java.lang.Runtime"/>

            </xsl:message>
            
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
              <xsl:value-of select="Runtime:exec(Runtime:getRuntime(),$command)"
                xmlns:Runtime="java:java.lang.Runtime"/>
            </xsl:message>
            
          </xsl:for-each>
          
          
          
          <!-- video -->
          
          
          
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
         <xsl:element name="title"><xsl:value-of select="title"/></xsl:element>
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
        
        <xsl:element name="dependency">
          <xsl:attribute name="identifierref">CSS</xsl:attribute>
        </xsl:element>
        
        <xsl:element name="dependency">
          <xsl:attribute name="identifierref">JSCRIPT</xsl:attribute>
        </xsl:element>
        
        <xsl:element name="dependency">
          <xsl:attribute name="identifierref">IMAGES</xsl:attribute>
        </xsl:element>
        
      </xsl:element><!-- resource -->
      
      <!-- CSS -->
      <xsl:element name="resource">
        <xsl:attribute name="identifier">CSS</xsl:attribute>
        <xsl:attribute name="type">webcontent</xsl:attribute>
        <xsl:attribute name="adlcp:scormtype">asset</xsl:attribute>
        
        <xsl:element name="file">
          <xsl:attribute name="href">CSS/base.css</xsl:attribute>
        </xsl:element>  
         
         <xsl:element name="file">
          <xsl:attribute name="href">CSS/master.css</xsl:attribute>
        </xsl:element>
        
        <xsl:element name="file">
          <xsl:attribute name="href">CSS/slickQuiz.css</xsl:attribute>
        </xsl:element>
        
      </xsl:element>
      
      
      <!-- JAVSCRIPT -->
      <xsl:element name="resource">
        <xsl:attribute name="identifier">JSCRIPT</xsl:attribute>
        <xsl:attribute name="type">webcontent</xsl:attribute>
        <xsl:attribute name="adlcp:scormtype">asset</xsl:attribute>
        <xsl:copy-of select="document('../LIBRARY-BASE/Quiz-multichoice/js_base_manifest.xml')/js_base_manifest/*" />
      </xsl:element>
      
      <!-- IMAGES -->
      <xsl:element name="resource">
        <xsl:attribute name="identifier">IMAGES</xsl:attribute>
        <xsl:attribute name="type">webcontent</xsl:attribute>
        <xsl:attribute name="adlcp:scormtype">asset</xsl:attribute>

        <!-- BASE -->
        <xsl:copy-of select="document('../LIBRARY-BASE/Quiz-multichoice/image_base_manifest-QUIZ.xml')/image_base_manifest/*" />

        <!-- images in xml files -->
        <xsl:for-each select="topicgroup">
          <xsl:choose>
            <xsl:when test="topicmeta/category">
              
              <!-- SECTION PAGE IMAGE -->
              <xsl:if test="topicmeta/data[@name='img_cover']/@value">
                <xsl:variable name="URL" select="topicmeta/data[@name='img_cover']/@value"/>
                <xsl:variable name="filename" select="monkey:get_URL_filename($URL)"/>
                <xsl:element name="file">
                  <xsl:attribute name="href">IMAGES/<xsl:value-of select="$filename"/></xsl:attribute>
                </xsl:element>
              </xsl:if>
            </xsl:when>
            
            <xsl:otherwise>
              
              <!-- get images from topicref in doc map file -->
              <xsl:for-each select="topicref">
                
                <xsl:if test="contains(@outputclass,'header_img')">
                  <xsl:variable name="filename" select="monkey:get_URL_filename(substring-after(@outputclass,'header_img:'))"/>
                  
                  <xsl:element name="file">
                    <xsl:attribute name="href">IMAGES/<xsl:value-of select="$filename"/></xsl:attribute>
                  </xsl:element>
                  
                </xsl:if>
                
              </xsl:for-each>
              
              
              <!-- get images from xml files -->
              <xsl:for-each select="document(topicref/@href)//image">
                <xsl:variable name="filename" select="monkey:get_URL_filename(@href)"/>
                <xsl:element name="file">
                  <xsl:attribute name="href">IMAGES/<xsl:value-of select="$filename"/></xsl:attribute>
                </xsl:element>
              </xsl:for-each>
 
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



      
    </xsl:element><!-- resources -->
  
  
<xsl:text disable-output-escaping='yes'>
&lt;/manifest></xsl:text>
</xsl:result-document>  
  
</xsl:template>  


<!-- launchmodule - contains quiz -->
<xsl:template name="launchmodule">
  <xsl:result-document href="{$module}-SCORM/HTML/launchmodule.html">
    
    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
    <xsl:text>
    </xsl:text>
    <xsl:apply-templates mode="tags" select="document('../LIBRARY-BASE/Quiz-multichoice/HTML/launchmodule-QUIZ.html')/*"/>
  </xsl:result-document>
</xsl:template>



<xsl:template match="div[@id='placeholder']" mode="tags"> 

  <!-- get filename -->
  <xsl:variable name="img-filename" select="monkey:get_URL_filename($img_URL)" />
  <xsl:variable name="path-and-image-filename" select="concat('../IMAGES/',$img-filename)" /> 

  <h1><xsl:value-of select="$title"></xsl:value-of></h1>
  <div class="section_img" style="background-image:url({$path-and-image-filename})"></div>
</xsl:template>
 
  
<xsl:template name="title_config">
  <xsl:param name="js_file"/>
  <xsl:param name="dir"/>
  <xsl:param name="xpath_topicref"/>
  <xsl:result-document href="{$dir}{$js_file}">

  <![CDATA[
  // GENERATED FILE
  //Set up Array to contain page links
  var Page_title = new Array();
  ]]>
  
    <xsl:for-each select="$xpath_topicref/document(@href)//topic|task">
      <xsl:variable name="title" select="title"/>
      <xsl:variable name="page_title" select="concat('Page_title[',position()-1,']','=','&quot;',$title,'&quot;')"/> 
      <xsl:value-of select="$page_title"/><xsl:text>;
      </xsl:text>
      

    
    </xsl:for-each>

  </xsl:result-document>
</xsl:template>  
  
  
</xsl:stylesheet>
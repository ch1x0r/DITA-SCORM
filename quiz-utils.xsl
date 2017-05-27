<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:adlcp="http://www.adlnet.org/xsd/adlcp_rootv1p2"  
                xmlns:date="http://exslt.org/dates-and-times"
                xmlns:monkey="http://monkeymediasoftware.com/monkeynamespace"
                exclude-result-prefixes="xsl adlcp date monkey"
                extension-element-prefixes="date"
                version="2.0"> 

 
<!-- Quiz Questions - js configuration file (one per quiz) -->

<xsl:template name="question_config">
<xsl:param name="js_file"/>
<xsl:param name="dir"/>
<xsl:param name="xpath_topicref"/>
  
<xsl:param name="results_message"/>
  <xsl:result-document href="{$dir}{$js_file}">
    
    <xsl:text>
 // GENERATED FILE
 var quizJSON = {
 "info": {
 "name":    "",
 "main":    "",
    "results": "</xsl:text><xsl:value-of select="$results_message"/><xsl:text>",
    "level1":  "Pass",
    "level2":  "Pass",
    "level3":  "Pass",
    "level4":  "Fail",
    "level5":  "Fail" // no comma here
    },
    </xsl:text>



    "questions":[
    <xsl:for-each select="$xpath_topicref">
      
        <!--
        <xsl:for-each select="document(@href)//body">
          <xsl:apply-templates select="p" mode="questions"/>
        </xsl:for-each>
         -->
       
      <xsl:variable name="section_title" select="document(@href)//title"/>
      
      
      <xsl:variable name="section_img">
      <xsl:choose>
        <xsl:when test="contains(@outputclass,'header_img:')">
          <xsl:value-of select="monkey:get_URL_filename(substring-after(@outputclass,'header_img:'))"/>
        </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'none'"/>
      </xsl:otherwise>
      </xsl:choose>
      </xsl:variable>
      
      
      <!-- *** TO CHANGE - this adds comma always, only working as it is adding comma to //End Question, -->
      <xsl:apply-templates select="document(@href)//body//p" mode="questions">
          <xsl:with-param name="add_comma" select="position()>1"/>
          <xsl:with-param name="section_title" select="$section_title"/>
          <xsl:with-param name="section_image" select="$section_img"></xsl:with-param>
      </xsl:apply-templates>
    </xsl:for-each>

    ]};
  </xsl:result-document>
  
</xsl:template>  

<!-- questions -->
<xsl:template match="p" mode="questions" >
  <xsl:param name="add_comma"/>
  <xsl:param name="section_title" />
  <xsl:param name="section_image"/>

  <!-- if these are questions from a file other than the 1st add a comma before the question -->
  <!-- each file processed does not leave a comma after the last question -->
  
  <xsl:if test="$add_comma = true()">
    <xsl:text>,
    </xsl:text>
  </xsl:if>
  
  <xsl:variable name="q" select="replace(normalize-space(text()),' ','SPACE')"/>
  <xsl:variable name="t" select="replace(normalize-space($section_title),' ','SPACE')"/>
  
  { //Question Start
  <!-- <xsl:if test="$section_image != 'none'">"section_img":"<xsl:value-of select="$section_image"/>",</xsl:if>-->
  "section_img":"<xsl:value-of select="$section_image"/>",
  "t": "<xsl:value-of select="$t"/>",
  "q":"<xsl:value-of select="$q"/>",<xsl:apply-templates mode="answers" select="following-sibling::ul[position()=1]"/>
  <xsl:apply-templates mode="answers" select="following-sibling::data[position()=1]"/>
  }<xsl:if test="following-sibling::p[position()=1]">, //Question End</xsl:if></xsl:template>

<!-- multiple choice answers -->
<xsl:template match="ul" mode="answers">
   "a": [ <xsl:for-each select="li">
     {"option": "<xsl:value-of select="replace(normalize-space(text()),' ','SPACE')"/>","correct":<xsl:choose><xsl:when test="data[@name='quiz']">true}</xsl:when><xsl:otherwise>false}</xsl:otherwise></xsl:choose><xsl:if test="following-sibling::li[position()=1]">,</xsl:if>
  </xsl:for-each>
   ],
</xsl:template>

<!-- quiz hints for incorrect answers -->
<xsl:template match="data" mode="answers">
  "correct":"Correct!",
  <xsl:choose>
    <xsl:when test="@name='quiz-hint'">
      <xsl:variable name="hint" select="replace(normalize-space(text()),' ','SPACE')"/>
       "incorrect":"<xsl:value-of select="$hint"/>"
    </xsl:when>
    <xsl:otherwise>
       "incorrect":"Incorrect"
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>   
  
</xsl:stylesheet>
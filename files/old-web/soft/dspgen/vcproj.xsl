<?xml version='1.0' encoding="ISO-8859-1" ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='1.0'>  
<xsl:output method="xml" encoding="Windows-1252" indent="yes" />
<xsl:key name="type" match="node()" use="node()" />


<!-- Process files. -->
<xsl:template match="file|source|header">
 <xsl:param name = "path" /> 
  <File>
   <xsl:attribute name="RelativePath">.<xsl:value-of select="$path" />\<xsl:value-of select="@name" /><xsl:value-of select="@ext" /></xsl:attribute>
  </File>
</xsl:template>

<!-- Process Directories 
   * Process any sub-directory containing any of the files we want (no empty dirs)
   * Process any file matching our 'type'
   
   Params :
    - path : the current path
    - type : the type of file we want to include in this directory (is the name of the element)
    - custom_name : the name to be used for this folder (used with tree tags).
    - fake : see the NB below
   
   NB : xsltproc has a bug the first time this template is called.
    So a quick'n dirty hack has been added, with the 'fake' param.
    This is used to parse the tree one time, without doing anything.
-->
<xsl:template match="dir|tree" name="dir">
 <xsl:param name = "path" /> 
 <xsl:param name = "type" /> 
 <xsl:param name = "custom_name" /> 
 <xsl:param name = "fake" /> 
 
 <!-- Update the path name -->
 <xsl:variable name="path_name">
   <xsl:value-of select="$path" />
   <xsl:if test="count(@name) != 0">\</xsl:if>
   <xsl:value-of select="@name" />
 </xsl:variable>

<xsl:choose>
 <xsl:when test="$fake != ''">
  <xsl:apply-templates select="dir[.//*[name(.)=$type]]" />
 </xsl:when>
 
 <xsl:otherwise>
     <!-- 
        Incredible but true, VS.Net do not accept Filter attribute 
         before the Name attibute !!
         (and that's another hour wasted!)
        As I am not able to do that, and as this attribute does not 
         seem to be mandatory, plonk!
     -->
 <Filter>
  <xsl:attribute name="Name"><xsl:if test="count(@name) != 0"><xsl:value-of select="@name" /><text> - </text></xsl:if><xsl:value-of select="$custom_name" /></xsl:attribute>
  <xsl:attribute name="Filter"></xsl:attribute>
 
  <!-- Include matching sub-directories -->
  <xsl:apply-templates select="dir[.//*[name(.)=$type]]">
   <xsl:with-param name="path" select="$path_name" />
   <xsl:with-param name="type" select="$type" />
   <xsl:with-param name="custom_name" select="$custom_name" />
  </xsl:apply-templates>
 
  <!-- Include Files -->
  <xsl:apply-templates select="*[name(.)=$type]">
   <xsl:with-param name="path" select="$path_name" />
  </xsl:apply-templates>

 </Filter>
                
 </xsl:otherwise>           
</xsl:choose>

</xsl:template>


<!-- Root template 

 * Open the document given in the @tree attribute, and process it contents
     with the @types attributes, with @basepath
 * Forward also some params (basically only fake)

 NB :  Well, the first run of Root seem to fail : 
   Root get the arguments, but fails to transmit them to 
    the element tree...
   Should be a problem of the parser, this "fake" is a workaround.

-->
<xsl:template match="Root">
 <xsl:param name="fake" />

<xsl:apply-templates select="document(@tree)/tree">
  <xsl:with-param name="type" select="@types" />
  <xsl:with-param name="custom_name" select="@name" />
  <xsl:with-param name="path" select="@basepath" />
  <xsl:with-param name="fake" select="$fake" />
</xsl:apply-templates>

</xsl:template>

<!-- Makefile template
 
  This is the entry point.
  Makefile.xml is the file containing build instruction (information about targets, options,...)
  This Makefile.xml will include an external (generated) file, generaly called tree.xml, 
   that contains the information about which files are to be compiled and integrated
   in the dsp.
 
-->
<xsl:template match="Makefile">
<!-- Header -->
<VisualStudioProject
	ProjectType="Visual C++"
	Version="7.00"
	Keyword="Win32Proj">
        <xsl:attribute name="Name"><xsl:value-of select="ProjectName" /></xsl:attribute>
        <xsl:attribute name="ProjectGUID"><xsl:value-of select="ProjectName/@GUID" /></xsl:attribute>
	
        <Platforms>
		<Platform Name="Win32"/>
	</Platforms>

<!-- List of targets -->
    <Configurations>

<xsl:for-each select="Targets/Target">

    <Configuration
        Name="Debug|Win32"
	ConfigurationType="1"
	CharacterSet="2">
        <xsl:attribute name="OutputDirectory"><xsl:value-of select="OutputDir" /></xsl:attribute>
        <xsl:attribute name="IntermediateDirectory"><xsl:value-of select="OutputDir" /></xsl:attribute>
	<Tool
            Name="VCCLCompilerTool"
            Optimization="0"
            PreprocessorDefinitions="WIN32;_DEBUG;_WINDOWS"
            MinimalRebuild="TRUE"
            BasicRuntimeChecks="3"
            RuntimeLibrary="5"
            UsePrecompiledHeader="3"
            WarningLevel="3"
            Detect64BitPortabilityProblems="TRUE"
            DebugInformationFormat="4"/>
	<Tool	Name="VCCustomBuildTool"/>
	<Tool	Name="VCLinkerTool"
            OutputFile="$(OutDir)/Blank.exe"
            LinkIncremental="2"
            GenerateDebugInformation="TRUE"
            ProgramDatabaseFile="$(OutDir)/Blank.pdb"
            SubSystem="2"
            TargetMachine="1"/>
	<Tool   Name="VCMIDLTool"/>
        <Tool   Name="VCPostBuildEventTool"/>
        <Tool  Name="VCPreBuildEventTool"/>
        <Tool Name="VCPreLinkEventTool"/>
        <Tool Name="VCResourceCompilerTool"/>
        <Tool Name="VCWebServiceProxyGeneratorTool"/>
        <Tool Name="VCWebDeploymentTool"/>
    </Configuration>
                
</xsl:for-each>

    </Configurations>

<!-- List of files -->
    
    <Files>

<xsl:apply-templates select="Roots/Root[1]">
 <xsl:with-param name="fake">fake</xsl:with-param>
</xsl:apply-templates>

<xsl:apply-templates select="Roots" />

    </Files>

<!-- Footer -->
    <Globals>
    </Globals>
</VisualStudioProject>

</xsl:template>

</xsl:stylesheet>
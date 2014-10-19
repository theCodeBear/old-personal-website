<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" version="5.0" encoding="UTF-8" indent="yes"/>

<!-- Main Template -->
<xsl:template match="/">
    <html>
    <head>
        <link rel="stylesheet" type="text/css"  href="xmlStyle.css"/>
    </head>
    <body>
        <xsl:apply-templates select="resume" />
        <br />
        <xsl:apply-templates select="resume/skills" />
        <br />
        <xsl:apply-templates select="resume/coursework" />
        <br />
        <xsl:apply-templates select="resume/workExperience" />
    </body>
    </html>
</xsl:template>


 <!-- Education -->
<xsl:template match="resume">
    <html>
    <head>
        <link rel="stylesheet" type="text/css"  href="xmlStyle.css"/>
    </head>
    <body>
        <h1> Education </h1>
        <xsl:for-each select="education">       <!-- for each school (<education>)-->
            <div class="notHeader">
                <h3><xsl:value-of select="school" /></h3>
                <div class="left">
                    <xsl:value-of select="major" />
                </div>
                <div class="right">
                    <xsl:text disable-output-escaping="yes">Graduation Date:&#160;</xsl:text>
                    <xsl:value-of select="graduationDate" />
                </div>
                <xsl:if test="gpa!=''">   <!-- if there is a GPA listed --> 
                    <div class="middle">
                        <xsl:text disable-output-escaping="yes">GPA:&#160;</xsl:text>
                        <xsl:value-of select="gpa" />
                    </div>
                </xsl:if>
            </div>
        </xsl:for-each>
    </body>
    </html>
</xsl:template>


 <!-- Technical Skills -->
<xsl:template match="resume/skills">
    <html>
    <head>
        <link rel="stylesheet" type="text/css"  href="xmlStyle.css"/>
    </head>
    <body>
        <h1> Technical Skills </h1>
        <div class="notHeader">
            <h3><xsl:text>Languages</xsl:text></h3>
            <xsl:for-each select="languages/child::*">      <!-- for each language -->
                <div class="columns">
                    <xsl:value-of select="self::*" />
                </div>
            </xsl:for-each>
            <br />
        </div>
        <div class="notHeader">
            <h3><xsl:text>Software</xsl:text></h3>
            <xsl:for-each select="software/child::*">       <!-- for each piece of software -->
                <div class="columns">
                    <xsl:value-of select="self::*" />
                </div>
            </xsl:for-each>
            <br />
        </div>
    </body>
    </html>
</xsl:template>


 <!-- Courses -->
<xsl:template match="resume/coursework">
    <html>
    <head>
        <link rel="stylesheet" type="text/css"  href="xmlStyle.css"/>
    </head>
    <body>
        <h1> Coursework </h1>
        <div class="notHeader">
            <xsl:for-each select="child::*">        <!-- for each course -->
                <div class="columns">
                    <xsl:value-of select="self::*" />
                </div>
            </xsl:for-each>
            <br />
        </div>
    </body>
    </html>
</xsl:template>


<!-- Work Experience -->
<xsl:template match="resume/workExperience">
    <html>
    <head>
        <link rel="stylesheet" type="text/css"  href="xmlStyle.css"/>
    </head>
    <body>
        <h1> Work History </h1>
        <xsl:for-each select="job">         <!-- for each job -->
            <div class="notHeader">
                <h3><xsl:value-of select="company" /></h3>
                <div class="right">
                    <strong>
                        <xsl:value-of select="startDate"/>
                        <xsl:text> - </xsl:text>
                        <xsl:value-of select="endDate" />
                    </strong>
                </div>
                <div class="left">
                    <strong><xsl:value-of select="position" /></strong>
                </div>
                <br />
                <div class="left">
                    <xsl:for-each select="duties">              <!-- for each job duty -->
                        <xsl:text disable-output-escaping="yes">-&#160;</xsl:text>
                        <xsl:value-of select="self::*" />
                        <br />
                    </xsl:for-each>
                </div>
                <br />
            </div>
        </xsl:for-each>
    </body>
    </html>
</xsl:template>


</xsl:stylesheet>
<?xml version='1.0' encoding="ISO-8859-1" ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='1.0'>  
<xsl:output method="html" encoding="ISO-8859-1" />

<!-- Main Template ============================ -->

<xsl:template match="echecs">
<html>
 <head>
  <title>Echecs</title>
 </head>
 <body>
 <h1><center>Problèmes</center></h1>
 <xsl:call-template name="toc" />
 <xsl:apply-templates />
 </body>
</html>
</xsl:template>

<!-- Problem Template ============================ -->

<xsl:template match="pb">
 <a>
  <xsl:attribute name="name"><xsl:value-of select="generate-id(current())" /></xsl:attribute>
  <h1><xsl:apply-templates select="desc" /></h1>
 </a>
 <p><xsl:apply-templates select="ech" /></p>
 <p><b>Réponse : </b><xsl:apply-templates select="rep" /></p>
 <p><b>Explication : </b><br /><xsl:apply-templates select="expl" /></p>
</xsl:template>

<!-- Ech Template ============================ -->

<xsl:template match="ech">
 <table border="1">
  <tr>
   <xsl:call-template name="piece"><xsl:with-param name="id">1</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">2</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">3</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">4</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">5</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">6</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">7</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">8</xsl:with-param></xsl:call-template>
  </tr>
  <tr>
   <xsl:call-template name="piece"><xsl:with-param name="id">9</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">10</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">11</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">12</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">13</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">14</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">15</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">16</xsl:with-param></xsl:call-template>
  </tr>
  <tr>
   <xsl:call-template name="piece"><xsl:with-param name="id">17</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">18</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">19</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">20</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">21</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">22</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">23</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">24</xsl:with-param></xsl:call-template>
  </tr>
  <tr>
   <xsl:call-template name="piece"><xsl:with-param name="id">25</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">26</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">27</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">28</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">29</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">30</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">31</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">32</xsl:with-param></xsl:call-template>
  </tr>
  <tr>
   <xsl:call-template name="piece"><xsl:with-param name="id">33</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">34</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">35</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">36</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">37</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">38</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">39</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">40</xsl:with-param></xsl:call-template>
  </tr>
  <tr>
   <xsl:call-template name="piece"><xsl:with-param name="id">41</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">42</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">43</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">44</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">45</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">46</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">47</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">48</xsl:with-param></xsl:call-template>
  </tr>
  <tr>
   <xsl:call-template name="piece"><xsl:with-param name="id">49</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">50</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">51</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">52</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">53</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">54</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">55</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">56</xsl:with-param></xsl:call-template>
  </tr>
  <tr>
   <xsl:call-template name="piece"><xsl:with-param name="id">57</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">58</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">59</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">60</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">61</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">62</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">63</xsl:with-param></xsl:call-template>
   <xsl:call-template name="piece"><xsl:with-param name="id">64</xsl:with-param></xsl:call-template>
  </tr>
 </table>
</xsl:template>

<xsl:template name="piece">
 <xsl:param name="id"> </xsl:param>
 <xsl:variable name="c" select="substring(text(),$id,1)" />
 <td>
 <xsl:choose>
  <xsl:when test="(($id + ((($id - 1) div 8) mod 2) + 1) mod 2) = (@decal mod 2)">
   <xsl:attribute name="bgcolor">#F0F0F0</xsl:attribute>
  </xsl:when>
  <xsl:otherwise>
   <xsl:attribute name="bgcolor">#707070</xsl:attribute>
  </xsl:otherwise>
 </xsl:choose>
 <xsl:choose> 
  <xsl:when test="$c='r'"><img src="r_b.gif" alt="Roi Blanc" /></xsl:when>
  <xsl:when test="$c='d'"><img src="d_b.gif" alt="Dame Blanche" /></xsl:when>
  <xsl:when test="$c='f'"><img src="f_b.gif" alt="Fou Blanc" /></xsl:when>
  <xsl:when test="$c='c'"><img src="c_b.gif" alt="Cavalier Blanc" /></xsl:when>
  <xsl:when test="$c='t'"><img src="t_b.gif" alt="Tour Blanche" /></xsl:when>
  <xsl:when test="$c='p'"><img src="p_b.gif" alt="Pion Blanc" /></xsl:when>
  <xsl:when test="$c='R'"><img src="r_n.gif" alt="Roi Noir" /></xsl:when>
  <xsl:when test="$c='D'"><img src="d_n.gif" alt="Dame Noire" /></xsl:when>
  <xsl:when test="$c='F'"><img src="f_n.gif" alt="Fou Noir" /></xsl:when>
  <xsl:when test="$c='C'"><img src="c_n.gif" alt="Cavalier Noir" /></xsl:when>
  <xsl:when test="$c='T'"><img src="t_n.gif" alt="Tour Noire" /></xsl:when>
  <xsl:when test="$c='P'"><img src="p_n.gif" alt="Pion Noir" /></xsl:when>
  <xsl:when test="$c='?'"><img src="question.gif" alt="Inconnue" /></xsl:when>
  <xsl:otherwise test="$c='P'"><img src="blank.gif" alt="Case" /></xsl:otherwise>
 </xsl:choose>
 </td>
</xsl:template>

<!-- Toc =================================== -->

<xsl:template name="toc">
 <xsl:for-each select="pb">
  <center>
  <a>
   <xsl:attribute name="href">#<xsl:value-of select="generate-id(current())" /></xsl:attribute>
   <xsl:apply-templates select="desc" />
  </a><br />
  </center>
 </xsl:for-each>
</xsl:template>

</xsl:stylesheet>


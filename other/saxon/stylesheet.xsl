<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" version="4.01" encoding="UTF-8" indent="yes" />
  <xsl:template match="/">
    <html lang="ja">
      <head />
      <body>
        <div><xsl:value-of select="count(student_list/student)" />人のデータ</div>

        <ul>
          <xsl:apply-templates select="student_list/student" />
        </ul>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="student">
    <li>
      <a><xsl:value-of select="name" /></a>
    </li>
  </xsl:template>
</xsl:stylesheet>

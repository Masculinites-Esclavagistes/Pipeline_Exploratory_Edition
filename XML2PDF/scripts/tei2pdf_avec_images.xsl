<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0">
    
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <!-- PARAMETRES -->
    <xsl:param name="images-path" select="'../../../data/'"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <meta charset="UTF-8"/>
                <title><xsl:value-of select="//tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/></title>
                <style>
                    * { margin: 0; padding: 0; box-sizing: border-box; }
                    
                    body { 
                        font-family: "Georgia", serif; 
                        display: flex;
                        margin: 0;
                        height: 100vh;
                        overflow: hidden;
                    }
                    
                    /* NAVIGATION LATERALE */
                    nav { 
                        width: 20%;
                        min-width: 200px;
                        padding: 20px;
                        background-color: #e7d9cb;
                        height: 100vh;
                        overflow-y: auto;
                        border-right: 2px solid #ca4c49;
                    }
                    
                    nav h3 { color: #ca4c49; margin-bottom: 15px; font-size: 14pt; }
                    nav ul { list-style: none; padding: 0; }
                    nav li { margin-bottom: 8px; padding-left: 15px; text-indent: -15px; }
                    nav li:before { content: "▸ "; color: #ca4c49; font-weight: bold; }
                    nav a { color: #333; text-decoration: none; font-weight: 500; }
                    nav a:hover { color: #ca4c49; text-decoration: underline; }
                    
                    /* CONTENU PRINCIPAL */
                    main { 
                        width: 80%;
                        padding: 20px;
                        height: 100vh;
                        overflow-y: auto;
                        background: #fff;
                    }
                    
                    h1 { color: #ca4c49; text-align: center; margin-bottom: 30px; font-size: 18pt; }
                    h2 { color: #ca4c49; border-bottom: 2px solid #e7d9cb; padding-bottom: 8px; margin: 40px 0 20px 0; font-size: 14pt; }
                    
                    /* BLOC PAGE AVEC IMAGE + TRANSCRIPTION */
                    .pb-block { 
                        display: flex;
                        gap: 20px;
                        margin-bottom: 40px;
                        padding: 15px;
                        background-color: #fdfcfb;
                        border: 1px solid #e7d9cb;
                        border-radius: 5px;
                    }
                    
                    .transcription { flex: 1; min-width: 0; }
                    .image-container { flex: 1; min-width: 0; display: flex; flex-direction: column; align-items: center; }
                    
                    .pb-block img { 
                        max-width: 100%;
                        max-height: 600px;
                        height: auto;
                        cursor: zoom-in;
                        border: 1px solid #e7d9cb;
                        box-shadow: 2px 2px 6px rgba(0,0,0,0.1);
                        border-radius: 3px;
                    }
                    
                    .pb-block img:hover { box-shadow: 4px 4px 12px rgba(0,0,0,0.2); }
                    
                    .image-link { margin-top: 5px; font-size: 8pt; color: #666; text-decoration: none; }
                    .image-link:hover { color: #ca4c49; }
                    
                    .transcription h3 { font-weight: bold; margin-bottom: 10px; font-size: 10pt; color: #ca4c49; font-family: "Courier New", monospace; }
                    .transcription p { white-space: pre-wrap; line-height: 1.2; font-size: 10pt; color: #222; }
                    
                    #credits { margin-top: 60px; padding: 20px; font-size: 9pt; color: #555; background-color: #f4ede7; border-radius: 5px; }
                    #credits p { margin-bottom: 8px; }
                    #credits strong { color: #ca4c49; }
                    #credits a { color: #ca4c49; text-decoration: none; }
                    #credits a:hover { text-decoration: underline; }
                    
                    /* RESPONSIVE */
                    @media (max-width: 1200px) {
                        .pb-block { flex-direction: column; }
                        .image-container { order: -1; }
                    }
                    
                    @media (max-width: 900px) {
                        body { flex-direction: column; }
                        nav { width: 100%; height: auto; max-height: 30vh; }
                        main { width: 100%; height: auto; }
                    }
                </style>
            </head>
            <body>
                
                <!-- NAVIGATION -->
                <nav>
                    <h3>Navigation</h3>
                    <ul>
                        <xsl:for-each select="//tei:div[@type='file']">
                            <li><a href="#{generate-id()}"><xsl:value-of select="replace(@corresp, '_', ' ')"/></a></li>
                        </xsl:for-each>
                    </ul>
                </nav>
                
                <!-- MAIN CONTENT -->
                <main>
                    <h1><xsl:value-of select="//tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/></h1>
                    
                    <xsl:for-each select="//tei:div[@type='file']">
                        <div class="file-section" id="{generate-id()}">
                            <h2><xsl:value-of select="replace(@corresp, '_', ' ')"/></h2>
                            
                            <xsl:for-each select="tei:pb">
                                <xsl:variable name="corresp" select="@corresp"/>
                                <xsl:variable name="folder" select="substring-before($corresp, '/')"/>
                                <xsl:variable name="imgfile" select="substring-after($corresp, '/')"/>
                                
                                <!-- Construction des chemins d'images avec .jpg et .JPG -->
                                <xsl:variable name="imgpathjpg" select="concat($images-path, $folder, '/', $imgfile, '.jpg')"/>
                                <xsl:variable name="imgpathJPG" select="concat($images-path, $folder, '/', $imgfile, '.JPG')"/>
                                
                                <div class="pb-block">
                                    <!-- TRANSCRIPTION -->
                                    <div class="transcription">
                                        <h3>
                                            <xsl:value-of select="replace($folder, '_', ' ')"/>
                                            <xsl:text> – </xsl:text>
                                            <xsl:value-of select="$imgfile"/>
                                        </h3>
                                        <p>
                                            <xsl:for-each select="following-sibling::*[not(self::tei:pb)][generate-id(preceding-sibling::tei:pb[1]) = generate-id(current())]">
                                                <xsl:apply-templates select="."/>
                                            </xsl:for-each>
                                        </p>
                                    </div>
                                    
                                    <!-- IMAGE -->
                                    <div class="image-container">
                                        <a href="{$imgpathjpg}" target="_blank">
                                            <img src="{$imgpathjpg}" alt="{$imgfile}" onerror="this.src='{$imgpathJPG}'"/>
                                        </a>
                                        <a href="{$imgpathjpg}" class="image-link" target="_blank">Ouvrir en plein écran ↗</a>
                                    </div>
                                </div>
                            </xsl:for-each>
                        </div>
                    </xsl:for-each>
                    
                    <!-- CREDITS -->
                    <div id="credits">
                        <p><strong>Citation :</strong> "MEGV Corpus: Selection of personnel files of colonial agents (COL E), Secrétariat d'Etat à la Marine, ANOM. FNS (n°219753), University of Geneva, dir. Marie Houllemare, [date of consultation]"</p>
                        <p><strong>Licence :</strong> CC BY-NC 4.0 - <a href="https://creativecommons.org/licenses/by-nc/4.0/deed.fr" target="_blank">https://creativecommons.org/licenses/by-nc/4.0/deed.fr</a></p>
                        <p><strong>Contact :</strong> <a href="mailto:marion.philip@unige.ch">marion.philip@unige.ch</a></p>
                    </div>
                </main>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="tei:lb"><br/></xsl:template>
    <xsl:template match="tei:*"><xsl:apply-templates select="node()"/></xsl:template>
    <xsl:template match="text()"><xsl:value-of select="replace(., '&amp;amp;', '&amp;')" disable-output-escaping="yes"/></xsl:template>
    
</xsl:stylesheet>

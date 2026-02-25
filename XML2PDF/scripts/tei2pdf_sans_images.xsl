<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0">
    
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <!-- PARAMETRES CONFIGURABLES -->
    <!-- Chemin relatif vers le dossier images depuis le HTML généré -->
    <xsl:param name="images-path" select="'../../../data/'"/>
    
    <!-- MAIN TEMPLATE -->
    <xsl:template match="/">
        <html>
            <head>
                <meta charset="UTF-8"/>
                <title>
                    <xsl:value-of select="//tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
                </title>
                <style>
                    /* CSS optimisé pour génération PDF */
                    * {
                        margin: 0;
                        padding: 0;
                        box-sizing: border-box;
                    }
                    
                    body { 
                        font-family: "Optima", "Georgia", serif; 
                        margin: 10mm;
                        line-height: 1.3;
                        color: #000;
                        font-size: 10pt;
                        background: #fff;
                    }
                    
                    /* TABLE DES MATIERES */
                    .toc {
                        page-break-after: always;
                        margin-bottom: 20px;
                        padding-bottom: 20px;
                        border-bottom: 2px solid #ca4c49;
                    }
                    
                    .toc h1 {
                        color: #ca4c49;
                        text-align: center;
                        margin-bottom: 20px;
                        font-size: 16pt;
                    }
                    
                    .toc h2 {
                        color: #ca4c49;
                        margin: 15px 0 10px 0;
                        font-size: 13pt;
                    }
                    
                    .toc ul {
                        list-style: none;
                        padding-left: 0;
                    }
                    
                    .toc li {
                        margin-bottom: 6px;
                        padding-left: 15px;
                        text-indent: -15px;
                    }
                    
                    .toc li:before {
                        content: "▸ ";
                        color: #ca4c49;
                        font-weight: bold;
                    }
                    
                    .toc a {
                        color: #333;
                        text-decoration: none;
                        font-weight: 500;
                    }
                    
                    .toc a:hover {
                        color: #ca4c49;
                        text-decoration: underline;
                    }
                    
                    /* CONTENU PRINCIPAL */
                    .file-section {
                        page-break-before: always;
                        margin-bottom: 30px;
                    }
                    
                    .back-to-top {
                        display: block;
                        text-align: right;
                        margin-bottom: 8px;
                        font-size: 8pt;
                        color: #666;
                        text-decoration: none;
                    }
                    
                    .back-to-top:hover {
                        color: #ca4c49;
                    }
                    
                    h2.file-title { 
                        color: #ca4c49;
                        border-bottom: 2px solid #e7d9cb;
                        padding-bottom: 8px;
                        margin: 0 0 20px 0;
                        font-size: 13pt;
                        page-break-after: avoid;
                    }
                    
                    /* BLOCS DOCUMENT */
                    .document-block { 
                        margin-bottom: 20px;
                        padding: 10px;
                        border-left: 3px solid #e7d9cb;
                        background-color: #fdfcfb;
                        page-break-inside: avoid;
                    }
                    
                    .document-header {
                        font-weight: bold;
                        margin-bottom: 8px;
                        font-size: 9pt;
                        color: #ca4c49;
                        font-family: "Courier New", monospace;
                    }
                    
                    .transcription-content { 
                        white-space: pre-wrap; 
                        line-height: 1.2;
                        font-size: 9pt;
                        font-family: "Georgia", serif;
                        color: #222;
                    }
                    
                    /* CREDITS */
                    #credits {
                        margin-top: 40px;
                        padding-top: 20px;
                        border-top: 2px solid #e7d9cb;
                        font-size: 8pt;
                        color: #666;
                        page-break-before: always;
                    }
                    
                    #credits p {
                        margin-bottom: 8px;
                    }
                    
                    #credits strong {
                        color: #ca4c49;
                    }
                    
                    #credits a {
                        color: #ca4c49;
                        text-decoration: none;
                    }
                    
                    /* STYLES POUR IMPRESSION/PDF */
                    @media print {
                        body { 
                            margin: 8mm;
                            font-size: 9pt;
                        }
                        
                        .toc {
                            page-break-after: always;
                        }
                        
                        .file-section {
                            page-break-before: always;
                        }
                        
                        .document-block {
                            page-break-inside: avoid;
                        }
                        
                        .back-to-top {
                            display: none;
                        }
                        
                        a {
                            color: #ca4c49 !important;
                        }
                        
                        #credits {
                            page-break-before: always;
                        }
                    }
                    
                    @page {
                        margin: 15mm;
                        
                        @bottom-right {
                            content: counter(page);
                            font-size: 8pt;
                            color: #666;
                        }
                    }
                </style>
            </head>
            <body>
                
                <!-- ANCRE POUR RETOUR -->
                <div id="toc-anchor"></div>
                
                <!-- TABLE DES MATIERES -->
                <div class="toc" id="toc">
                    <h1><xsl:value-of select="//tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/></h1>
                    <h2>Table des matières</h2>
                    <ul>
                        <xsl:for-each select="//tei:div[@type='file']">
                            <li>
                                <a href="#{generate-id()}">
                                    <xsl:value-of select="replace(@corresp, '_', ' ')"/>
                                </a>
                            </li>
                        </xsl:for-each>
                    </ul>
                </div>
                
                <!-- CONTENU PRINCIPAL -->
                <div class="main-content">
                    <xsl:for-each select="//tei:div[@type='file']">
                        <div class="file-section" id="{generate-id()}">
                            
                            <!-- Lien retour table des matières -->
                            <a href="#toc-anchor" class="back-to-top">↑ Retour à la table des matières</a>
                            
                            <!-- Titre du dossier/fichier -->
                            <h2 class="file-title">
                                <xsl:value-of select="replace(@corresp, '_', ' ')"/>
                            </h2>
                            
                            <!-- Traitement de chaque page (pb) -->
                            <xsl:for-each select="tei:pb">
                                <xsl:variable name="corresp" select="@corresp"/>
                                <xsl:variable name="folder" select="substring-before($corresp, '/')"/>
                                <xsl:variable name="imgfile" select="substring-after($corresp, '/')"/>
                                
                                <div class="document-block">
                                    <!-- En-tête du document avec cote et nom image -->
                                    <div class="document-header">
                                        <xsl:value-of select="replace($folder, '_', ' ')"/>
                                        <xsl:text> – </xsl:text>
                                        <xsl:value-of select="$imgfile"/>
                                    </div>
                                    
                                    <!-- Contenu de la transcription -->
                                    <div class="transcription-content">
                                        <xsl:for-each select="following-sibling::*[not(self::tei:pb)][generate-id(preceding-sibling::tei:pb[1]) = generate-id(current())]">
                                            <xsl:apply-templates select="."/>
                                        </xsl:for-each>
                                    </div>
                                </div>
                            </xsl:for-each>
                        </div>
                    </xsl:for-each>
                    
                    <!-- CREDITS ET CITATION -->
                    <div id="credits">
                        <p>
                            <strong>Citation recommandée :</strong><br/>
                            "MEGV Corpus: Selection of personnel files of colonial agents (COL E), 
                            Secrétariat d'Etat à la Marine, ANOM. 
                            FNS (n°219753), Université de Genève, dir. Marie Houllemare, 
                            [date de consultation]"
                        </p>
                        <p>
                            <strong>Licence :</strong> Creative Commons Attribution CC BY-NC 4.0<br/>
                            <a href="https://creativecommons.org/licenses/by-nc/4.0/deed.fr" target="_blank">
                                https://creativecommons.org/licenses/by-nc/4.0/deed.fr
                            </a>
                        </p>
                        <p>
                            <strong>Contact :</strong><br/>
                            Projet MEGV – Université de Genève<br/>
                            Code &amp; traitement des données : 
                            <a href="mailto:marion.philip@unige.ch">marion.philip@unige.ch</a>
                        </p>
                        <p>
                            <strong>Date de génération :</strong> 
                            <xsl:value-of select="format-date(current-date(), '[D01]/[M01]/[Y0001]')"/>
                        </p>
                    </div>
                </div>
                
            </body>
        </html>
    </xsl:template>
    
    <!-- GESTION DES SAUTS DE LIGNE -->
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>
    
    <!-- TEMPLATES PAR DEFAUT -->
    <xsl:template match="tei:*">
        <xsl:apply-templates select="node()"/>
    </xsl:template>
    
    <xsl:template match="@*">
        <xsl:copy/>
    </xsl:template>
    
    <!-- GESTION DU TEXTE : désencoder &amp; -->
    <xsl:template match="text()">
        <xsl:value-of select="replace(., '&amp;amp;', '&amp;')" disable-output-escaping="yes"/>
    </xsl:template>
    
</xsl:stylesheet>

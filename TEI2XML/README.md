# Pipeline-TEI2XML

This file contains the steps of the MEGV pipeline to transform the result of the inference of the corpuses of the project into XML-TEI files. The objective is to :
- delete the content of DigitizationArtefactZone and StampZone that are useless.
- compile all the .tei files resulting from the inference with a python script of the digital facsimiles of the archives per folder.
- correct these files and format them so that they are compatible with the XML format.
- compile all the .tei files obtained per folder into a single XML-TEI file containing the entire selected corpus.
- if this XML-TEI corpus file is too large to be displayed correctly by a browser, divide it using a python script into several XML-TEI files.
- From this XML-TEI file containing the selected corpus, obtain one or more HTML pages which will make it easier to consult the results for the first time, by carrying out a full-text search.

# 📁 Organisation of the pipeline files : 
```
 Pipeline_Exploratory_Edition/
   └── README.md

   └── data/                    ← Images
       ├── 175J10/              # Autres fonds
       └── Anne_1780_COL_E_5/   # ANOM
       
   └── TEI2XML/                                    ← Pipeline de transformation fichiers issus de l'OCR (.tei) en un unique fichier XML-TEI
       ├── README.md
       ├── tei_header.xml/                         ← Un modèle de teiHeader à compléter
       ├── 0_remove_artefact_zones.py/             
       ├── 1_clean_tei.py
       ├── 2_compile_tei_by_file.py                ← 0 à 5 : Scripts python
       ├── 3_correct_and_validate_tei.py           
       ├── 4_compile_files2corpus.py
       ├── 5_divide_xml.py
       └── output/
           ├── megv_corpus.xml                     ← fichier XML-TEI final                   
           └── parts/                              ← fichiers XML-TEI finaux si trop lourds

```
# 🚀 How to use 

To use this pipeline: 

- Add your inferred folders to "Pipeline_Exploratory_Edition/data". ⚠️ Be careful to add only a COPY of your files to data, not the original transcripts, which will be permanently modified after the pipeline is executed.

- If necessary, change the information contained in the ‘’Pipeline_Exploratory_Edition/TEI2XML/tei_header.xml‘’ file
    =>  <title> : Title of the corpus
    => <MsIdentifier> : Repository informations
    => <revisionDesc> : Name and date of the creation of the TEI P5 file
      
- in your Terminal :
  - activate a virtual environment such as yaltaienv, if you have installed the rtk environment on your computer.
  - go to "Pipeline_Exploratory_Edition/TEI2XML", then run the various scripts one after the other:

    0_remove_artefact_zones.py
      => Deletes the content of DigitizationArtefactZone and StampZone, preserve other zones ; converts MarginTextZone into <note place="margin"></note> ; normalizes <lb /> into <lb/>.

    1_clean_tei.py
      => Cleans the .tei file by removing all tags (except <note>), converts XML characters (& into "\&amp;" ; > into "\&gt;" ; < into "&lt" ; " into "\&quot;"; ' into "\&apos;"), and restructures by adding simple TEI tags like ‘‘\<p>‘‘.
    
    2_compile_tei_by_file.py
      => Group files by folder, creates a <pb/> tag corresponding to each image/file specifying the image path (folder/image) and the precise name of the corresponding .jpg file.

    3_correct_and_validate_tei.py
      => Adds namespace and standard TEI structure ; validates XML compliance
    
    4_compile_files2corpus.py
      -> Compile the complete corpus

    if necessary (more than 500 000 lines in your XML-TEI file will crash your HTML page) :
    
    6_divide_xml.py
      => Divide the corpus into manageable parts which are saved in "output/parts".

You should have one or more XML-TEI files created at the end of this first phase, in "Pipeline_Exploratory_Edition/TEI2XML/output".



## 📜 Licence

This pipeline was made with the help of ChatGPT and Claude IA, prompted and corrected by Marion Philip.

**Code** : Libre de réutilisation.

**Citation** :
```
Pipeline_Exploratory_Edition
Projet MEGV, FNS (n°219753), Université de Genève, dir. Marie Houllemare, [date de consultation]
```

---

## 📞 Contact

marion.philip@unige.ch  
Projet MEGV - Université de Genève  
FNS n°219753

**Version 2.0** - Février 2025

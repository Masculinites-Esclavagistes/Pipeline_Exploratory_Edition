# Pipeline_Exploratory_Edition

This repository contains the processing pipeline adapted to the needs of the MEGV project for handling OCR inference results from project corpora. The objective is to efficiently explore OCR results to select documents within large corpora, even with OCR noise, and produce a preliminary edition enabling full-text searches.

The pipeline:
- Compiles .tei inference files into a single XML-TEI file per corpus
- Transforms the resulting XML-TEI file into HTML and PDF formats

---

## 📁 Organization of Pipeline-MEGV Files

```
Pipeline_Exploratory_Edition/
├── README.md
├── Pipeline_Exploratory_Edition.xpr             ← Oxygen Project file

├── data/                                      ← Images (all corpora)
│   ├── 175J10/                                  # MEGV corpus
│   └── Anne_1780_COL_E_5/                       # ANOM corpus

├── TEI2XML/                                   ← OCR (.tei) to XML-TEI compilation pipeline
│   ├── README.md
│   ├── tei_header.xml                         ← TEI header template (to be completed)
│   ├── 0_remove_artefact_zones.py             ← Python scripts (0 to 6)
│   ├── 1_clean_tei.py
│   ├── 2_compile_tei_by_file.py 
│   ├── 3_correct_tei.py
│   ├── 4_validation_tei.py
│   ├── 5_compile_files2corpus.py
│   ├── 6_divide_xml.py
│   └── output/
│       ├── megv_corpus.xml                    ← Final XML-TEI file                   
│       └── parts/                             ← Split XML-TEI files (if too large)

└── XML2PDF/                                   ← XML-TEI to HTML/PDF transformation pipeline
    ├── README.md
    ├── data_xml/                              ← XML-TEI files from TEI2XML (copy here)
    ├── scripts/                               ← XSLT transformation scripts
    │   ├── tei2pdf_sans_images.xsl              # PDF without images
    │   ├── tei2pdf_avec_images.xsl              # HTML with images
    │   ├── scenario_sans_images.scenarios       # Oxygen scenario (PDF)
    │   └── scenario_avec_images.scenarios       # Oxygen scenario (HTML)
    └── output/
        ├── html/                              ← Generated HTML files
        └── pdf/                               ← Final PDF files
```

---

## 🚀 How to Use


### Workflow

#### 1. Prepare Your Data
Place all folders containing images and OCR results in the `data/` directory:
```
data/
├── [corpus_name_1]/
│   ├── image_001.jpg
│   └── ...
└── [corpus_name_2]/
    └── ...
```

#### 2. Compile OCR Results (TEI2XML)
Convert .tei files into a single XML-TEI file per corpus:
1. Navigate to `TEI2XML/`
2. Follow instructions in `TEI2XML/README.md`
3. Output: `TEI2XML/output/megv_corpus.xml`

#### 3. Transform to HTML/PDF (XML2PDF)
Convert the XML-TEI file into viewable formats:
1. Copy the XML-TEI file from `TEI2XML/output/` to `XML2PDF/data_xml/`
2. Navigate to `XML2PDF/`
3. Follow instructions in `XML2PDF/README.md`
4. Output: HTML and/or PDF files in `XML2PDF/output/`

---

## 📊 Supported Naming Conventions

The pipeline automatically detects two image naming systems:

### MEGV System
```
FRADML_175J10_Lx_SLx_Px_02955.jpg
│  │   │     │  │   │  └─ Unique ID (5 digits)
│  │   │     │  │   └──── Piece (P + number or Px)
│  │   │     │  └──────── Sub-bundle (SL + number or SLx)
│  │   │     └─────────── Bundle (L + number or Lx)
│  │   └───────────────── Shelf mark
│  └───────────────────── Archive repository code
└──────────────────────── Country code
```

### ANOM System
```
FRCAOM06_COLE_241007A_0650.jpg
│       │    │        └─ Unique ID (4 digits)
│       │    └────────── Microfilm shelf mark
│       └─────────────── Shelf mark
└─────────────────────── Country + institution code
```

Both systems support `.jpg` and `.JPG` extensions automatically.

---

## ✨ Key Features

### TEI2XML Pipeline
- Removes OCR artifacts
- Cleans and validates TEI files
- Compiles multiple .tei files into a single corpus
- Splits large files for better handling
- Validates against TEI P5 schema

### XML2PDF Pipeline
- **Two output formats:**
  - **PDF without images**: Lightweight, searchable, ideal for sharing
  - **HTML with images**: Side-by-side view of images and transcriptions
- Full-text search capability (Ctrl+F / Cmd+F)
- Clickable table of contents
- Automatic detection of MEGV/ANOM naming conventions
- Professional formatting with MEGV project colors

---

## 🔧 Technical Requirements

- **Python**: 3.7 or higher (for TEI2XML)
- **Oxygen XML Editor**: Any recent version (for XML2PDF)
- **Web Browser**: Modern browser for HTML viewing (Chrome, Firefox, Edge, Safari)
- **Disk Space**: Sufficient space for images and generated files

---

## 📝 Output Formats

### PDF (without images)
- Compact file size
- Full-text searchable
- Clickable navigation
- Ideal for preliminary research and sharing

### HTML (with images)
- Interactive interface
- Images displayed alongside transcriptions
- Fixed side navigation
- Zoom functionality on images
- Ideal for editing and verification work

---

## 🐛 Troubleshooting

### TEI2XML Issues
- Ensure all .tei files are in the correct directory
- Check Python version compatibility
- Verify TEI header template is properly configured

### XML2PDF Issues
- **Images not displaying**: Verify image paths in `data/` folder
- **Characters displaying incorrectly**: Ensure XML files are UTF-8 encoded
- **Transformation fails**: Check that Saxon is installed in Oxygen (default)

For detailed troubleshooting, see individual README files in each pipeline folder.

---

## 📜 License

This pipeline was developed with assistance from ChatGPT and Claude AI, prompted and refined by Marion Philip.

**Code**: Free to reuse and modify  

### Citation
```
Pipeline_Exploratory_Edition
MEGV Project, FNS (n°219753), University of Geneva, 
dir. Marie Houllemare, [consultation date]
```

---

## 📞 Contact & Support

**Email**: marion.philip@unige.ch  

---

## 🔄 Version History

**Version 2.0** - February 2025
- Added dual transformation system (with/without images)
- Automatic detection of MEGV and ANOM naming conventions
- Improved documentation structure
- Enhanced error handling

**Version 1.0** - Initial release
- Basic TEI2XML compilation
- PDF generation without images

---

## 🙏 Acknowledgments

This pipeline was developed as part of the MEGV project ("Masculinités esclavagistes. Genre et Violence dans la Caraïbe française au XVIIIe siècle"), funded by the Swiss National Science Foundation.

**Development**: Marion Philip (University of Geneva)  
**AI Assistance**: ChatGPT (OpenAI), Claude (Anthropic)  
**Project Direction**: Prof. Marie Houllemare  
**Institution**: University of Geneva, SNSF
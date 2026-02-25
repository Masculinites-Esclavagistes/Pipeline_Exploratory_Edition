da# Pipeline TEI vers PDF/HTML - Version 2.0

Pipeline de transformation XML-TEI avec **deux versions** :
- 📄 **Sans images** → PDF léger pour partager
- 🖼️ **Avec images** → HTML pour travailler

**Projet MEGV** - Université de Genève  
Contact : marion.philip@unige.ch

---

## 🚀 Démarrage rapide

### 1. Organiser vos données

```
   Pipeline_MEGV/
   └── data/                    ← Images
       ├── 175J10/              # Côtes autres fonds
       └── Anne_1780_COL_E_5/   # ANOM
       
   └── XML2PDF/
       ├── data_xml/            ← Vos fichiers XML-TEI créés avec TEI2XML
       ├── scripts/             ← Scripts XSLT
       └── output/
           ├── html/            ← HTML générés
           └── pdf/             ← PDF finaux
```
### 2. Importer les scénarios Oxygen
1. Ouvrir son fichier XML-TEI ou le projet Pipeline_MEGV.xpr avec **Oxygen XML Editor**
2. **Document** → **Transformation** → **Configurer les scénarios**
3. **Importer** `scripts/scenario_sans_images.scenarios`
4. **Importer** `scripts/scenario_avec_images.scenarios`

### 3. Transformer

#### PDF sans images (pour partager)
1. Ouvrir XML dans Oxygen
2. **Ctrl+Shift+T** → **"TEI vers PDF (sans images)"**
3. Dans le navigateur : **Ctrl+P** → **Enregistrer en PDF**

#### HTML avec images (pour travailler)
1. Ouvrir XML dans Oxygen
2. **Ctrl+Shift+T** → **"TEI vers HTML (avec images)"**
3. ✅ Consulter directement !

---

## 📊 Systèmes de nommage supportés

Les scripts détectent **automatiquement** :

**MEGV** : `FRADML_175J10_Lx_SLx_Px_02955.jpg`
```xml
<pb corresp="175J10/FRADML_175J10_Lx_SLx_Px_02955"/>
```

**ANOM** : `FRCAOM06_COLE_241007A_0650.jpg`
```xml
<pb corresp="Anne_1780_COL_E_5/FRCAOM06_COLE_241007A_0650"/>
```

Extensions gérées : `.jpg` et `.JPG` (automatique)

---

## 🎯 Quelle version utiliser ?

| Besoin | Version |
|--------|---------|
| Partager avec collègues | **Sans images** (PDF) |
| Vérifier transcriptions | **Avec images** (HTML) |
| Recherches préliminaires | **Sans images** (PDF) |
| Travail d'édition | **Avec images** (HTML) |

---

## ✨ Caractéristiques

### PDF sans images
- Table des matières cliquable
- Recherche plein texte (Ctrl+F)
- Navigation par sections
- Léger et rapide

### HTML avec images
- Navigation latérale fixe
- Images côte à côte avec transcriptions
- Zoom sur images (clic)
- Interface professionnelle

---

## 🔧 Configuration

### Modifier le chemin des images
Dans les fichiers XSLT :
```xml
<xsl:param name="images-path" select="'../../../data/'"/>
```

### Personnaliser les couleurs
Dans la section `<style>` des fichiers XSLT :
```css
color: #ca4c49;  /* Couleur principale */
background-color: #e7d9cb;  /* Couleur secondaire */
```

---

## 🐛 Dépannage

**Les images ne s'affichent pas** (version avec images)
→ Vérifier chemin : `data/images/[dossier]/[nom_image].jpg`  
→ Le script essaie automatiquement `.jpg` puis `.JPG`

**Caractères bizarres**
→ Vérifier encodage UTF-8 du XML

**Scénario ne fonctionne pas**
→ Saxon doit être installé dans Oxygen (par défaut il l'est)

---

## 📜 Licence

**Code** : Libre de réutilisation  
**Corpus** : CC BY-NC 4.0

**Citation** :
```
MEGV Corpus
FNS (n°219753), Université de Genève, dir. Marie Houllemare, [date de consultation]
```

---

## 📞 Contact

marion.philip@unige.ch  
Projet MEGV - Université de Genève  
FNS n°219753

**Version 2.0** - Février 2025

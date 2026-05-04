import os
from lxml import etree
from pathlib import Path

# Dossier où se trouvent les fichiers
script_dir = Path(__file__).parent
base_folder = script_dir.parent / "data"

invalid_files = []

def correct_and_validate_tei_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # --- Correction ---
    if '<TEI>' in content:
        content = content.replace('<TEI>', '<TEI xmlns="http://www.tei-c.org/ns/1.0">')

    if '<body>' in content and '<text>' not in content:
        content = content.replace('<body>', '<text>\n<body>', 1)
        content = content.replace('</body>', '</body>\n</text>', 1)

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f"✅ Corrigé  : {file_path}")

    # --- Validation immédiate ---
    try:
        with open(file_path, 'rb') as f:
            etree.parse(f)
        print(f"   ✔ Valide  : {file_path}")
    except Exception as e:
        print(f"   ❌ Invalide : {file_path}\n      ↪︎ {e}")
        invalid_files.append(file_path)

# Parcours récursif
for root, dirs, files in os.walk(base_folder):
    for file in files:
        if file.endswith(".tei"):
            correct_and_validate_tei_file(os.path.join(root, file))

# Résumé
print("\n--- Résumé ---")
if not invalid_files:
    print("✅ Tous les fichiers .tei sont bien formés.")
else:
    print(f"⚠️  {len(invalid_files)} fichier(s) mal formé(s) :")
    for f in invalid_files:
        print(f"   • {f}")

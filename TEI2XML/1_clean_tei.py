import os
import re
from pathlib import Path

# Dossier racine des fichiers TEI
script_dir = Path(__file__).parent
root_dir = script_dir.parent / "data"
log_path = "log_cleaning.txt"

def escape_xml_text(text):
    """
    Échappe les caractères spéciaux XML dans du texte brut.
    & doit être traité en un seul passage pour éviter le double-encodage.
    """
    text = text.replace("&", "&amp;")
    return text

def clean_tei_file(file_path):
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            content = f.read()

        # ---------------------------------------------------------------
        # Étape 1 : extraire et mettre de côté les <note place="margin">
        # AVANT toute autre opération, sur le contenu complet du fichier.
        # Les notes peuvent s'étendre sur plusieurs lignes, c'est pourquoi
        # on les protège ici avec re.DOTALL, avant le traitement ligne à ligne.
        # ---------------------------------------------------------------
        notes = {}
        counter = [0]

        def store_note(m):
            key = f"__NOTE_{counter[0]}__"
            # Normaliser les <lb /> en <lb/> dans la note
            note_content = re.sub(r'<lb\s*/>', '<lb/>', m.group(0))
            notes[key] = note_content
            counter[0] += 1
            return f"\n{key}\n"  # on la met sur sa propre ligne pour la retrouver

        content = re.sub(
            r'<note place="margin">.*?</note>',
            store_note,
            content,
            flags=re.DOTALL
        )

        # ---------------------------------------------------------------
        # Étape 2 : traiter ligne par ligne
        # ---------------------------------------------------------------
        cleaned_lines = []
        for line in content.splitlines():
            raw = line.strip()
            if not raw:
                continue

            # Si c'est un placeholder de note, le restituer tel quel
            if raw.startswith("__NOTE_") and raw.endswith("__"):
                note_content = notes.get(raw, "")
                if note_content:
                    cleaned_lines.append(note_content)
                continue

            # Supprimer toutes les balises XML (sauf les placeholders déjà traités)
            text = re.sub(r"</?[^>]+>", "", raw)

            if not text.strip():
                continue

            # Échapper les caractères XML dans le texte brut
            text = escape_xml_text(text)

            # <lb/> en DÉBUT de ligne
            cleaned_lines.append(f"<lb/>{text}")

        final_text = "<p>\n" + "\n".join(cleaned_lines) + "\n</p>"

        with open(file_path, "w", encoding="utf-8") as f:
            f.write(final_text)

        return f"[OK] Nettoyé : {file_path}"

    except Exception as e:
        return f"[ERREUR] {file_path} — {str(e)}"

def clean_all_tei_files():
    log_entries = []
    for dirpath, _, filenames in os.walk(root_dir):
        for filename in filenames:
            if filename.endswith(".tei"):
                file_path = os.path.join(dirpath, filename)
                log_entries.append(clean_tei_file(file_path))

    with open(log_path, "w", encoding="utf-8") as log_file:
        log_file.write("\n".join(log_entries))

    print(f"✅ Traitement terminé. Log disponible dans : {log_path}")

if __name__ == "__main__":
    clean_all_tei_files()

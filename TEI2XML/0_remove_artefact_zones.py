import os
import re
from pathlib import Path

# Dossier racine des fichiers TEI originaux
script_dir = Path(__file__).parent
root_dir = script_dir.parent / "data"
log_path = "log_zone_removal.txt"

def convert_margin_zones(content):
    """
    Convertit les <div type='MarginTextZone'> en <note place="margin">texte</note>
    au lieu de les supprimer. Le texte interne est extrait proprement.
    """
    # Gère guillemets simples et doubles
    patterns = [
        r"<div type='MarginTextZone'>(.*?)</div>",
        r'<div type="MarginTextZone">(.*?)</div>',
    ]
    for pattern in patterns:
        def replace_margin(m):
            inner = m.group(1)
            # Extraire le texte des <seg> en conservant les <lb/>
            # On supprime les balises <seg> mais on garde le contenu
            inner = re.sub(r'<seg>', '', inner)
            inner = re.sub(r'</seg>', '', inner)
            # Normaliser les <lb /> en <lb/>
            inner = re.sub(r'<lb\s*/>', '<lb/>', inner)
            # Supprimer les autres balises éventuelles
            inner = re.sub(r'<(?!lb/)[^>]+>', '', inner)
            inner = inner.strip()
            if inner:
                return f'<note place="margin">{inner}</note>'
            return ''
        content = re.sub(pattern, replace_margin, content, flags=re.DOTALL)
    return content

def remove_artefact_zones(file_path):
    """
    - Supprime les <div type='DigitizationArtefactZone'> et <div type='StampZone'>
    - Convertit les <div type='MarginTextZone'> en <note place="margin">…</note>
    """
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()

        original_content = content
        zones_removed = 0

        # 1. Convertir les MarginTextZone en <note place="margin">
        content = convert_margin_zones(content)

        # 2. Supprimer les zones inutiles
        patterns_to_remove = [
            r"<div type='DigitizationArtefactZone'>.*?</div>",
            r"<div type='StampZone'>.*?</div>",
            r'<div type="DigitizationArtefactZone">.*?</div>',
            r'<div type="StampZone">.*?</div>',
        ]
        for pattern in patterns_to_remove:
            matches = re.findall(pattern, content, re.DOTALL)
            zones_removed += len(matches)
            content = re.sub(pattern, '', content, flags=re.DOTALL)

        # Nettoyer les lignes vides multiples
        content = re.sub(r'\n\s*\n\s*\n+', '\n\n', content)

        if content != original_content:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            return f"[OK] {file_path} → {zones_removed} zone(s) supprimée(s), MarginTextZone converties"
        else:
            return f"[SKIP] {file_path} → Aucune zone à traiter"

    except Exception as e:
        return f"[ERREUR] {file_path} → {str(e)}"

def inspect_file_structure(file_path):
    """Inspecte la structure d'un fichier pour debug"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()

        print(f"\n{'='*70}")
        print(f"📄 Inspection : {os.path.basename(file_path)}")
        print(f"{'='*70}")

        div_types = re.findall(r"<div type=['\"]([^'\"]+)['\"]>", content)
        if div_types:
            from collections import Counter
            type_counts = Counter(div_types)
            print(f"🔍 Types de <div> trouvés ({len(div_types)} total) :")
            for div_type, count in sorted(type_counts.items()):
                marker = "🎯" if div_type in ['DigitizationArtefactZone', 'StampZone', 'MarginTextZone'] else "  "
                print(f"  {marker} {div_type}: {count}")
        else:
            print("⚠️  Aucun <div type='...'> trouvé")

        print("\n📝 Extrait du fichier (300 premiers caractères):")
        print("-" * 70)
        print(content[:300])
        print("...")
        print("-" * 70)

    except Exception as e:
        print(f"❌ Erreur d'inspection : {e}")

def remove_zones_from_all_files():
    """Parcours récursif des fichiers .tei"""
    log_entries = []
    total_files = 0
    processed_files = 0
    total_zones = 0

    all_files = []
    for dirpath, _, filenames in os.walk(root_dir):
        for filename in filenames:
            if filename.endswith(".tei"):
                all_files.append(os.path.join(dirpath, filename))

    print("🔍 INSPECTION DE LA STRUCTURE DES FICHIERS")
    print("="*70)
    sample_files = all_files[:5] if len(all_files) >= 5 else all_files
    for sample_file in sample_files:
        inspect_file_structure(sample_file)

    input("\n⏸️  Appuyez sur Entrée pour continuer le traitement...")

    print("\n\n🔄 TRAITEMENT DE TOUS LES FICHIERS")
    print("="*70)

    for file_path in all_files:
        total_files += 1
        result = remove_artefact_zones(file_path)
        log_entries.append(result)
        if "[OK]" in result:
            print(result)
            processed_files += 1
            match = re.search(r'(\d+) zone\(s\)', result)
            if match:
                total_zones += int(match.group(1))
        elif "[ERREUR" in result:
            print(result)

    with open(log_path, "w", encoding="utf-8") as log_file:
        log_file.write("\n".join(log_entries))

    print("\n" + "="*70)
    print("📊 RÉSUMÉ FINAL")
    print("="*70)
    print(f"📁 Fichiers analysés      : {total_files}")
    print(f"✅ Fichiers modifiés      : {processed_files}")
    print(f"⏭️  Fichiers ignorés       : {total_files - processed_files}")
    print(f"🧹 Total zones supprimées : {total_zones}")
    print(f"📝 Log sauvegardé dans    : {log_path}")
    print("="*70)

if __name__ == "__main__":
    remove_zones_from_all_files()

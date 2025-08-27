import os
import subprocess
import argparse
from pyfiglet import figlet_format

excluded_dirs = ["venv", "__pycache__"]


def traiter_flux(url):
    # Ton traitement ici
    pass


def compile_file(file_path):
    try:
        subprocess.run(["python", "-m", "py_compile", file_path], check=True)
        print(f"✅ Compilation OK : {file_path}")
    except subprocess.CalledProcessError:
        print(f"❌ Erreur de compilation : {file_path}")


def scan_repository(repo_path):
    print(figlet_format("Blackbird Scan", font="slant"))
    print(f"[Blackbird] Analyse du dépôt : {repo_path}\n")
    for root, dirs, files in os.walk(repo_path):
        dirs[:] = [d for d in dirs if d not in excluded_dirs]
        for file in files:
            if file.endswith(".py"):
                full_path = os.path.join(root, file)
                print(f"→ {full_path}")
                compile_file(full_path)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("repo", help="Chemin du dépôt à analyser")
    parser.add_argument("--quiet", action="store_true", help="Mode silencieux")
    args = parser.parse_args()

    repo_path = args.repo
    scan_repository(repo_path)

    count = 0
    for root, dirs, files in os.walk(repo_path):
        dirs[:] = [d for d in dirs if d not in excluded_dirs]
        for file in files:
            if file.endswith(".py"):
                count += 1
                file_path = os.path.join(root, file)
                try:
                    subprocess.run(["python", file_path], check=True)
                except subprocess.CalledProcessError as e:
                    print(f"❌ Erreur de compilation : {file_path}")
                    print(f"🧾 Détails : {e}")

    print(f"\n🔍 Total de fichiers analysés : {count}")


if __name__ == "__main__":
    main()

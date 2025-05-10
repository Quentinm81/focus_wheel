import sys
import os
import time
import threading
import subprocess
from datetime import datetime
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler, FileSystemEvent

DEBOUNCE_SECONDS = 5
PID_FILE = "auto_sync.pid"  # Nom du fichier pour stocker le PID

class GitAutoSyncHandler(FileSystemEventHandler):
    def __init__(self, repo_path):
        self.repo_path = repo_path
        self.debounce_timer = None
        self.lock = threading.Lock()
        self.event_detected = False

    def on_any_event(self, event: FileSystemEvent):
        # Ignorer le répertoire .git et le fichier PID lui-même
        rel_path = os.path.relpath(event.src_path, self.repo_path)
        if rel_path.startswith('.git') or rel_path == PID_FILE:
            return
        with self.lock:
            self.event_detected = True
            if self.debounce_timer:
                self.debounce_timer.cancel()
            self.debounce_timer = threading.Timer(DEBOUNCE_SECONDS, self.sync_changes)
            self.debounce_timer.start()
            print(f"[INFO] Changement détecté : {rel_path} (synchronisation dans {DEBOUNCE_SECONDS}s)")

    def sync_changes(self):
        with self.lock:
            self.event_detected = False
        print("[INFO] Synchronisation automatique en cours...")
        try:
            subprocess.run(['git', 'add', '-A'], cwd=self.repo_path, check=True, capture_output=True)
            print("[INFO] git add -A effectué.")
            now = datetime.now().strftime("%Y-%m-%d %H:%M")
            commit_msg = f"auto-sync: {now}"
            result = subprocess.run(['git', 'commit', '-m', commit_msg], cwd=self.repo_path, capture_output=True, text=True)
            
            # Vérifier s'il y avait quelque chose à committer de manière plus robuste
            commit_output = result.stdout.lower()
            if "nothing to commit" in commit_output or "aucun changement ajouté à la validation" in commit_output or "rien à valider" in commit_output:
                print("[INFO] Aucun changement à committer.")
                return

            # Si le code de retour n'est pas 0 et qu'il ne s'agit pas d'un message "nothing to commit"
            if result.returncode != 0:
                raise subprocess.CalledProcessError(result.returncode, result.args, output=result.stdout, stderr=result.stderr)
            
            print(f"[INFO] Commit effectué : {commit_msg}")
            
            subprocess.run(['git', 'push'], cwd=self.repo_path, check=True, capture_output=True)
            print("[INFO] Push effectué avec succès.")
        except subprocess.CalledProcessError as e:
            print(f"[ERREUR] Commande Git échouée : {e.cmd}")
            print(f"[ERREUR] Code retour : {e.returncode}")
            # S'assurer que stdout et stderr sont bien décodés
            stdout_decoded = e.stdout.decode('utf-8', errors='ignore') if isinstance(e.stdout, bytes) else e.stdout
            stderr_decoded = e.stderr.decode('utf-8', errors='ignore') if isinstance(e.stderr, bytes) else e.stderr
            if stdout_decoded:
                print(f"[ERREUR] Sortie : {stdout_decoded}")
            if stderr_decoded:
                print(f"[ERREUR] Erreur : {stderr_decoded}")
        except Exception as e:
            print(f"[ERREUR] Une erreur inattendue est survenue pendant sync_changes: {e}")


def main():
    if len(sys.argv) != 2:
        print("Usage : python auto_sync.py /chemin/vers/repo")
        sys.exit(1)

    # Écrire le PID dans un fichier
    pid = os.getpid()
    try:
        with open(PID_FILE, "w") as f:
            f.write(str(pid))
    except IOError as e:
        print(f"[ERREUR] Impossible d'écrire le fichier PID {PID_FILE}: {e}")
        # Continuer même si le PID ne peut être écrit, mais le script de vérification pourrait échouer à tuer le processus
    
    repo_path = os.path.abspath(sys.argv[1])
    if not os.path.isdir(repo_path):
        print(f"[ERREUR] Le chemin spécifié n'est pas un dossier : {repo_path}")
        sys.exit(1)
    if not os.path.isdir(os.path.join(repo_path, '.git')):
        print(f"[ERREUR] Le dossier spécifié n'est pas un dépôt Git : {repo_path}")
        sys.exit(1)
        
    print(f"[INFO] Démarrage de la surveillance du dépôt : {repo_path}")
    event_handler = GitAutoSyncHandler(repo_path)
    observer = Observer()
    observer.schedule(event_handler, repo_path, recursive=True)
    observer.start()
    print(f"[INFO] Surveillance active (PID: {pid}). Appuyez sur Ctrl+C pour arrêter.")
    
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("\n[INFO] Arrêt de la surveillance demandé par l'utilisateur...")
    except Exception as e:
        print(f"\n[ERREUR] Erreur inattendue dans la boucle principale: {e}")
    finally:
        print("[INFO] Arrêt de l'observateur de fichiers...")
        observer.stop()
        observer.join()
        print("[INFO] Observateur arrêté.")
        # Supprimer le fichier PID à la fin
        if os.path.exists(PID_FILE):
            try:
                os.remove(PID_FILE)
                print(f"[INFO] Fichier PID {PID_FILE} supprimé.")
            except OSError as e:
                print(f"[ERREUR] Impossible de supprimer le fichier PID {PID_FILE}: {e}")

if __name__ == "__main__":
    main()

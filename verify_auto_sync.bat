@echo off
setlocal

REM Chemin vers le fichier PID
set PID_FILE=auto_sync.pid
set LOG_FILE=verify.log
set TEST_FILE=test-sync.txt

REM 1. Vérifier auto_sync.py
echo [VERIFY] Vérification de auto_sync.py...
if not exist auto_sync.py (
  echo FAIL (auto_sync.py manquant)
  exit /b 1
)
echo [VERIFY] auto_sync.py trouvé.

REM 2. Vérifier .vscode\tasks.json et le label
echo [VERIFY] Vérification de .vscode\tasks.json...
if not exist .vscode\tasks.json (
  echo FAIL (.vscode/tasks.json manquant)
  exit /b 1
)
findstr /C:"\"label\": \"Auto Sync Git\"" .vscode\tasks.json >nul
if errorlevel 1 (
  echo FAIL (tâche Auto Sync Git absente dans .vscode\tasks.json)
  exit /b 1
)
echo [VERIFY] .vscode\tasks.json et tâche trouvés.

REM Nettoyer les anciens fichiers de log et PID s'ils existent
echo [VERIFY] Nettoyage des anciens fichiers (log, pid, test)...
del %LOG_FILE% >nul 2>&1
del %PID_FILE% >nul 2>&1
del %TEST_FILE% >nul 2>&1

REM 3. Lancer auto_sync.py en arrière-plan
echo [VERIFY] Lancement de auto_sync.py en arrière-plan vers %LOG_FILE%...
start "AutoSyncPy" /B cmd /c "python auto_sync.py . > %LOG_FILE% 2>&1"

REM Attendre un peu que le script démarre et crée le fichier PID
echo [VERIFY] Attente du démarrage de auto_sync.py et de la création de %PID_FILE% (max 10s)...
set count=0
:wait_pid
if %count% geq 10 ( 
  echo FAIL (Timeout en attente de %PID_FILE% après 10s)
  echo [VERIFY] Contenu actuel de %LOG_FILE% (s'il existe):
  if exist %LOG_FILE% type %LOG_FILE%
  echo [VERIFY] Tentative d'arrêt des processus python.exe...
  taskkill /IM python.exe /F >nul 2>&1
  exit /b 1
)
if not exist %PID_FILE% (
  timeout /t 1 /nobreak >nul
  set /a count+=1
  echo [VERIFY] Attente... (%count%/10)
  goto :wait_pid
)
echo [VERIFY] Fichier %PID_FILE% trouvé.

REM Lire le PID depuis le fichier
set /p SYNC_PID=<%PID_FILE%
echo [VERIFY] PID de auto_sync.py: %SYNC_PID%

REM 4. Créer test-sync.txt
echo [VERIFY] Création de %TEST_FILE%...
echo test auto sync %TIME% > %TEST_FILE%

REM 5. Attendre (debounce + traitement)
echo [VERIFY] Attente de 6 secondes pour la synchronisation Git...
timeout /t 6 /nobreak >nul

REM Tuer proprement le processus d'auto_sync.py en utilisant le PID
echo [VERIFY] Arrêt de auto_sync.py (PID: %SYNC_PID%)...
if defined SYNC_PID (
  taskkill /PID %SYNC_PID% /T /F >nul 2>&1
  if errorlevel 0 (
    echo [VERIFY] Processus %SYNC_PID% et ses enfants arrêtés.
  ) else (
    echo [VERIFY] Avertissement: Impossible de tuer le processus %SYNC_PID% (code d'erreur %errorlevel%). Il était peut-être déjà arrêté.
  )
) else (
  echo [VERIFY] Avertissement: PID non défini dans %PID_FILE%. Tentative d'arrêt de tous les python.exe.
  taskkill /IM python.exe /F >nul 2>&1
)

REM Attendre un peu que le log se vide complètement et que le script python termine son nettoyage
echo [VERIFY] Attente de 2s pour la finalisation des logs...
timeout /t 2 /nobreak >nul

REM 6. Chercher le commit dans verify.log
echo [VERIFY] Vérification du contenu de %LOG_FILE%...
if not exist %LOG_FILE% (
  echo FAIL (%LOG_FILE% non trouvé après l'exécution)
  exit /b 1
)

findstr /C:"[INFO] Commit effectué" %LOG_FILE% >nul
if errorlevel 1 (
  echo FAIL (commit non détecté dans %LOG_FILE%)
  echo [VERIFY] Contenu de %LOG_FILE%:
  type %LOG_FILE%
  exit /b 1
) else (
  echo OK
  echo [VERIFY] Nettoyage final des fichiers temporaires...
  del %LOG_FILE% >nul 2>&1
  del %TEST_FILE% >nul 2>&1
  if exist %PID_FILE% del %PID_FILE% >nul 2>&1
  exit /b 0
)

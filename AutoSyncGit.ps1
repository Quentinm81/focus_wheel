# Sauvegarde ce bloc dans AutoSyncGit.ps1 à la racine de ton repo
param(
    [string]$RepoPath = (Get-Location).Path,
    [int]$DebounceSeconds = 5
)

# Crée et configure le watcher
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $RepoPath
$watcher.IncludeSubdirectories = $true
$watcher.Filter = '*.*'
$watcher.EnableRaisingEvents = $true

$timer = $null

# Dès qu’un fichier change, reset le timer de debounce
Register-ObjectEvent $watcher Changed -SourceIdentifier FileChanged -Action {
    if ($timer) {
        $timer.Stop()
        $timer.Dispose()
    }
    $timer = [System.Timers.Timer]::new($DebounceSeconds * 1000)
    $timer.AutoReset = $false
    Register-ObjectEvent $timer Elapsed -SourceIdentifier DoSync -Action {
        # Exécute add/commit/push
        git -C $RepoPath add -A | Out-Null
        $msg = "auto-sync: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
        $commitOutput = git -C $RepoPath commit -m $msg 2>&1
        if ($commitOutput -notmatch "nothing to commit") {
            git -C $RepoPath push | Out-Null
            Write-Host "[INFO] Pushé : $msg"
        } else {
            Write-Host "[INFO] Rien à commit"
        }
        $timer.Dispose()
    }
    $timer.Start()
}

Write-Host "[INFO] Surveillance de : $RepoPath"
Write-Host "[INFO] Appuie sur Entrée pour arrêter..."
Read-Host

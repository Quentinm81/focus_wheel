#!/usr/bin/env bash
set -euo pipefail

# Suivre les logs de l'app Flutter/Android
# Usage:
#   bash scripts/android_logs.sh [--flutter] [--appId com.example.focus_wheel] [--device <id>]

APP_ID="com.example.focus_wheel"
DEVICE_ID=""
ONLY_FLUTTER=false

while [[ $# -gt 0 ]]; do
	case "$1" in
		--appId)
			APP_ID="$2"; shift 2;;
		--device)
			DEVICE_ID="$2"; shift 2;;
		--flutter)
			ONLY_FLUTTER=true; shift;;
		*)
			echo "Argument inconnu: $1" >&2; exit 1;;
	 esac
done

if ! command -v adb >/dev/null 2>&1; then
	echo "Erreur: 'adb' introuvable." >&2
	exit 1
fi

DEVICE_OPT=()
if [[ -n "$DEVICE_ID" ]]; then
	DEVICE_OPT=( -s "$DEVICE_ID" )
fi

# Filtre des logs
if [[ "$ONLY_FLUTTER" == true ]]; then
	FILTER='flutter|DartVM|FlutterActivity|AndroidRuntime|FATAL EXCEPTION|FocusWheel'
else
	FILTER='Flutter|Dart|AndroidRuntime|FATAL EXCEPTION|FocusWheel|$APP_ID'
fi

echo "Suivi des logs (appId=$APP_ID, device=${DEVICE_ID:-auto})"
exec adb "${DEVICE_OPT[@]}" logcat | grep -E --line-buffered "$FILTER"


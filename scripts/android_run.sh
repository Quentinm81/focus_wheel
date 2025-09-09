#!/usr/bin/env bash
set -euo pipefail

# Lancement de l'application Flutter sur un appareil Android connecté
# Utilisation:
#   bash scripts/android_run.sh [DEVICE_ID]
# ou
#   DEVICE_ID=<id> bash scripts/android_run.sh

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

require_cmd() {
	if ! command -v "$1" >/dev/null 2>&1; then
		echo "Erreur: '$1' introuvable. Installez-le puis réessayez." >&2
		exit 1
	fi
}

require_cmd flutter
require_cmd adb

# Assure la présence d'android/local.properties avec flutter.sdk
local_props="$project_root/android/local.properties"
if [[ ! -f "$local_props" ]]; then
	flutter_bin="$(command -v flutter)"
	flutter_bin_real="$(readlink -f "$flutter_bin" 2>/dev/null || echo "$flutter_bin")"

	if [[ -n "${FLUTTER_SDK:-}" ]]; then
		flutter_sdk="$FLUTTER_SDK"
	else
		flutter_sdk="$(cd "$(dirname "$flutter_bin_real")/.." && pwd)"
	fi

	if [[ ! -x "$flutter_sdk/bin/flutter" ]]; then
		echo "Impossible de déduire automatiquement flutter.sdk. Définissez FLUTTER_SDK=/chemin/vers/flutter et relancez." >&2
		exit 1
	fi

	mkdir -p "$(dirname "$local_props")"
	printf "flutter.sdk=%s\n" "$flutter_sdk" > "$local_props"
	echo "Écrit $local_props avec flutter.sdk=$flutter_sdk"
fi

pushd "$project_root" >/dev/null
flutter --version
flutter pub get

device_id="${1:-${DEVICE_ID:-}}"

if [[ -n "$device_id" ]]; then
	flutter run -d "$device_id"
else
	# Tentative de sélection automatique si un seul appareil Android est détecté
	num_android_devices="$(flutter devices | awk '/android/ && /•/ { c++ } END { print c+0 }')"
	if [[ "$num_android_devices" -eq 1 ]]; then
		flutter run -d android
	else
		echo "Plusieurs appareils détectés ou aucun. Spécifiez un ID :" >&2
		flutter devices || true
		echo "Relancez: bash scripts/android_run.sh <device_id>" >&2
		exit 2
	fi
fi
popd >/dev/null


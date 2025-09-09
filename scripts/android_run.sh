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

# Pré-vérification: présence d'un appareil Samsung
requested_device_id="${1:-${DEVICE_ID:-}}"

# Récupère la liste des appareils ADB en état "device"
mapfile -t _adb_ids < <(adb devices -l | awk 'NR>1 && $2=="device" {print $1}') || true

if [[ -n "$requested_device_id" ]]; then
	# Vérifie que l'ID demandé est bien connecté
	if [[ ! " ${_adb_ids[*]} " =~ " ${requested_device_id} " ]]; then
		echo "Aucun appareil avec l'ID ${requested_device_id} n'est connecté (ou pas autorisé)." >&2
		exit 2
	fi
	manuf="$(adb -s "$requested_device_id" shell getprop ro.product.manufacturer 2>/dev/null | tr -d '\r' | tr '[:upper:]' '[:lower:]')"
	[[ -z "$manuf" ]] && manuf="$(adb -s "$requested_device_id" shell getprop ro.vendor.product.manufacturer 2>/dev/null | tr -d '\r' | tr '[:upper:]' '[:lower:]')"
	[[ -z "$manuf" ]] && manuf="$(adb -s "$requested_device_id" shell getprop ro.product.brand 2>/dev/null | tr -d '\r' | tr '[:upper:]' '[:lower:]')"
	if [[ "$manuf" != *samsung* ]]; then
		echo "L'appareil ${requested_device_id} n'est pas reconnu comme un Samsung (manufacturer='${manuf:-inconnu}')." >&2
		exit 2
	fi
	export DEVICE_ID="$requested_device_id"
else
	# Recherche automatique d'un appareil Samsung
	declare -a samsung_ids=()
	for _id in "${_adb_ids[@]:-}"; do
		manuf="$(adb -s "$_id" shell getprop ro.product.manufacturer 2>/dev/null | tr -d '\r' | tr '[:upper:]' '[:lower:]')"
		[[ -z "$manuf" ]] && manuf="$(adb -s "$_id" shell getprop ro.vendor.product.manufacturer 2>/dev/null | tr -d '\r' | tr '[:upper:]' '[:lower:]')"
		[[ -z "$manuf" ]] && manuf="$(adb -s "$_id" shell getprop ro.product.brand 2>/dev/null | tr -d '\r' | tr '[:upper:]' '[:lower:]')"
		if [[ "$manuf" == *samsung* ]]; then
			samsung_ids+=("$_id")
		fi
	done

	if [[ ${#samsung_ids[@]} -eq 0 ]]; then
		echo "Aucun appareil Samsung détecté. Branchez le téléphone, activez le débogage USB et autorisez l'empreinte (adb devices)." >&2
		exit 2
	elif [[ ${#samsung_ids[@]} -gt 1 ]]; then
		echo "Plusieurs appareils Samsung détectés. Spécifiez un ID: DEVICE_ID=<id> bash scripts/android_run.sh" >&2
		printf '%s\n' "${samsung_ids[@]}"
		exit 2
	else
		export DEVICE_ID="${samsung_ids[0]}"
		echo "Appareil Samsung détecté: $DEVICE_ID"
	fi
fi

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


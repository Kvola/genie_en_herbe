#!/usr/bin/env bash
# Construit les APK de version finale, un par type de processeur (plus légers) :
#   dist/GenieEnHerbe-<version>.apk          téléphones récents (arm64), le bon dans 95 % des cas
#   dist/GenieEnHerbe-<version>-ancien.apk   anciens téléphones 32 bits (armeabi-v7a)
#
# Avant de construire, les tests de l'application tournent : un APK ne part jamais si l'un échoue.
# existe, sinon clé de développement (avertissement affiché).
set -euo pipefail
cd "$(dirname "$0")/.."

flutter test
flutter build apk --release --split-per-abi

version=$(grep '^version:' pubspec.yaml | sed -E 's/version: *([^+]+).*/\1/')
out=build/app/outputs/flutter-apk
mkdir -p dist
cp "$out/app-arm64-v8a-release.apk" "dist/GenieEnHerbe-$version.apk"
cp "$out/app-armeabi-v7a-release.apk" "dist/GenieEnHerbe-$version-ancien.apk"

# Empreintes SHA-256 : permettent de vérifier qu'un APK reçu (WhatsApp, Drive…)
# est bien celui-ci (`shasum -a 256 -c GenieEnHerbe-<version>.sha256` dans dist/).
(cd dist && shasum -a 256 "GenieEnHerbe-$version.apk" "GenieEnHerbe-$version-ancien.apk" > "GenieEnHerbe-$version.sha256")

if [ -f android/key.properties ]; then
  echo "Signé avec la clé de publication (android/key.properties)."
else
  echo "ATTENTION : signé avec la clé de DÉVELOPPEMENT (android/key.properties absent)."
fi
ls -lh dist/GenieEnHerbe-"$version"*.apk | awk '{print $5, $9}'
echo "Empreintes : dist/GenieEnHerbe-$version.sha256"

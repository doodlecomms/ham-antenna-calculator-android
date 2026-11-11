#!/bin/bash
# Builds a signed release APK with the Android SDK command-line tools (no Gradle).
# Needs: Android SDK (build-tools 36.0.0, platform android-36) and a JDK 17+.
# Signing: set KEYSTORE, KEY_ALIAS and KEYSTORE_PASS (see README "Building").
set -euo pipefail
cd "$(dirname "$0")"
SDK="${ANDROID_HOME:-$HOME/Library/Android/sdk}"
BT="$SDK/build-tools/36.0.0"
JAR="$SDK/platforms/android-36/android.jar"
export JAVA_HOME="${JAVA_HOME:-/Applications/Android Studio.app/Contents/jbr/Contents/Home}"
export PATH="$JAVA_HOME/bin:$PATH"
: "${KEYSTORE:?set KEYSTORE to the release keystore path}"
: "${KEY_ALIAS:?set KEY_ALIAS}"
: "${KEYSTORE_PASS:?set KEYSTORE_PASS}"
VERSION=$(sed -n 's/.*android:versionName="\([^"]*\)".*/\1/p' android/AndroidManifest.xml)

rm -rf build && mkdir -p build/res build/gen build/classes build/apk/assets
"$BT/aapt2" compile --dir android/res -o build/res/res.zip
"$BT/aapt2" link -o build/base.apk -I "$JAR" --manifest android/AndroidManifest.xml \
  --java build/gen build/res/res.zip
"$JAVA_HOME/bin/javac" -source 11 -target 11 -nowarn -classpath "$JAR" -d build/classes \
  $(find android/src build/gen -name '*.java') 2> >(grep -v 'bootstrap classpath' >&2)
"$BT/d8" --release --min-api 26 --lib "$JAR" --output build $(find build/classes -name '*.class')

cp build/base.apk build/unsigned.apk
( cd build && zip -q unsigned.apk classes.dex )
mkdir -p build/apk/assets/www && cp -R www/. build/apk/assets/www/
( cd build/apk && zip -q -r ../unsigned.apk assets )

"$BT/zipalign" -f -p 4 build/unsigned.apk build/aligned.apk
# One APK with a fixed name: releases/latest/download/antenna-calculator.apk always works,
# and Obtainium never has to ask which file to pick.
OUT="dist/antenna-calculator.apk"
mkdir -p dist
"$BT/apksigner" sign --ks "$KEYSTORE" --ks-key-alias "$KEY_ALIAS" \
  --ks-pass env:KEYSTORE_PASS --key-pass env:KEYSTORE_PASS --out "$OUT" build/aligned.apk
"$BT/apksigner" verify --print-certs "$OUT" | head -3
echo "Built $OUT (version $VERSION)"

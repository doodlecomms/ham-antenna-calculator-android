# Antenna Calculator for Android (offline)

An offline Android app of the **[Ham Antenna Calculator by N7SIX](https://github.com/N7SIX/ham-antenna-calculator)**:
dipole, inverted-V, folded dipole, end-fed half wave, quarter-wave, half-wave and
five-eighth-wave verticals, dual-band 2 m + 70 cm vertical, Yagi, full-wave loop and
cubical quad dimensions in feet and metres, with radiation-pattern plots.

<a href="https://apps.obtainium.imranr.dev/redirect?r=obtainium://add/https://github.com/doodlecomms/ham-antenna-calculator-android">
  <img src="https://raw.githubusercontent.com/ImranR98/Obtainium/main/assets/graphics/badge_obtainium.png" alt="Get it on Obtainium" height="56">
</a>

## Works completely offline

- Everything the calculator needs is packaged inside the APK. Nothing is downloaded.
- The app asks for **no permissions at all**, not even internet access, so it can't go
  online even if it wanted to. It works in airplane mode, in the field, anywhere.
- No ads, no tracking, no account.

Your last inputs are remembered on the phone. **Print / save as PDF** uses Android's
print screen, **Export CSV** asks where to save the file, and **Copy results** copies to
the clipboard. Links to websites open in your browser.

## Install

**With Obtainium (recommended):** install [Obtainium](https://github.com/ImranR98/Obtainium),
then tap the badge above on your phone, tap **Add**, then **Install**. Obtainium tells you
when there's a new version.

**Direct download:** [antenna-calculator.apk](https://github.com/doodlecomms/ham-antenna-calculator-android/releases/latest/download/antenna-calculator.apk)
(always the latest release). Android will ask you to allow installing from your browser or
file manager.

- Package ID: `com.doodlecomms.antennacalculator`
- Signing certificate SHA-256:
  `8f:45:9d:dd:8d:af:95:ba:a6:87:78:0b:b0:78:bd:77:b2:d5:fb:de:54:d8:d8:c5:2b:2b:02:33:79:f7:1c:35`

Every release is signed with this same key, so new versions install over old ones and
keep your settings.

This app is part of [73 Android](https://doodlecomms.github.io/73_Android/), a curated set
of ham radio apps for Android.

## Credits and license

The calculator itself (everything in [`www/`](www/) except `android-bridge.js`) is the
work of **N7SIX**, from [N7SIX/ham-antenna-calculator](https://github.com/N7SIX/ham-antenna-calculator)
(commit `c98a2cc`, v7.6.4), used under the MIT license. N7SIX's original license is kept at
[`www/LICENSE-N7SIX.txt`](www/LICENSE-N7SIX.txt). Please report calculator issues
upstream.

The Android packaging (the `android/` folder, `www/android-bridge.js` and `build.sh`) is by
doodlecomms. The whole project is MIT licensed; see [LICENSE](LICENSE). This is an
independent Android build and isn't an official N7SIX release.

## Building

`build.sh` builds the signed APK with the Android SDK command-line tools (no Gradle):
build-tools 36.0.0, platform android-36, and a JDK 17 or newer.

```bash
KEYSTORE=/path/to/release.jks KEY_ALIAS=antenna-calculator KEYSTORE_PASS=... ./build.sh
```

The APK lands in `dist/antenna-calculator.apk`. To release a new version, bump
`android:versionCode` and `android:versionName` in `android/AndroidManifest.xml`, build,
and attach `antenna-calculator.apk` to a new GitHub Release tagged `vX.Y.Z`. Attach only
that one APK.

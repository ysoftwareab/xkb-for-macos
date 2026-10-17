#!/usr/bin/env bash
set -euo pipefail

# Generate macOS icns flags for each y-xkb-<cc>*.keylayout using flagcdn.com
# Public-domain flag images -> padded square -> 16/32/128px -> iconutil.

T=.opencode-icons-tmp
mkdir -p "$T"
trap 'rm -rf "$T" XX.iconset values.log' EXIT

for lay in y-xkb-*.keylayout; do
  stem=${lay#y-xkb-}
  stem=${stem%.keylayout}
  cc=${stem%%-*}
  case $cc in
    pc|epo) continue ;;
    jv) cc=id ;;
    mao) cc=nz ;;
    ara) cc=eg ;;
    latam) cc=es ;;
  esac
  f=$T/$cc.padded.png
  icns=$T/$cc.icns
  if [[ ! -f $icns ]]; then
    [[ -f $T/$cc.png ]] || curl -fsS "https://flagcdn.com/w640/$cc.png" -o "$T/$cc.png"
    cp "$T/$cc.png" "$f"
    sips -p 640 640 --padColor FFFFFF "$f" >/dev/null
    rm -rf XX.iconset && mkdir XX.iconset
    sips -z 16 16 "$f" --out XX.iconset/icon_16x16.png >/dev/null
    sips -z 32 32 "$f" --out XX.iconset/icon_16x16@2x.png >/dev/null
    sips -z 32 32 "$f" --out XX.iconset/icon_32x32.png >/dev/null
    sips -z 64 64 "$f" --out XX.iconset/icon_32x32@2x.png >/dev/null
    sips -z 128 128 "$f" --out XX.iconset/icon_128x128.png >/dev/null
    iconutil -c icns XX.iconset -o "$icns"
  fi
  cp -f "$icns" "${lay%.keylayout}.icns"
done

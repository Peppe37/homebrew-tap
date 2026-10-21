#!/bin/bash
# Checks the cask against the real release: the style, the checksum of the DMG, and that the app inside has
# the version the cask says. Runs on macOS (it mounts the DMG).
set -euo pipefail
cd "$(dirname "$0")/.."

# Which cask to check: notcholino (the default) or splash. The app and its repository have the same name, capitalised.
token="${1:-notcholino}"
name="$(printf '%s' "${token:0:1}" | tr '[:lower:]' '[:upper:]')${token:1}"
cask="Casks/${token}.rb"
version=$(sed -n 's/^  version "\(.*\)"/\1/p' "$cask")
sha=$(sed -n 's/^  sha256 "\(.*\)"/\1/p' "$cask")
url="https://github.com/Peppe37/${name}/releases/download/v${version}/${name}-${version}.dmg"

echo "== style"
# brew only styles casks that sit in a tap, so put a copy in a throwaway one
scratch="scratch/check-$$"
brew tap-new --no-git "$scratch" >/dev/null 2>&1
scratch_dir=$(brew --repository "$scratch")
mkdir -p "$scratch_dir/Casks"
cp "$cask" "$scratch_dir/Casks/"
trap 'brew untap --force "$scratch" >/dev/null 2>&1 || true' EXIT
brew style --cask "$scratch_dir/Casks/${token}.rb"

echo "== download $url"
dmg=$(mktemp -d)/${name}.dmg
curl -fsSL -o "$dmg" "$url"
actual=$(shasum -a 256 "$dmg" | cut -d' ' -f1)
[ "$actual" = "$sha" ] || { echo "checksum mismatch: cask $sha, download $actual"; exit 1; }
echo "checksum ok"

echo "== the app inside"
mount=$(mktemp -d)
hdiutil attach -nobrowse -readonly -mountpoint "$mount" "$dmg" >/dev/null
trap 'hdiutil detach "$mount" >/dev/null 2>&1 || true; brew untap --force "$scratch" >/dev/null 2>&1 || true' EXIT
plist="$mount/${name}.app/Contents/Info.plist"
[ -f "$plist" ] || { echo "no ${name}.app in the DMG"; exit 1; }
built=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "$plist")
expected="${version%-alpha}"
[ "$built" = "$expected" ] || { echo "the app is version $built, the cask says $version"; exit 1; }
echo "version $built ok"

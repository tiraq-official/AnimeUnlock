#!/usr/bin/env bash
#
# Install the AnimeUnlock SDDM theme.
#
set -euo pipefail

THEME="AnimeUnlock"
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="/usr/share/sddm/themes/${THEME}"

echo "==> Installing ${THEME} to ${DEST}"
sudo mkdir -p "${DEST}"
sudo cp -r "${SRC}/." "${DEST}/"

echo "==> Pointing SDDM at the theme"
sudo mkdir -p /etc/sddm.conf.d
printf '[Theme]\nCurrent=%s\n' "${THEME}" | sudo tee /etc/sddm.conf.d/zz-animeunlock.conf >/dev/null

cat <<EOF

Done.

  Theme folder : ${DEST}
  SDDM drop-in : /etc/sddm.conf.d/zz-animeunlock.conf

Preview it without logging out (optional):

  sddm-greeter --test-mode --theme ${DEST}

Otherwise just log out or run:  sudo systemctl restart sddm

Tweak colours, the prompt text, the wallpaper, ... in:
  ${DEST}/theme.conf

If you change the wallpaper, regenerate the blurred copy:
  python3 ${DEST}/make_blur.py
EOF

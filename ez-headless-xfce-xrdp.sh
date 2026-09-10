#!/bin/bash
set -euo pipefail
shopt -s nullglob

CODENAME="$(. /etc/os-release && echo "$VERSION_CODENAME")"

SRCS=(/etc/apt/sources.list /etc/apt/sources.list.d/*.list /etc/apt/sources.list.d/*.sources)

for f in "${SRCS[@]}"; do
  cp -a "$f" "${f}.bak-$(date +%s)"
done

# Main pool -> archive
sed -i -e 's|https\?://deb\.debian\.org/debian|https://archive.debian.org/debian|g' \
       -e 's|https\?://ftp\.[a-z]*\.debian\.org/debian|https://archive.debian.org/debian|g' \
       "${SRCS[@]}"

# Security + -updates don't exist for this release anywhere. Comment them out.
sed -i -e 's|^\([[:space:]]*deb.*security\.debian\.org.*\)$|# \1|' \
       -e 's|^\([[:space:]]*deb.*debian-security.*\)$|# \1|' \
       -e "s|^\([[:space:]]*deb.*${CODENAME}-updates.*\)$|# \1|" \
       "${SRCS[@]}"

echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until

rm -rf /var/lib/apt/lists/*
apt-get update

DEBIAN_FRONTEND=noninteractive apt-get install -y \
  -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
  xrdp xfce4 sakura firefox-esr dbus-x11

sed -i 's|^exec .*Xsession.*|exec startxfce4|' /etc/xrdp/startwm.sh
systemctl enable --now xrdp

echo "Setup complete. RDP on 3389."

#!/bin/bash
set -euo pipefail

CODENAME="$(. /etc/os-release && echo "$VERSION_CODENAME")"

cp -a /etc/apt/sources.list "/etc/apt/sources.list.bak-$(date +%s)"

# Main pool -> archive.
sed -i -e 's|https\?://deb\.debian\.org/debian|https://archive.debian.org/debian|g' \
       -e 's|https\?://ftp\.[a-z]*\.debian\.org/debian|https://archive.debian.org/debian|g' \
       /etc/apt/sources.list

# Security and -updates do not exist on archive for this release. Kill both.
sed -i -e 's|^\(deb.*security\.debian\.org.*\)$|# \1|' \
       -e 's|^\(deb.*debian-security.*\)$|# \1|' \
       -e "s|^\(deb.*${CODENAME}-updates.*\)$|# \1|" \
       /etc/apt/sources.list

echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until

rm -rf /var/lib/apt/lists/*
apt-get update

DEBIAN_FRONTEND=noninteractive apt-get install -y \
    -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
    xrdp xfce4 sakura firefox-esr dbus-x11

sed -i 's|^exec .*Xsession.*|exec startxfce4|' /etc/xrdp/startwm.sh
systemctl enable --now xrdp

echo "Setup complete. RDP on 3389."

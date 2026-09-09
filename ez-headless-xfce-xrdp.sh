#!/bin/bash
set -euo pipefail

CODENAME="$(. /etc/os-release && echo "$VERSION_CODENAME")"

# ---- Fix the repos. Always. No checks, no probes. ----
cp -a /etc/apt/sources.list "/etc/apt/sources.list.bak-$(date +%s)"

sed -i -e 's|https\?://[a-z.]*security\.debian\.org/debian-security|https://archive.debian.org/debian-security|g' \
       -e 's|https\?://deb\.debian\.org/debian|https://archive.debian.org/debian|g' \
       -e 's|https\?://ftp\.[a-z]*\.debian\.org/debian|https://archive.debian.org/debian|g' \
       -e "s|^\(deb.*${CODENAME}-updates.*\)$|# \1|" \
       /etc/apt/sources.list

echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until

rm -rf /var/lib/apt/lists/*
apt-get update

# ---- Install ----
DEBIAN_FRONTEND=noninteractive apt-get install -y \
    -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
    xrdp xfce4 sakura firefox-esr dbus-x11

# ---- Configure ----
sed -i 's|^exec .*Xsession.*|exec startxfce4|' /etc/xrdp/startwm.sh
systemctl enable --now xrdp

echo "Setup complete. RDP on 3389."

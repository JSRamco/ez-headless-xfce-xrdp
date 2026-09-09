#!/bin/bash
set -uo pipefail

CODENAME="$(. /etc/os-release && echo "$VERSION_CODENAME")"

needs_archive() {
    # Non-zero, or an expiry complaint, means this release is done.
    local out
    out="$(apt-get update 2>&1)" || return 0
    grep -qiE 'is expired|Release file.*not valid' <<<"$out" && return 0
    return 1
}

if needs_archive; then
    echo "==> ${CODENAME} is EOL — repointing to archive.debian.org"
    cp -a /etc/apt/sources.list "/etc/apt/sources.list.bak-$(date +%s)"
    sed -i -e 's|https\?://[a-z.]*security\.debian\.org/debian-security|https://archive.debian.org/debian-security|g' \
           -e 's|https\?://deb\.debian\.org/debian|https://archive.debian.org/debian|g' \
           -e "s|^\(deb.*${CODENAME}-updates.*\)$|# \1|" \
           /etc/apt/sources.list
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until
fi

set -e
rm -rf /var/lib/apt/lists/*
apt-get update

DEBIAN_FRONTEND=noninteractive apt-get install -y \
    -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
    xrdp xfce4 sakura firefox-esr dbus-x11

sed -i 's|^exec .*Xsession.*|exec startxfce4|' /etc/xrdp/startwm.sh
systemctl enable --now xrdp
echo "Setup complete. RDP on 3389."

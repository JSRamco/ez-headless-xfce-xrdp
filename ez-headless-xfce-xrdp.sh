#!/bin/bash
# Update and install required packages
echo "Updating package list and installing XRDP, XFCE, Sakura, and Firefox..."
sudo apt update
# Configure XRDP to use XFCE
sudo DEBIAN_FRONTEND=noninteractive apt install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" xrdp xfce4 sakura firefox-esr
echo "Configuring XRDP to use XFCE..."
sudo sed -i 's/^exec.*/exec startxfce4/' /etc/xrdp/startwm.sh
# Restart XRDP service
echo "Restarting XRDP service..."
sudo systemctl restart xrdp
# Display completion message
echo "Setup complete! Connect via RDP to access your XFCE desktop."
echo "You can manually launch Sakura and Firefox from the XFCE menu."


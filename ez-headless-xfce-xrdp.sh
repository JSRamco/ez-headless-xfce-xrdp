#!/bin/bash
# Install packages
echo "Updating packages and installing XRDP, XFCE, Sakura, and Firefox..."
sudo apt update && sudo apt install -y xrdp xfce4 sakura firefox-esr
# Configure XRDP to use XFCE
echo "Configuring XRDP to use XFCE..."
sudo sed -i 's/^exec.*/exec startxfce4/' /etc/xrdp/startwm.sh
# Restart XRDP
echo "Restarting XRDP service..."
sudo systemctl restart xrdp
# Completion message
echo "Setup complete! Connect via RDP to access your XFCE desktop."
echo "You can manually launch Sakura and Firefox from the XFCE menu."

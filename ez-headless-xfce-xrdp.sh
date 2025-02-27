#!/bin/bash
# Configure PAM for XRDP (skip prompt)
echo "Configuring PAM for XRDP..."
sudo debconf-set-selections <<EOF
xrdp xrdp/use_pam_config boolean true
EOF
# Update and install required packages
echo "Updating package list and installing XRDP, XFCE, Sakura, and Firefox..."
sudo apt update
sudo apt install -y xrdp xfce4 sakura firefox-esr
# Configure XRDP to use XFCE
echo "Configuring XRDP to use XFCE..."
sudo sed -i 's/^exec.*/exec startxfce4/' /etc/xrdp/startwm.sh
# Restart XRDP service
echo "Restarting XRDP service..."
sudo systemctl restart xrdp
# Display completion message
echo "Setup complete! Connect via RDP to access your XFCE desktop."
echo "You can manually launch Sakura and Firefox from the XFCE menu."

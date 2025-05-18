#!/bin/bash
#
# install-nginx-lb.sh (RHEL 9)
# Installs Nginx, enables SELinux permission for backend connections,
# and prepares firewall for HTTP connections.
#
# Usage:
#   sudo bash install-nginx-lb.sh

set -euo pipefail

echo "1️⃣ Installing EPEL and Nginx..."
dnf install -y epel-release
dnf install -y nginx

echo "2️⃣ Enabling and starting Nginx service..."
systemctl enable --now nginx

echo "3️⃣ Configuring firewall for HTTP (port 80)..."
if systemctl is-active --quiet firewalld; then
  firewall-cmd --permanent --add-service=http
  firewall-cmd --reload
fi

echo "4️⃣ Applying SELinux fix for Nginx outbound connections..."
setsebool -P httpd_can_network_connect 1

echo "✅ Installation complete. You can now manually configure your load balancer."

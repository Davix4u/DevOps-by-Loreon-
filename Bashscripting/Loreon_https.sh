#!/bin/bash
# loreon_https.sh - Enable HTTPS for Loreon Learning Platform using Let's Encrypt (Certbot)

LOG_FILE="/var/log/loreon_https.log"
exec > >(tee -a ${LOG_FILE}) 2>&1
set -e  # Exit if any command fails

echo "------------------------------------------------------"
echo "🔐 Loreon HTTPS Setup Started at $(date)"
echo "------------------------------------------------------"

# Check for .env file
if [ ! -f .env ]; then
    echo "❌ ERROR: .env file not found."
    echo "Please make sure DOMAIN_NAME and ADMIN_EMAIL are set."
    exit 1
fi

# Load environment variables
set -a
source .env
set +a

# Validate required variables
if [ -z "$DOMAIN_NAME" ] || [ -z "$ADMIN_EMAIL" ]; then
    echo "❌ ERROR: DOMAIN_NAME or ADMIN_EMAIL not set in .env"
    exit 1
fi

echo "========== Checking Apache =========="
if ! systemctl is-active --quiet apache2; then
    echo "  Starting Apache..."

     sudo systemctl start apache2
else
    echo "✅ Apache is already running."
fi

echo "========== Configuring Firewall for HTTPS =========="
if ! sudo systemctl is-active --quiet firewalld; then
    echo "  Starting firewalld..."
    sudo systemctl start firewalld
fi

# Add only if not already open
sudo firewall-cmd --list-ports | grep -q "443/tcp" || sudo firewall-cmd --permanent --add-port=443/tcp
sudo firewall-cmd --list-ports | grep -q "80/tcp" || sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --reload
echo "✅ Firewall configured to allow HTTP (80) and HTTPS (443)."

echo "========== Installing Certbot (if missing) =========="
if ! command -v certbot &> /dev/null; then
    echo "  Installing Certbot..."
    sudo apt update -y
    sudo apt install -y certbot python3-certbot-apache
else
    echo "✅ Certbot already installed."
fi

echo "========== Requesting SSL Certificate =========="
sudo certbot --apache -d $DOMAIN_NAME -d www.$DOMAIN_NAME --non-interactive --agree-tos -m $ADMIN_EMAIL || {
    echo "❌ Certbot failed. Please check domain DNS or Apache configuration."
        exit 1
}

echo "========== Setting Auto Renewal =========="
sudo systemctl enable certbot.timer
sudo systemctl start certbot.timer
sudo certbot renew --dry-run

echo "------------------------------------------------------"
echo "✅ HTTPS successfully configured for $DOMAIN_NAME"
echo "Certificates will auto-renew every 90 days."
echo "------------------------------------------------------"

    

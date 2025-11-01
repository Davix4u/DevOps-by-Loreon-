#!/bin/bash
# Loreon.sh - Automated deployment for the Loreon Learning Platform (PHP + MySQL + Apache)

LOG_FILE="/var/log/loreon_deploy.log"
exec > >(tee -a ${LOG_FILE}) 2>&1
set -e  # Stop the script if any command fails

echo "------------------------------------------------------"
echo "🚀 Loreon Deployment Started at $(date)"
echo "------------------------------------------------------"

# Check for .env file before continuing
if [ ! -f .env ]; then
    echo "❌ ERROR: .env file not found in current directory."
    echo "Please create it before running this script."
    exit 1
fi

source .env #load enivronmental varible
set +a

echo "========== Updating System =========="
sudo apt update -y && sudo apt upgrade -y

echo "========== Installing FirewallD =========="
sudo apt install -y firewalld
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo systemctl status firewalld --no-pager

echo "========== Installing MySQL Server =========="
sudo apt install -y mysql-server
sudo systemctl start mysql
sudo systemctl enable mysql
sudo systemctl status mysql --no-pager

# Open MySQL port
sudo firewall-cmd --permanent --zone=public --add-port=3306/tcp
sudo firewall-cmd --reload

echo "========== Configuring Database =========="
cat > configure-db.sql <<EOF
CREATE DATABASE IF NOT EXISTS learningdb;
CREATE USER IF NOT EXISTS 'learnuser'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON learningdb.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
EOF

sudo mysql < configure-db.sql

echo "========== Loading Sample Data =========="
cat > db-load-script.sql <<EOF
USE learningdb;
CREATE TABLE IF NOT EXISTS courses (
  id MEDIUMINT(8) UNSIGNED NOT NULL AUTO_INCREMENT,
  Name VARCHAR(255) DEFAULT NULL,
  Duration VARCHAR(255) DEFAULT NULL,
  ImageUrl VARCHAR(255) DEFAULT NULL,
  Description TEXT DEFAULT NULL,
  PRIMARY KEY (id)
  ) AUTO_INCREMENT=1;

INSERT INTO courses (Name, Duration, ImageUrl, Description) VALUES
('DevOps Engineering','12 weeks','c-1.png','Master CI/CD, containerization, and infrastructure automation'),
('Cybersecurity Fundamentals','10 weeks','c-2.png','Learn ethical hacking, security protocols, and threat analysis'),
('AI & Machine Learning','16 weeks','c-3.png','Build intelligent systems with Python, TensorFlow, and deep learning'),
('Cloud Engineering','14 weeks','c-4.png','Design scalable cloud solutions on AWS, Azure, and GCP'),
('FinOps & Cost Optimization','8 weeks','c-5.png','Optimize cloud costs and implement financial operations'),
('Data Engineering','12 weeks','c-6.png','Build data pipelines, ETL processes, and analytics platforms'),
('Site Reliability Engineering','10 weeks','c-7.png','Ensure system reliability, monitoring, and incident response'),
('Kubernetes & Container Orchestration','8 weeks','c-8.png','Master container deployment and orchestration at scale');
EOF

sudo mysql < db-load-script.sql

echo "========== Installing Apache, PHP, and Git =========="
sudo apt install -y apache2 php libapache2-mod-php php-mysql git

# Open port 80 for web traffic
sudo firewall-cmd --permanent --zone=public --add-port=80/tcp
sudo firewall-cmd --reload

# Configure Apache to prioritize index.php
sudo sed -i 's/index.html/index.php/g' /etc/apache2/mods-enabled/dir.conf

sudo systemctl start apache2
sudo systemctl enable apache2

echo "========== Deploying Application from GitHub =========="
sudo rm -rf /var/www/html/*
sudo git clone https://github.com/Loreon-learning-c001-26-07/loreon-learning-platform.git /var/www/html/

sudo systemctl restart apache2

echo "✅ Deployment completed successfully!"
echo "Visit your app at: http://$(curl -s ifconfig.me)"

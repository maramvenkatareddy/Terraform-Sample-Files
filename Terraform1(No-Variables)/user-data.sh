#!/bin/bash
apt update -y
apt install apache2 -y
echo "hello terraform" > /var/www/html/index.html
systemctl start apache2 
systemctl enable apache2

#!/bin/bash
yum install -y certbot python3-certbot-apache
certbot --apache -m email@example.com --agree-tos --no-eff-email -d domena.com -d www.domena.com
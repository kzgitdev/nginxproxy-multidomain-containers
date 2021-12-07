#!/bin/bash

#
# cert registration script
# 
# USAGE:
#   step1: docker-compose up -d web
#   step2: exec cert_regist.sh to regist and get certifications
# Notice:
#    remove the option --dry-run -v with production mode
EMAIL=user@example.com
DOMAIN=subdomain.example.com

docker-compose run --rm cert certonly \
  --webroot -w /var/www/html \
  -d ${DOMAIN} \
  --non-interactive --agree-tos -m ${EMAIL} \
  --dry-run -v

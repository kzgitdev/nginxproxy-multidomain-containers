#!/bin/bash

###
# certbot renew by crontab 
#
# PARAMS
#   USERNAME : set linux username that build docker containers
#   WORK_DIRS: set the directory contains docker-compose.yml
#
# USAGE 
#  Here is an example to run weekly thuseday 
#  $ crontab -e
#  32 4 * * 1 /home/USERNAME/shell/cert_renew.sh

USERNAME=username
WORK_DIRS=(
  /home/${USERNAME}/docker/example.com/www
  /home/${USERNAME}/docker/example.com/webapp
)

for WORK_DIR in ${WORK_DIRS[@]}; do
  cd ${WORK_DIR}

  DOMAIN=`echo ${WORK_DIR} | cut -d "/" -f 5`
  HOSTNAME=`echo ${WORK_DIR} | cut -d "/" -f 6`

  {
    echo "---- start cert-renew ${HOSTNAME}.${DOMAIN}$(date '+%Y/%m/%d %H:%M:%S')"

    # NOTICE
    # --dry-run option is the test mode
    # Remove the option "--dry-run" in production environment  
    CERT_RENEW=$(docker-compose run --rm cert renew --dry-run -w /var/www/html --post-hook "echo qwerty")

    if echo "${CERT_RENEW}" | grep -q "qwerty"; then
       docker-compose exec web nginx -s reload
       echo "nginx is reloaded. Successfully! TLS and certificates are updated."
    else
       echo "nginx is not reloaded. Pending... Certificates are not updated."
    fi
  } >> /home/${USERNAME}/shell/cert_renew.log 2>&1
done

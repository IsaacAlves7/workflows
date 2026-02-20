#!/usr/bin/env bash

rclone copy /usr/src/wordpress ./ -P -L --transfers 64

chmod +x /var/www/html/healthcheck.sh

curl -X POST "https://api.cloudflare.com/client/v4/zones/1915398102cc0cd90a547be7239ab8a1/purge_cache" \
    -H "Authorization: Bearer ENV_CLOUDFLARE_TOKEN" \
    -H "Content-Type: application/json" \
    --data '{"purge_everything":true}'

cp /var/www/html/env-config/object-cache.php /var/www/html/wp-content/object-cache.php

apache2-foreground

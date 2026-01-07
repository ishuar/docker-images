#!/bin/sh
set -e

# Set defaults for environment variables
export POD_IP="${POD_IP:-127.0.0.1}"
export POD_NAME="${POD_NAME:-${HOSTNAME}}"
export USER="${USER:-github.com/ishuar}"
# IMAGE_VERSION is set via ENV in Dockerfile, no default needed here

# Process the template file and generate the final config
echo "Generating Nginx configuration with environment variables..."
echo "  POD_IP: ${POD_IP}"
echo "  POD_NAME: ${POD_NAME}"
echo "  IMAGE_VERSION: ${IMAGE_VERSION}"

# Fix: Use single envsubst with all variables
envsubst '${POD_IP} ${POD_NAME} ${USER} ${IMAGE_VERSION}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

# Process HTML template
envsubst '${POD_IP} ${POD_NAME} ${USER} ${IMAGE_VERSION}' < /usr/share/nginx/html/index.html.template > /usr/share/nginx/html/index.html

echo "Configuration generation complete. Starting Nginx..."

# Execute the CMD (nginx -g "daemon off;")
exec "$@"

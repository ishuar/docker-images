
ARG VERSION=1.29
ARG IMAGE_VERSION=v0.1.0

# Use the official nginx-unprivileged image as a base
FROM nginxinc/nginx-unprivileged:${VERSION} AS build

# Install necessary packages for the entrypoint script
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
  gettext-base \
  curl \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Copy our custom configuration and files
COPY --chown=101:101 entrypoint.sh /entrypoint.sh
COPY --chown=101:101 nginx.conf.template /etc/nginx/conf.d/default.conf.template
COPY --chown=101:101 index.html.template /usr/share/nginx/html/index.html.template

# Make the entrypoint script executable
RUN chmod +x /entrypoint.sh

# Last USER should not be root
USER 101

# Final stage
FROM nginxinc/nginx-unprivileged:${VERSION}

# Re-declare ARG for use in this stage (inherits value from top)
ARG IMAGE_VERSION
ARG VERSION

# Add some common labels
LABEL maintainer="Ishan Sharma <https://github.com/ishuar/>"
LABEL description="Custom nginx image for demo and debugging with pod info display"
LABEL source="https://github.com/ishuar/docker-images"
LABEL version="${IMAGE_VERSION}"
LABEL nginx_version="${VERSION}"

# Set IMAGE_VERSION as ENV so entrypoint.sh can use it
ENV IMAGE_VERSION=${IMAGE_VERSION}

# Copy files from build stage
COPY --from=build --chown=101:101 /etc/nginx/conf.d/default.conf.template /etc/nginx/conf.d/default.conf.template
COPY --from=build --chown=101:101 /usr/share/nginx/html/index.html.template /usr/share/nginx/html/index.html.template
COPY --from=build /entrypoint.sh /entrypoint.sh

# Ensure the html directory is writable by user 101
USER root
RUN chown -R 101:101 /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html
USER 101

# Add the health check using the dedicated /health endpoint
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:80/health || exit 1

# Expose the standard nginx port
EXPOSE 80

USER 101

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Default command to run nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]

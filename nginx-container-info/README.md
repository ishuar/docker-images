# Nginx Container Info

Custom Nginx container for debugging and demos in Kubernetes or other container environments. Features a responsive web interface showing pod/container metadata and live metrics.

## Quick Start

```bash
docker run -d -p 8080:80 \
  -e POD_NAME=demo-pod \
  -e POD_IP=127.0.0.100 \
  ishuar/nginx-container-info:v0.1.0
```

Open http://localhost:8080

## Features

- 📊 **Live Metrics** - Real-time nginx statistics with auto-refresh
- 📱 **Responsive UI** - Works on desktop, tablet, and mobile
- 🔍 **Debug Endpoints** - Health checks, headers echo, server info
- 🏷️ **Version Display** - Shows image version on dashboard
- 🔒 **Secure** - Runs as non-root (UID 101)

## Endpoints

| Path | Description |
|------|-------------|
| `/` | HTML dashboard with live metrics |
| `/health` | Health check (JSON) |
| `/info` | Server and client information (JSON) |
| `/headers` | Echo all request headers (JSON) |
| `/plain` | Plain text server info |
| `/nginx-status` | Nginx stub_status metrics |

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `POD_NAME` | $HOSTNAME | Pod/container name |
| `POD_IP` | 127.0.0.1 | Pod/container IP |
| `USER` | github.com/ishuar | Custom user identifier |
| `IMAGE_VERSION` | v0.1.0 | Image version (set via build ARG) |

## Building

### Local Build (Single Architecture)

```bash
# Build for your current architecture
docker build -t ishuar/nginx-container-info:v0.1.0 .

# Build with custom versions
docker build \
  --build-arg VERSION=1.29 \
  --build-arg IMAGE_VERSION=v0.2.0 \
  -t ishuar/nginx-container-info:v0.2.0 .
```

### Multi-Architecture Build (Recommended)

Build and push images for multiple architectures (amd64, arm64, arm/v7):

```bash
# Create a new builder instance (one-time setup)
docker buildx create --name multiarch --use

# Build and push multi-arch image
docker buildx build \
  --platform linux/amd64,linux/arm64,linux/arm/v7 \
  --build-arg VERSION=1.29 \
  --build-arg IMAGE_VERSION=v0.1.0 \
  -t ishuar/nginx-container-info:v0.1.0 \
  -t ishuar/nginx-container-info:latest \
  --push \
  .
```

**Note**: Multi-arch builds require `--push` flag. They cannot be loaded into local Docker daemon.

## Custom Headers

All responses include:
- `X-Pod-Name` - Pod/container name
- `X-Pod-IP` - Pod/container IP
- `X-Served-By` - Server hostname

## Use Cases

- Load balancer testing
- Network debugging
- Service mesh testing
- Kubernetes demos
- Learning networking concepts

## Metrics Explained

The live metrics from `/nginx-status` show:
- **Active Connections** - Current open connections
- **Accepts** - Total TCP connections accepted
- **Handled** - Connections successfully processed
- **Requests** - Total HTTP requests (can be higher than Accepts due to keep-alive)
- **Reading/Writing/Waiting** - Connection states

Note: Metrics are stored in memory and reset on container restart.

## Author

**Ishan Sharma** - [@ishuar](https://github.com/ishuar/)

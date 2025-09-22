# Docker Usage for Telegram Desktop Development

This repository provides Docker images to simplify building Telegram Desktop on Linux.

## Available Docker Images

### 1. Build Environment (`centos_env`)
Pre-built development environment with all dependencies:
```bash
docker pull ghcr.io/thind9xdev/tdesktop/centos_env:latest
```

### 2. Development Environment (full repository)
Complete environment with source code included:
```bash
docker pull ghcr.io/thind9xdev/tdesktop:latest
```

## Quick Start

### Option 1: Using the Build Environment Image

1. **Pull the build environment:**
   ```bash
   docker pull ghcr.io/thind9xdev/tdesktop/centos_env:latest
   ```

2. **Clone this repository:**
   ```bash
   git clone --recursive https://github.com/thind9xdev/tdesktop.git
   cd tdesktop
   ```

3. **Build Telegram Desktop:**
   ```bash
   docker run --rm -it \
       -u $(id -u) \
       -v "$PWD:/usr/src/tdesktop" \
       ghcr.io/thind9xdev/tdesktop/centos_env:latest \
       /usr/src/tdesktop/Telegram/build/docker/centos_env/build.sh \
       -D TDESKTOP_API_ID=YOUR_API_ID \
       -D TDESKTOP_API_HASH=YOUR_API_HASH
   ```

### Option 2: Using the Development Environment Image

1. **Run the development environment:**
   ```bash
   docker run --rm -it \
       -v "$(pwd)/out:/usr/src/tdesktop/out" \
       ghcr.io/thind9xdev/tdesktop:latest
   ```

2. **Inside the container, build the application:**
   ```bash
   Telegram/build/docker/centos_env/build.sh \
       -D TDESKTOP_API_ID=YOUR_API_ID \
       -D TDESKTOP_API_HASH=YOUR_API_HASH
   ```

## Getting API Credentials

You need Telegram API credentials to build the application:

1. Go to https://my.telegram.org/apps
2. Log in with your Telegram account
3. Create a new application to get your `api_id` and `api_hash`

## Troubleshooting

### "Cannot connect to the Docker daemon"

This error means Docker is not running on your system. To fix:

**On Ubuntu/Debian:**
```bash
sudo systemctl start docker
sudo systemctl enable docker
```

**On CentOS/RHEL/Fedora:**
```bash
sudo systemctl start docker
sudo systemctl enable docker
```

**On Windows/macOS:**
- Start Docker Desktop application

### Permission Issues

If you get permission errors, make sure Docker is running and your user is in the docker group:

```bash
sudo usermod -aG docker $USER
```

Then log out and log back in, or restart your terminal.

## Building Your Own Images

To build the images locally:

### Build Environment Image:
```bash
cd Telegram/build/docker/centos_env
poetry install
poetry run gen_dockerfile | DOCKER_BUILDKIT=1 docker build -t tdesktop:centos_env -
```

### Development Environment Image:
```bash
docker build -t tdesktop:dev .
```

## Visual Studio Code Integration

For VS Code development with Docker:

1. Install the [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension
2. Add your API credentials to `.vscode/settings.json`:
   ```json
   {
       "cmake.configureSettings": {
           "TDESKTOP_API_ID": "YOUR_API_ID",
           "TDESKTOP_API_HASH": "YOUR_API_HASH"
       }
   }
   ```
3. Choose "Reopen in Container" from the VS Code command palette

## More Information

- [Full Linux build instructions](docs/building-linux.md)
- [API credentials guide](docs/api_credentials.md)
- [Main repository](https://github.com/telegramdesktop/tdesktop)
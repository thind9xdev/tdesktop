#!/bin/bash

# Telegram Desktop Docker Quick Start Script
# This script helps you get started with building Telegram Desktop using Docker

set -e

echo "========================================"
echo "Telegram Desktop Docker Quick Start"
echo "========================================"
echo

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running or not installed."
    echo
    echo "To fix this:"
    echo "1. Make sure Docker is installed"
    echo "2. Start the Docker service:"
    echo "   - Ubuntu/Debian: sudo systemctl start docker"
    echo "   - CentOS/RHEL: sudo systemctl start docker"
    echo "   - Windows/macOS: Start Docker Desktop"
    echo
    echo "3. Add your user to the docker group (Linux):"
    echo "   sudo usermod -aG docker \$USER"
    echo "   Then log out and log back in."
    echo
    exit 1
fi

echo "✅ Docker is running!"
echo

# Check for API credentials
if [ -z "$TDESKTOP_API_ID" ] || [ -z "$TDESKTOP_API_HASH" ]; then
    echo "⚠️  API credentials not found in environment variables."
    echo
    echo "You need Telegram API credentials to build the application."
    echo "Get them from: https://my.telegram.org/apps"
    echo
    echo "Then set them as environment variables:"
    echo "  export TDESKTOP_API_ID=your_api_id"
    echo "  export TDESKTOP_API_HASH=your_api_hash"
    echo
    echo "Or pass them directly to the docker run command."
    echo
fi

# Offer build options
echo "Choose your build method:"
echo
echo "1. Use pre-built centos_env image (recommended)"
echo "2. Use development environment image"
echo "3. Build centos_env image locally"
echo
read -p "Enter your choice (1-3): " choice

case $choice in
    1)
        echo
        echo "🐳 Pulling centos_env image..."
        docker pull ghcr.io/thind9xdev/tdesktop/centos_env:latest
        
        echo
        echo "📁 Current directory will be mounted to the container."
        echo "🔧 Run the following command to build:"
        echo
        echo "docker run --rm -it \\"
        echo "    -u \$(id -u) \\"
        echo "    -v \"\$PWD:/usr/src/tdesktop\" \\"
        echo "    ghcr.io/thind9xdev/tdesktop/centos_env:latest \\"
        echo "    /usr/src/tdesktop/Telegram/build/docker/centos_env/build.sh \\"
        echo "    -D TDESKTOP_API_ID=\$TDESKTOP_API_ID \\"
        echo "    -D TDESKTOP_API_HASH=\$TDESKTOP_API_HASH"
        ;;
    2)
        echo
        echo "🐳 Pulling development environment image..."
        docker pull ghcr.io/thind9xdev/tdesktop:latest
        
        echo
        echo "🔧 Run the following command to start the development environment:"
        echo
        echo "docker run --rm -it \\"
        echo "    -v \"\$(pwd)/out:/usr/src/tdesktop/out\" \\"
        echo "    ghcr.io/thind9xdev/tdesktop:latest"
        ;;
    3)
        echo
        echo "🏗️  Building centos_env image locally..."
        cd Telegram/build/docker/centos_env
        
        if ! command -v poetry &> /dev/null; then
            echo "❌ Poetry is not installed. Installing..."
            curl -sSL https://install.python-poetry.org | python3 -
            export PATH="$HOME/.local/bin:$PATH"
        fi
        
        poetry install
        poetry run gen_dockerfile | DOCKER_BUILDKIT=1 docker build -t tdesktop:centos_env -
        
        echo
        echo "✅ centos_env image built successfully!"
        echo "🔧 You can now use it to build Telegram Desktop:"
        echo
        echo "docker run --rm -it \\"
        echo "    -u \$(id -u) \\"
        echo "    -v \"\$PWD:/usr/src/tdesktop\" \\"
        echo "    tdesktop:centos_env \\"
        echo "    /usr/src/tdesktop/Telegram/build/docker/centos_env/build.sh \\"
        echo "    -D TDESKTOP_API_ID=\$TDESKTOP_API_ID \\"
        echo "    -D TDESKTOP_API_HASH=\$TDESKTOP_API_HASH"
        ;;
    *)
        echo "Invalid choice. Please run the script again."
        exit 1
        ;;
esac

echo
echo "📖 For more information, see:"
echo "   - DOCKER.md (Docker usage guide)"
echo "   - docs/building-linux.md (Full build instructions)"
echo
echo "✨ Happy building!"
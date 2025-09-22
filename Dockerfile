# syntax=docker/dockerfile:1

# This Dockerfile provides a ready-to-use environment for building Telegram Desktop
# It's based on the centos_env image and includes the source code
FROM ghcr.io/thind9xdev/tdesktop/centos_env:latest

# Copy the source code
COPY . /usr/src/tdesktop

# Set working directory
WORKDIR /usr/src/tdesktop

# Set default volume for build output
VOLUME ["/usr/src/tdesktop/out"]

# Default command shows build instructions
CMD echo "Telegram Desktop build environment ready!" && \
    echo "" && \
    echo "To build Telegram Desktop, run:" && \
    echo "  Telegram/build/docker/centos_env/build.sh -D TDESKTOP_API_ID=your_id -D TDESKTOP_API_HASH=your_hash" && \
    echo "" && \
    echo "Get your API credentials from: https://my.telegram.org/apps" && \
    echo "Built files will be in the 'out' directory." && \
    /bin/bash
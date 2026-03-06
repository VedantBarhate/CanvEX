FROM node:18-bullseye

# Install wine for Windows cross-compilation
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y wine wine32 wine64 && \
    apt-get clean

# Set wine environment for electron-builder
ENV WINEDEBUG=-all
ENV ELECTRON_BUILDER_ALLOW_UNRESOLVED_DEPENDENCIES=true

# Copy scaffold into image
WORKDIR /canvex
COPY scaffold/ ./scaffold/

# Pre-install node_modules inside the image at build time
RUN cd /canvex/scaffold && npm install

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Create working and output dirs
RUN mkdir -p /build/app /input /output

ENTRYPOINT ["/entrypoint.sh"]
FROM node:lts

WORKDIR /home

# Install ffmpeg from Emby at build time based on architecture
# This avoids downloading at every container startup (200MB+ download)
ARG TARGETARCH
RUN if [ "$TARGETARCH" = "amd64" ]; then \
      LINK="https://github.com/MediaBrowser/Emby.Releases/releases/download/4.8.10.0/emby-server-deb_4.8.10.0_amd64.deb"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      LINK="https://github.com/MediaBrowser/Emby.Releases/releases/download/4.8.10.0/emby-server-deb_4.8.10.0_arm64.deb"; \
    else \
      echo "Unknown architecture: $TARGETARCH" && exit 1; \
    fi && \
    echo "Downloading Emby from $LINK" && \
    curl -L -o emby.deb $LINK && \
    ar x emby.deb data.tar.xz && \
    tar xf data.tar.xz && \
    mv opt/emby-server/bin/ffmpeg /usr/bin/ffmpeg && \
    mv opt/emby-server/lib/libav*.so.* /usr/lib/ 2>/dev/null || true && \
    mv opt/emby-server/lib/libpostproc.so.* /usr/lib/ 2>/dev/null || true && \
    mv opt/emby-server/lib/libsw* /usr/lib/ 2>/dev/null || true && \
    mv opt/emby-server/extra/lib/libva*.so.* /usr/lib/ 2>/dev/null || true && \
    mv opt/emby-server/extra/lib/libdrm.so.* /usr/lib/ 2>/dev/null || true && \
    mv opt/emby-server/extra/lib/libmfx.so.* /usr/lib/ 2>/dev/null || true && \
    mv opt/emby-server/extra/lib/libOpenCL.so.* /usr/lib/ 2>/dev/null || true && \
    rm -rf emby.deb data.tar.xz opt

COPY package.json ./
RUN yarn install --production
COPY index.js ./

EXPOSE 80
EXPOSE 5004

CMD ["node", "index.js"]

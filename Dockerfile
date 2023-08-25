FROM ubuntu:23.10

# Set environment variables to non-interactive (this prevents some prompts)
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && \
    apt-get install -y gcc pkg-config libgtk-4-dev xvfb curl build-essential autoconf xorg-dev gettext git libtool fluxbox && \
    apt-get clean

# Copy your C file into the container
COPY emoji_window.c /emoji_window.c

# Compile the C program
RUN gcc `pkg-config --cflags gtk4` -o /emoji_window /emoji_window.c `pkg-config --libs gtk4`

ARG NOVNC_REF="1.2.0"
ARG WEBSOCKIFY_REF="0.10.0"
ENV DISPLAY_NUM=99
ENV DISPLAY=":${DISPLAY_NUM}"

RUN mkdir -p /opt/bin && chmod +x /dev/shm \
  && apt-get update && apt-get install -y unzip x11vnc \
  && curl -L -o noVNC.zip "https://github.com/novnc/noVNC/archive/v${NOVNC_REF}.zip" \
  && unzip -x noVNC.zip \
  && mv noVNC-${NOVNC_REF} /opt/bin/noVNC \
  && cp /opt/bin/noVNC/vnc.html /opt/bin/noVNC/index.html \
  && rm noVNC.zip \
  && curl -L -o websockify.zip "https://github.com/novnc/websockify/archive/v${WEBSOCKIFY_REF}.zip" \
  && unzip -x websockify.zip \
  && rm websockify.zip \
  && mv websockify-${WEBSOCKIFY_REF} /opt/bin/noVNC/utils/websockify

RUN mkdir ~/.vnc
RUN x11vnc -storepasswd 1234 ~/.vnc/passwd

COPY entrypoint.sh /opt/bin/entrypoint.sh

ENTRYPOINT ["bash", "/opt/bin/entrypoint.sh"]

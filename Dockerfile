FROM ubuntu:20.04

LABEL maintainer="INTEC Inc<info-rdbox@intec.co.jp>"

ENV DEBIAN_FRONTEND=noninteractive \
    DISPLAY=:11.0

# Install xvfb and x11vnc
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        dirmngr \
        gnupg2 \
        supervisor \
        dbus-x11 \
        xvfb \
        wget \
        curl \
        python \
        x11vnc

# Install noVNC
RUN mkdir -p /opt/noVNC/utils/websockify && \
    wget --no-check-certificate -qO- "https://github.com/novnc/noVNC/archive/v1.2.0.tar.gz" | tar -zx --strip-components=1 -C /opt/noVNC && \
    wget --no-check-certificate -qO- "https://github.com/novnc/websockify/archive/v0.9.0.tar.gz" | tar -zx --strip-components=1 -C /opt/noVNC/utils/websockify && \
    ln -s /opt/noVNC/vnc.html /opt/noVNC/index.html

# Install VirtualGL
RUN apt-get install -y --no-install-recommends \
        libnvidia-gl-450 \
        ca-certificates \
        wget \
        openssh-server \
        libxtst6 \
        libxv1 \
        libglu1-mesa \
    && wget https://jaist.dl.sourceforge.net/project/virtualgl/2.6.4/virtualgl_2.6.4_amd64.deb \
    && dpkg -i virtualgl_2.6.4_amd64.deb

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY ./entrypoint.sh /entrypoint.sh
COPY ./supervisord/* /etc/supervisor/conf.d/

ENTRYPOINT ["/entrypoint.sh"]
CMD vglconnect -s -e "VGL_LOGO=${VGL_LOGO} VGL_DISPLAY=${VGL_DISPLAY} vglrun glxinfo && VGL_LOGO=${VGL_LOGO} VGL_DISPLAY=${VGL_DISPLAY} vglrun ${VGL_APP}" ubuntu@${VGL_SERVER_IP} -p ${VGL_SERVER_PORT} -o StrictHostKeyChecking=no

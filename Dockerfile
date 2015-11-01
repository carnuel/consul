FROM progrium/busybox 
MAINTAINER carnuel
USER root

# Download consul
ADD https://dl.bintray.com/mitchellh/consul/0.5.2_linux_amd64.zip /tmp/consul.zip
RUN cd /bin && unzip /tmp/consul.zip && chmod +x /bin/consul && rm /tmp/consul.zip

# Download consul web ui
ADD https://dl.bintray.com/mitchellh/consul/0.5.2_web_ui.zip /tmp/webui.zip
RUN cd /tmp && unzip /tmp/webui.zip && mv dist /ui && rm /tmp/webui.zip

# Download docker 1.9.0rc3
ADD https://test.docker.com/builds/Linux/x86_64/docker-1.9.0-rc3 /bin/docker
RUN chmod +x /bin/docker
RUN opkg-install curl bash

# Config files
ADD ./config /config/
ONBUILD ADD ./config /config/
ADD ./start /bin/start
ADD ./check-http /bin/check-http
ADD ./check-cmd /bin/check-cmd

RUN chmod +x /bin/start && chmod +x /bin/check-http && chmod +x /bin/check-cmd

EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 53/udp 
VOLUME ["/data"]
ENV SHELL /bin/bash 
ENTRYPOINT ["/bin/start"]
CMD []

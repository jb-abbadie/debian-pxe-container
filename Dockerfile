FROM alpine:3.9

# Install the necessary packages
RUN apk add --update \
  dnsmasq \
  curl \
  syslinux \
  && rm -rf /var/cache/apk/*

# Download and extract Debian
RUN mkdir -p /var/lib/tftp
WORKDIR /var/lib/tftp
RUN curl http://ftp.nl.debian.org/debian/dists/stretch/main/installer-amd64/current/images/netboot/netboot.tar.gz -o netboot.tar.gz
RUN tar xzf netboot.tar.gz
RUN rm netboot.tar.gz

# Install syslinux
RUN cp -r /usr/share/syslinux/efi64 .
RUN ln -s efi64/syslinux.efi .
RUN ln -s efi64/ldlinux.e64 .
RUN rm pxelinux.cfg/default
COPY etc/pxelinux.cfg pxelinux.cfg/default
COPY etc/preseed.cfg .
COPY etc/run-script .

ARG DHCP_SERVER
ENV DHCP_SERVER ${DHCP_SERVER:-192.168.1.1}
ARG PXE_SERVER
ENV PXE_SERVER ${PXE_SERVER:-192.168.1.1}
ARG SERVER_IP
ENV SERVER_IP ${SERVER_IP:-192.168.1.8}
ARG SERVER_HOSTNAME
ENV SERVER_HOSTNAME ${SERVER_HOSTNAME:-debian}
ARG SERVER_USER
ENV SERVER_USER ${SERVER_USER:-user}
ARG SERVER_USER_SSH_KEY
ENV SERVER_USER_SSH_KEY ${SERVER_USER_SSH_KEY:-}

# Configure DNSMASQ
COPY etc/ /etc
RUN sed -i "s/{DHCP_SERVER}/$DHCP_SERVER/" /etc/dnsmasq.conf
RUN sed -i "s/{PXE_SERVER}/$PXE_SERVER/" pxelinux.cfg/default
RUN sed -i "s/{SERVER_HOSTNAME}/$SERVER_HOSTNAME/" pxelinux.cfg/default

RUN sed -i "s/{SERVER_HOSTNAME}/$SERVER_HOSTNAME/" preseed.cfg
RUN sed -i "s/{SERVER_IP}/$SERVER_IP/" preseed.cfg
RUN sed -i "s/{SERVER_USER}/$SERVER_USER/" preseed.cfg
RUN sed -i "s|{SERVER_USER_SSH_KEY}|$SERVER_USER_SSH_KEY|" preseed.cfg

# Start dnsmasq. It picks up default configuration from /etc/dnsmasq.conf and
# /etc/default/dnsmasq plus any command line switch
ENTRYPOINT ["dnsmasq"]

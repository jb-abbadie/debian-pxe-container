FROM alpine:3.18

# Install the necessary packages
RUN apk add --no-cache --update \
  dnsmasq \
  curl \
  syslinux

# Download and extract Debian
RUN mkdir -p /var/lib/tftp
WORKDIR /var/lib/tftp
#RUN curl http://ftp.nl.debian.org/debian/dists/bullseye/main/installer-amd64/current/images/netboot/netboot.tar.gz -o netboot.tar.gz
run curl https://deb.debian.org/debian/dists/bookworm/main/installer-amd64/current/images/netboot/netboot.tar.gz -o netboot.tar.gz
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
COPY entrypoint.sh .

# Configure DNSMASQ
COPY etc/ /etc

ENTRYPOINT ["./entrypoint.sh"]

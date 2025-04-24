#ARG MAINTAINER
FROM docker.io/tiredofit/debian:bookworm
#MAINTAINER $MAINTAINER

ENV TZ="Europe/Berlin"
ENV CUPSADMIN=admin
ENV CUPSPASSWORD=password

LABEL org.opencontainers.image.source="https://github.com/wus-technik/docker-printserver"
LABEL org.opencontainers.image.description="CUPS Printer Server"
#LABEL org.opencontainers.image.author=""
#LABEL org.opencontainers.image.url="https://github.com/anujdatar/cups-docker/blob/main/README.md"
#LABEL org.opencontainers.image.licenses=MIT

# Install Packages (basic tools, cups, basic drivers, HP drivers)
RUN apt-get update \
 && apt-get install -y \
    sudo \
    whois \
    usbutils \
    cups \
    cups-client \
    cups-bsd \
    cups-filters \
    foomatic-db-compressed-ppds \
    printer-driver-all \
    openprinting-ppds \
    hpijs-ppds \
    hp-ppd \
    hplip \
    smbclient \
    printer-driver-cups-pdf \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# This will use port 631
EXPOSE 631

# Create admin user and set password
RUN useradd \
    --groups=sudo,lp,lpadmin \
    --create-home \
    --home-dir=/home/${CUPSADMIN} \
    --shell=/bin/bash \
    --password=$(openssl passwd -1 ${CUPSPASSWORD}) \
    ${CUPSADMIN} \
 && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Copy the default configuration file
#COPY --chown=root:lp cupsd.conf /etc/cups/cupsd.conf

# Default command
#CMD ["/usr/sbin/cupsd", "-f"]

COPY install /

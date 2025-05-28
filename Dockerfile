#ARG MAINTAINER
FROM docker.io/tiredofit/debian:bookworm
#MAINTAINER $MAINTAINER

ENV TZ="Europe/Berlin"
ENV CUPSADMIN=admin
ENV CUPSPASSWORD=password

# Neue ENV-Variablen für smb.conf
ENV SAMBA_WORKGROUP=WORKGROUP
ENV SAMBA_REALM=COMPANY.LOCAL
ENV SAMBA_SERVER_STRING="Print Server (cups)"

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
    avahi-daemon \
    avahi-utils \
    dbus \
    samba \
    samba-common-bin \
    winbind \
    libnss-winbind \
    libpam-winbind \
    krb5-user \
    smbclient \
    net-tools \
    dnsutils \
    curl \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# This will use port 631
EXPOSE 631 137 138 139 445

# Ensure volumes for persistent data
VOLUME ["/etc/samba", "/var/lib/samba", "/var/cache/samba", "/etc/krb5.keytab"]

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

# Create spool dir for Samba
RUN mkdir -p /var/spool/samba && chmod 1777 /var/spool/samba

# Add Samba driver share directory
RUN mkdir -p /var/lib/samba/printers/WIN64/Kyocera \
    && mkdir -p /var/lib/samba/printers/WIN64/Konica

COPY install /

# move to functions + cont-init.d
# Set permissions for CUPS model directory
RUN chmod 644 /usr/share/cups/model/*.PPD

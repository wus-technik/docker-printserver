#!/bin/bash

SMB_CONF="/etc/samba/smb.conf"
TEMPLATE_CONF="/install/etc/samba/smb.conf"

if [ ! -f "$SMB_CONF" ] || ! grep -q "${SAMBA_WORKGROUP}" "$SMB_CONF"; then
    cp "$TEMPLATE_CONF" "$SMB_CONF"
    sed -i "s|\${SAMBA_WORKGROUP}|${SAMBA_WORKGROUP}|g" "$SMB_CONF"
    sed -i "s|\${SAMBA_REALM}|${SAMBA_REALM}|g" "$SMB_CONF"
    sed -i "s|\${SAMBA_SERVER_STRING}|${SAMBA_SERVER_STRING}|g" "$SMB_CONF"
fi

exec "$@"
